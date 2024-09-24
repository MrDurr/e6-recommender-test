import 'package:servene_test/content_data.dart';

String getRandomImage() {
  var items = [
    'https://static1.e621.net/data/8b/12/8b1258b81ac00dabf9abb9c6d40a177b.jpg',
    'https://static1.e621.net/data/9b/79/9b793c2c8f198e1acea93a5724a9a69b.jpg',
    'https://static1.e621.net/data/cf/74/cf749ea1c8169025739be06f629df443.jpg',
    'https://static1.e621.net/data/27/44/2744c4c959577455f8fd35781cbc826a.jpg',
  ];
  return (items..shuffle()).first;
}

class ContentRetriever {
  static ContentData getContentData() {
    return ContentData(url: getRandomImage());
  }
}
