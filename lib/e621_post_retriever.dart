import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:servene_test/e621_data_objects/post_data.dart';

class E621PostRetriever {
  static final Queue<PostData> postQueue = ListQueue(5);
  static const String url =
      'https://e621.net/posts.json?tags=score:>1000+type:png&limit=5';
  static const String randomUrl =
      'https://e621.net/posts.json?tags=order:random+score:>1000+type:png&limit=5';

  static Future<bool> loadPosts() async {
    if (postQueue.isEmpty) {
      final response = await http.get(Uri.parse(randomUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('posts') && data['posts'].isNotEmpty) {
          for (final postJson in data['posts']) {
            postQueue.add(PostData.fromJson(postJson));
          }

          return true;
        }
      }

      print(response);

      return false;
    }

    return true;
  }

  static Future<PostData?> fetchPost() async {
    if (await loadPosts()) return postQueue.removeFirst();
    return null;
  }
}
