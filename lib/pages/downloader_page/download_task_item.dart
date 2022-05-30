
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'download_home_page.dart';

///下载item
///
class DownloadTaskItem extends StatelessWidget {

  final ItemHolder? data;
  final Function(TaskInfo?)? onTap;
  final Function(TaskInfo)? onActionTap;

  const DownloadTaskItem({Key? key, this.data, this.onTap, this.onActionTap}) : super(key: key);

  ///下载相关控件
  Widget? _buildTrailing(TaskInfo task) {
    return task.status == DownloadTaskStatus.undefined ? IconButton(
      onPressed: () => onActionTap!(task),
      constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
      icon: const Icon(Icons.file_download),
    ) : Container();
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

            ],
          ),
        ),
      ),
    );
  }


}
