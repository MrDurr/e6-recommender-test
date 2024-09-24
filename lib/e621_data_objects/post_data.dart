import 'package:servene_test/e621_data_objects/file_data.dart';

class PostData {
  final int id;
  final String createdAt;
  final String updatedAt;
  final FileData file;

  PostData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.file,
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    print(json['id']);
    return PostData(
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      file: FileData.fromJson(json['file']),
    );
  }
}
