class DownloadItems {
  static const documents = [
    DownloadItem(
      name: 'Android Programming Cookbook',
      url:
      'http://enos.itcollege.ee/~jpoial/allalaadimised/reading/Android-Programming-Cookbook.pdf',
    ),
    DownloadItem(
      name: 'iOS Programming Guide',
      url:
      'http://englishonlineclub.com/pdf/iOS%20Programming%20-%20The%20Big%20Nerd%20Ranch%20Guide%20(6th%20Edition)%20[EnglishOnlineClub.com].pdf',
    ),
  ];

  static const images = [
    DownloadItem(
      name: 'Arches National Park',
      url:
      'https://upload.wikimedia.org/wikipedia/commons/6/60/The_Organ_at_Arches_National_Park_Utah_Corrected.jpg',
    ),
    DownloadItem(
      name: 'Canyonlands National Park',
      url:
      'https://upload.wikimedia.org/wikipedia/commons/7/78/Canyonlands_National_Park%E2%80%A6Needles_area_%286294480744%29.jpg',
    ),
    DownloadItem(
      name: 'Death Valley National Park',
      url:
      'https://upload.wikimedia.org/wikipedia/commons/b/b2/Sand_Dunes_in_Death_Valley_National_Park.jpg',
    ),
    DownloadItem(
      name: 'Gates of the Arctic National Park and Preserve',
      url:
      'https://upload.wikimedia.org/wikipedia/commons/e/e4/GatesofArctic.jpg',
    ),
  ];

  static const videos = [
    DownloadItem(
      name: 'Big Buck Bunny',
      url:
      'http://vfx.mtime.cn/Video/2019/03/18/mp4/190318231014076505.mp4',
    ),
    DownloadItem(
      name: 'Elephant Dream',
      url:
      'http://vfx.mtime.cn/Video/2019/03/19/mp4/190319212559089721.mp4',
    ),
    DownloadItem(
      name: 'Elephant Dream',
      url:
      'http://vfx.mtime.cn/Video/2019/03/21/mp4/190321153853126488.mp4',
    ),
    DownloadItem(
      name: 'Elephant Dream',
      url:
      'http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4',
    ),
    DownloadItem(
      name: 'Elephant Dream',
      url:
      'http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4',
    ),
  ];
}

class DownloadItem {
  const DownloadItem({required this.name, required this.url});

  final String name;
  final String url;
}
