import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
<<<<<<< HEAD
import 'package:taskflow/src/utils/app_export.dart';
=======
import 'package:flutter/material.dart';
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }

class CustomImageView extends StatelessWidget {
  const CustomImageView(
      {super.key,
      this.imagePath,
      this.height,
      this.width,
      this.color,
      this.fit,
      this.alignment,
      this.onTap,
      this.radius,
      this.margin,
      this.border,
<<<<<<< HEAD
      this.httpHeaders = const {},
      this.placeHolder = 'assets/images/account.png'});
=======
      this.placeHolder = 'assets/images/image_not_found.png'});
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

  final String? imagePath;

  final double? height;

  final double? width;

  final Color? color;

  final BoxFit? fit;

  final String placeHolder;

  final Alignment? alignment;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry? margin;

  final BorderRadius? radius;

  final BoxBorder? border;

<<<<<<< HEAD
  final Map<String, String> httpHeaders;

=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

<<<<<<< HEAD
  dynamic _buildCircleImage() {
=======
  _buildCircleImage() {
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

<<<<<<< HEAD
  Widget _buildImageWithBorder() {
=======
  _buildImageWithBorder() {
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath != null) {
      switch (imagePath!.imageType) {
        case ImageType.file:
          return Image.file(
            File(imagePath!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
        case ImageType.network:
          return CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: imagePath!,
<<<<<<< HEAD
            httpHeaders: httpHeaders,
            color: color,
            placeholder: (context, url) => SizedBox(
              height: 30.h,
              width: 30.w,
=======
            color: color,
            placeholder: (context, url) => SizedBox(
              height: 30,
              width: 30,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
              child: LinearProgressIndicator(
                color: Colors.grey.shade200,
                backgroundColor: Colors.grey.shade100,
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              placeHolder,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
            ),
          );
        case ImageType.png:
        default:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
      }
    }
    return const SizedBox();
  }
}
