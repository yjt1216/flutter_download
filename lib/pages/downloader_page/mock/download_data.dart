class DownloadItems {
  // static const documents = [
  //   DownloadItem(
  //     name: 'Android Programming Cookbook',
  //     url:
  //     'http://enos.itcollege.ee/~jpoial/allalaadimised/reading/Android-Programming-Cookbook.pdf',
  //   ),
  //   DownloadItem(
  //     name: 'iOS Programming Guide',
  //     url:
  //     'http://englishonlineclub.com/pdf/iOS%20Programming%20-%20The%20Big%20Nerd%20Ranch%20Guide%20(6th%20Edition)%20[EnglishOnlineClub.com].pdf',
  //   ),
  // ];

  static const images = [
    DownloadItem(
      name: 'Arches National Park',
      url:
      "https://upload-images.jianshu.io/upload_images/9955565-51a4b4f35bd7973f.png",
    ),
    DownloadItem(
      name: 'Canyonlands National Park',
      url:
      "https://upload-images.jianshu.io/upload_images/9955565-e99b6bd33b388feb.png",
    ),
    DownloadItem(
      name: 'Death Valley National Park',
      url:
      "https://upload-images.jianshu.io/upload_images/9955565-3aafbc20dd329e58.png"
    ),
    DownloadItem(
      name: 'Gates of the Arctic National Park and Preserve',
      url:
      'https://www.orimi.com/pdf-test.pdf',
    ),
    DownloadItem(
      name: 'Mine Disk Image',
      url: "http://121.4.189.24:8089/cloudpan/api/20/20220601111pl8y6c0d17fwg0ob6tiuw3zwpas3jwbe.jpg",
    ),
  ];

  static const videos = [
    DownloadItem(
      name: 'Big Buck Bunny',
      url:
      "http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4",
    ),
    DownloadItem(
      name: 'Elephant Dream1',
      url:
      "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4",
    ),
    DownloadItem(
      name: 'Elephant Dream2',
      url:
      "http://vfx.mtime.cn/Video/2019/03/21/mp4/190321153853126488.mp4",
    ),
    DownloadItem(
      name: 'Elephant Dream3',
      url:
      "http://vfx.mtime.cn/Video/2019/03/19/mp4/190319212559089721.mp4",
    ),
    DownloadItem(
      name: 'Elephant Dream4',
      url:
      "http://vfx.mtime.cn/Video/2019/03/18/mp4/190318231014076505.mp4",
    ),
    DownloadItem(
      name: 'Big Buck Bunny5',
      url:
      "http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4",
    ),
    DownloadItem(
      name: 'Elephant Dream6',
      url:
      "http://vfx.mtime.cn/Video/2019/03/12/mp4/190312083533415853.mp4",
    ),
    DownloadItem(
      name: 'Elephant Dream7',
      url:
      "http://vfx.mtime.cn/Video/2019/03/12/mp4/190312143927981075.mp4",
    ),
    DownloadItem(
      name: 'Elephant Dream8',
      url:
      "http://vfx.mtime.cn/Video/2019/03/13/mp4/190313094901111138.mp4",
    ),
    DownloadItem(
      name: 'Elephant Dream9',
      url:
      "http://vfx.mtime.cn/Video/2019/03/14/mp4/190314102306987969.mp4",
    ),

  ];
}

class DownloadItem {
  const DownloadItem({required this.name, required this.url});

  final String name;
  final String url;
}
