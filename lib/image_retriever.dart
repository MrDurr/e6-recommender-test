import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageRetriever {
  static Widget getImage1(String url, double height, double width) {
    return Image(
      // image: ResizeImage(
      //   NetworkImage(url),
      //   allowUpscaling: false,
      //   policy: ResizeImagePolicy.fit,
      //   height: height.toInt(),
      //   width: width.toInt(),
      // ),
      image: NetworkImage(url),
      fit: BoxFit.contain,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return (frame == null)
            ? const Center(child: CircularProgressIndicator())
            : child;
      },
    );
  }

  static Widget getImage2(String url, double height, double width) {
    print(height);
    print(width);
    print(height.toInt());
    print(width.toInt());
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      maxHeightDiskCache: height.toInt(),
      maxWidthDiskCache: width.toInt(),
      memCacheHeight: height.toInt(),
      memCacheWidth: width.toInt(),
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      fit: BoxFit.contain,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Center(
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
          ),
        );
      },
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  static Future<Widget> getImage1Future(
      String url, double height, double width) async {
    // await Future.delayed(Duration(seconds: 2));

    final img = Image(
      image: ResizeImage(
        NetworkImage(url),
        allowUpscaling: false,
        policy: ResizeImagePolicy.fit,
        height: height.toInt(),
        width: width.toInt(),
      ),
      fit: BoxFit.contain,
      // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
      //   return (frame == null)
      //       ? const Center(child: CircularProgressIndicator())
      //       : child;
      // },
    );

    return img;
  }

  static Widget futureWrapper(Future<Widget> getImage) {
    return FutureBuilder(
      future: getImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print(3);
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          print(4);
          return snapshot.data ?? SizedBox.shrink();
        }
      },
    );
  }
}
