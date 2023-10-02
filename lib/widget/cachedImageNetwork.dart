import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget cImage(String imageUrl, {double? height, double? width, BoxFit? fit}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    height: height,
    width: width,
    placeholder: (context, url) => const CupertinoActivityIndicator(),
    errorWidget: (context, url, error) => const Icon(Icons.error),
    fit: fit,
  );
}
