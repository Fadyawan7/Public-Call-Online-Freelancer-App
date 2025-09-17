import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/images.dart';

class CustomImageWidget extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final double? containerHeight;
  final double? containerWidth;
  final BoxFit fit;
  final bool isNotification;
  final String placeholder;

  const CustomImageWidget({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.containerHeight,
    this.containerWidth,
    this.fit = BoxFit.cover,
    this.isNotification = false,
    this.placeholder = '',
  });

  @override
  Widget build(BuildContext context) {
    final String finalPlaceholder =
        placeholder.isNotEmpty ? placeholder : Images.placeholderImage;

    // If image is null or empty, directly show asset placeholder
    if (image == null || image!.isEmpty) {
      return SizedBox(
        width: containerWidth,
        height: containerHeight,
        child: Image.asset(
          finalPlaceholder,
          height: height,
          width: width,
          fit: fit,
        ),
      );
    }

    // If image is an asset path (doesn't start with http), load from assets
    if (!image!.startsWith('http')) {
      return SizedBox(
        width: containerWidth,
        height: containerHeight,
        child: Image.asset(
          image!,
          height: height,
          width: width,
          fit: fit,
        ),
      );
    }

    // Otherwise, load as network image
    return SizedBox(
      width: containerWidth,
      height: containerHeight,
      child: CachedNetworkImage(
        imageUrl: image!,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => Image.asset(
          finalPlaceholder,
          height: height,
          width: width,
          fit: fit,
        ),
        errorWidget: (context, url, error) => Image.asset(
          finalPlaceholder,
          height: height,
          width: width,
          fit: fit,
        ),
      ),
    );
  }
}
