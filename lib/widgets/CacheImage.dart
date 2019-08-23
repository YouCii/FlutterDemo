import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CacheImage extends Image {

  CacheImage({@required String imageUrl, width, height, fit}) :super(
    image: CachedNetworkImageProvider(imageUrl, errorListener: () {
      print("");
    }),
    width: width,
    height: height,
    fit: fit,
  );

}