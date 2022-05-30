
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../downloader_page/download_task_page.dart';

///tab_bar 子界面
///
class DownloadFilePage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;

  const DownloadFilePage({Key? key, required this.menuScreenContext, required this.onScreenHideButtonPressed, this.hideStatus = false}) : super(key: key);

  @override
  _DownloadFileState createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFilePage> {

  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Scaffold(
          backgroundColor: Colors.indigo,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0),
                child: TextField(
                  decoration: InputDecoration(hintText: "Test Text Field"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      useRootNavigator: true,
                      builder: (context) => Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Exit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Push bottom sheet on TOP of Nav Bar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      useRootNavigator: false,
                      builder: (context) => Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Exit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Push bottom sheet BEHIND the Nav Bar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('添加下载任务');
                    Get.to(() => const DownloadTaskPage());
                  },
                  child: const Text(
                    "添加下载任务",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onScreenHideButtonPressed();
                  },
                  child: Text(
                    widget.hideStatus
                        ? "展示 Navigation Bar"
                        : "隐藏 Navigation Bar",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(widget.menuScreenContext).pop();
                  },
                  child: const Text(
                    "<- Main Menu",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 60.0,),
            ],
          ),
        ),
      ),
    );
  }


}
