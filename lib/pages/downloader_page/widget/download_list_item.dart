
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../download_task_model.dart';

///传输列表--item
///
class DownloadListItem extends StatelessWidget {

  final ItemHolder? data;
  final Function(TaskInfo?)? onTap;
  final Function(TaskInfo)? onActionTap;

  const DownloadListItem({Key? key, this.data, this.onTap, this.onActionTap}) : super(key: key);

  ///下载相关控件
  Widget? _buildTrailing(TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return IconButton(
        onPressed: () => onActionTap!(task),
        constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
        icon: const Icon(Icons.file_download),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return Row(
        children: [
          Text('${task.progress}%'),
          IconButton(
            onPressed: () => onActionTap!(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.pause, color: Colors.red),
          ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return Row(
        children: [
          Text('${task.progress}%'),
          IconButton(
            onPressed: () => onActionTap!(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.play_arrow, color: Colors.green),
          ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('完成', style: TextStyle(color: Colors.green)),
          IconButton(
            onPressed: () => onActionTap!(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.delete),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return const Text('取消', style: TextStyle(color: Colors.red));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('失败', style: TextStyle(color: Colors.red)),
          IconButton(
            onPressed: () => onActionTap!(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.refresh, color: Colors.green),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.enqueued) {//任务入队
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('等待', style: TextStyle(color: Colors.orangeAccent)),
          IconButton(
            onPressed: () => onActionTap!(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.delete),
          )
        ],
      );

      //return const Text('等待', style: TextStyle(color: Colors.orange));
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data!.task!.status == DownloadTaskStatus.complete
          ? () {
        onTap!(data!.task);
      }
          : null,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: InkWell(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 64,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        data!.name!,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _buildTrailing(data!.task!),
                    ),
                  ],
                ),
              ),
              if (data!.task!.status == DownloadTaskStatus.running ||
                  data!.task!.status == DownloadTaskStatus.paused)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: LinearProgressIndicator(
                    value: data!.task!.progress! / 100,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }


}
