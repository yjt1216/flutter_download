
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity/connectivity.dart';

import 'widget/download_list_item.dart';
import 'model/download_task_model.dart';

/// 下载记录
/// 下载完成的task
///
class DownloadRecordList extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform? platform;

  final String title;

  const DownloadRecordList({Key? key, this.platform, required this.title}) : super(key: key);

  @override
  _DownloadRecordListState createState() => _DownloadRecordListState();
}

class _DownloadRecordListState extends State<DownloadRecordList> {
  List<TaskInfo>? _tasks;
  late List<ItemHolder> _items;
  late bool _loading;
  late bool _permissionReady;
  late String _localPath;
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _loading = true;
    _permissionReady = false;

    // 下载列表
    _prepareDownloadData();
  }
  //检查是否有网络
  Future<bool> checkNetwork() async {
    Connectivity connectivity = Connectivity();
    var connectivityResult = await (connectivity.checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      debugPrint("暂无网络，请稍后再试");
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  /// 注册后台隔离并监听下载过程
  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();//移除后台隔离
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      debugPrint(
        'Callback on UI isolate: '
            'task ($taskId) is in status ($status) and process ($progress)',
      );

      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == taskId);
        setState(() {
          task
            ..status = status
            ..progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id,
      DownloadTaskStatus status,
      int progress,
      ) {
    debugPrint('Callback on background isolate: ' 'task.id ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }


  Widget _buildRRecordList() => ListView(
    padding: const EdgeInsets.symmetric(vertical: 16),
    children: [
      for (final item in _items)
        item.task == null
            ? _buildListSectionHeading(item.name!)
            : DownloadListItem(
          data: item,
          onTap: (task) {
            _openDownloadedFile(task).then((success) {
              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cannot open this file'),
                  ),
                );
              }
            });
          },
          onActionTap: (task) {
            if (task.status == DownloadTaskStatus.undefined) {
              _requestDownload(task);
            } else if (task.status == DownloadTaskStatus.running) {
              _pauseDownload(task);
            } else if (task.status == DownloadTaskStatus.paused) {
              _resumeDownload(task);
            } else if (task.status == DownloadTaskStatus.complete) {
              _delete(task);
            } else if (task.status == DownloadTaskStatus.failed) {
              _retryDownload(task);
            }else if (task.status == DownloadTaskStatus.enqueued) {
              debugPrint('enqueued');
              _delete(task);
            }
          },
        ),
    ],
  );

  Widget _buildListSectionHeading(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildNoPermissionWarning() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Grant storage permission to continue',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: _retryRequestPermission,
            child: const Text(
              'Retry',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }

    setState(() {
      _permissionReady = hasGranted;
    });
  }

  Future<void> _requestDownload(TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
      url: task.link!,
      headers: {'auth': 'test_for_sql_encoding'},
      savedDir: _localPath,
      saveInPublicStorage: true,
    );
  }

  // // Not used in the example.
  // void _cancelDownload(TaskInfo task) async {
  //   await FlutterDownloader.cancel(taskId: task.taskId!);
  // }

  Future<void> _pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  Future<void> _resumeDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<void> _retryDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(TaskInfo? task) {
    if (task != null) {
      return FlutterDownloader.open(taskId: task.taskId!);
    } else {
      return Future.value(false);
    }
  }

  Future<void> _delete(TaskInfo task) async {
    await FlutterDownloader.remove(
      taskId: task.taskId!,
      shouldDeleteContent: true,
    );
    await _prepareDownloadData();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    if (widget.platform == TargetPlatform.android &&
        androidInfo.version.sdkInt <= 28) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  /// 准备下载数据Mock
  Future<void> _prepareDownloadData() async {
    ///获取已知下载任务
    final tasks = await FlutterDownloader.loadTasks();

    if (tasks == null) {
      debugPrint('No tasks were retrieved from the database.');
      return;
    }

    var count = 0;
    _tasks = [];
    _items = [];

    _tasks!.addAll(tasks.map((e) {
      debugPrint(e.url);
      var name = e.url.substring(e.url.lastIndexOf("/") + 1, e.url.length);
      return TaskInfo(name: name,link: e.url);
    }));

    for (var i = count; i < _tasks!.length; i++) {
      if(_tasks![i].status == DownloadTaskStatus.complete){
        _items.add(ItemHolder(name: _tasks![i].name, task: _tasks![i]));
      }
      count++;
    }

    for (final task in tasks) {
      for (final info in _tasks!) {
        if (info.link == task.url) {
          info
            ..taskId = task.taskId
            ..status = task.status
            ..progress = task.progress;
        }
      }
    }

    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }

    setState(() {
      _loading = false;
    });

  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    final hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) {
          if (_loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _permissionReady
              ? _buildRRecordList()
              : _buildNoPermissionWarning();
        },
      ),
    );
  }

}
