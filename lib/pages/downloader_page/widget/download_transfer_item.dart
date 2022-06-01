
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../model/download_task_model.dart';

///传输列表--item
///
class DownloadTransferItem extends StatelessWidget {

  final ItemHolder? data;
  final Function(TaskInfo?)? onTap;
  final Function(TaskInfo)? onActionTap;

  const DownloadTransferItem({Key? key, this.data, this.onTap, this.onActionTap}) : super(key: key);

  ///下载相关控件
  Widget? _buildTrailing(TaskInfo task) {
    if (task.status == DownloadTaskStatus.complete) {
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
    }  else {
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
      child:  Container(
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
      ) ,
    );
  }


}
