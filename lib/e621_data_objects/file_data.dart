class FileData {
  final int width;
  final int height;
  final String ext;
  final int size;
  final String md5;
  final String url;

  FileData({
    required this.width,
    required this.height,
    required this.ext,
    required this.size,
    required this.md5,
    required this.url,
  });

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      width: json['width'],
      height: json['height'],
      ext: json['ext'],
      size: json['size'],
      md5: json['md5'],
      url: json['url'],
    );
  }
}
