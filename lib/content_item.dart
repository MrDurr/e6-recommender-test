import 'package:flutter/material.dart';
import 'package:servene_test/content_data.dart';
import 'package:servene_test/content_retriever.dart';

class ContentItem extends StatelessWidget {
  static final Map<int, ContentData> indexCache = {};
  final int index;
  final ContentData contentData;

  ContentItem({super.key, required this.index})
      : contentData = getIndexUrl(index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Image.network(
        contentData.url,
        fit: BoxFit.contain,
      ),
      persistentFooterButtons: [
        IconButton.filled(onPressed: () {}, icon: Icon(Icons.abc))
      ],
    );
  }

  static ContentData getIndexUrl(int idx) =>
      indexCache.putIfAbsent(idx, ContentRetriever.getContentData);
}
