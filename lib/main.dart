import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:servene_test/e621_post_retriever.dart';
import 'package:servene_test/image_retriever.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Servene Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const VideoListPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(
              Icons.home_rounded,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            activeIcon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}

class VideoListPage extends StatefulWidget {
  const VideoListPage({super.key});

  @override
  VideoListPageState createState() => VideoListPageState();
}

class VideoListPageState extends State<VideoListPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.space:
            case LogicalKeyboardKey.arrowDown:
              _pageController.nextPage(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
              );
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowUp:
              _pageController.previousPage(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
              );
              return KeyEventResult.handled;
          }
        }

        return KeyEventResult.ignored;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is UserScrollNotification &&
              notification.direction == ScrollDirection.forward) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
          return true;
        },
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical, // For vertical scrolling
          itemCount: null, // Number of video items
          itemBuilder: (context, index) {
            return VideoItem(index: index);
          },
        ),
      ),
    );
  }
}

String getRandomImage() {
  var items = [
    'https://static1.e621.net/data/8b/12/8b1258b81ac00dabf9abb9c6d40a177b.jpg',
    'https://static1.e621.net/data/9b/79/9b793c2c8f198e1acea93a5724a9a69b.jpg',
    'https://static1.e621.net/data/cf/74/cf749ea1c8169025739be06f629df443.jpg',
    'https://static1.e621.net/data/27/44/2744c4c959577455f8fd35781cbc826a.jpg',
    'https://static1.e621.net/data/3c/f4/3cf49904dd78ffa7a799418bc840bdf4.png',
  ];
  return (items..shuffle()).first;
}

class VideoItem extends StatelessWidget {
  static final Map<int, String> indexCache = {};
  final int index;

  VideoItem({super.key, required this.index, bool doNext = true});

  // @override
  // Widget build(BuildContext context) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       return CachedNetworkImage(
  //         imageUrl: url,
  //         fit: BoxFit.contain,
  //         fadeInDuration: Duration.zero,
  //         fadeOutDuration: Duration.zero,
  //         height: constraints.maxHeight,
  //         width: constraints.maxWidth,
  //         progressIndicatorBuilder: (context, url, downloadProgress) {
  //           return Center(
  //             child: CircularProgressIndicator(
  //               value: downloadProgress.progress,
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Image(
          image: ResizeImage(
            NetworkImage(getIndexUrl(index)),
            allowUpscaling: false,
            policy: ResizeImagePolicy.fit,
            height: constraints.maxHeight.toInt(),
            width: constraints.maxWidth.toInt(),
          ),
          fit: BoxFit.contain,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return (frame == null)
                ? const Center(child: CircularProgressIndicator())
                : child;
          },
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: getIndexUrl(index),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         print(1);
  //         return const Center(child: LinearProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         print(snapshot.error);
  //         return Text('Error: ${snapshot.error}');
  //       } else if (snapshot.hasData) {
  //         print(2);
  //         return LayoutBuilder(
  //           builder: (context, constraints) {
  //             return ImageRetriever.futureWrapper(
  //                 ImageRetriever.getImage1Future(snapshot.data!,
  //                     constraints.maxHeight, constraints.maxWidth));
  //           },
  //         );
  //       } else {
  //         throw UnimplementedError("Idk how we got here 232");
  //       }
  //     },
  //   );
  // return LayoutBuilder(
  //   builder: (context, constraints) {
  //     return ImageRetriever.futureWrapper(ImageRetriever.getImage1Future(
  //         url, constraints.maxHeight, constraints.maxWidth));
  //   },
  // );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Image.network(
  //     url,
  //     fit: BoxFit.contain,
  //     frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
  //       return (frame == null)
  //           ? const Center(child: CircularProgressIndicator())
  //           : child;
  //     },
  //   );
  // }

  static String getIndexUrl(int idx) {
    return indexCache.putIfAbsent(
      idx,
      getRandomImage,
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Page'),
    );
  }
}
