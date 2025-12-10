// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:bee_kind/utils/app_colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomExtendedImageWidget extends StatelessWidget {
  final String? imagePath, imageType;
  final String imagePlaceholder;
  final BoxFit? fit;
  final double width;
  final Color? placeholderColor, imageColor;
  final VoidCallback? onTap;

  const CustomExtendedImageWidget({
    super.key,
    this.imagePath,
    this.imageType,
    required this.imagePlaceholder,
    this.imageColor,
    this.placeholderColor,
    this.fit,
    this.onTap,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return imagePath != null && imageType == MediaPathType.FILE.name
        ? GestureDetector(
            onTap: onTap,
            child: SizedBox(
              width: width,
              child: ExtendedImage.file(
                File(imagePath!),
                fit: fit ?? BoxFit.cover,
                color: imageColor,
                loadStateChanged: (state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return Image.asset(
                        imagePlaceholder,
                        // fit: BoxFit.contain,
                        fit: fit ?? BoxFit.cover,
                        color: placeholderColor,
                      );

                    case LoadState.failed:
                      return Image.asset(
                        imagePlaceholder,
                        // fit: BoxFit.contain,
                        fit: fit ?? BoxFit.cover,
                        color: placeholderColor,
                      );

                    case LoadState.completed:
                      break;
                  }
                  return null;
                },
                //cancelToken: cancellationToken,
              ),
            ),
          )
        : imagePath != null && imageType == MediaPathType.NETWORK.name
        ? GestureDetector(
            onTap: onTap,
            child: SizedBox(
              width: width,
              child: ExtendedImage.network(
                imagePath!,
                fit: fit ?? BoxFit.cover,
                color: imageColor,
                loadStateChanged: (state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      // return Image.asset(
                      //   imagePlaceholder,
                      //   // fit: BoxFit.contain,
                      //   fit: fit ?? BoxFit.cover,
                      //   color: placeholderColor,
                      // );
                      return Shimmer.fromColors(
                        baseColor: AppColors.shimmerBaseColor,
                        highlightColor: AppColors.shimmerHighlightColor,
                        child: Container(color: Colors.grey),
                      );

                    case LoadState.failed:
                      return Image.asset(
                        imagePlaceholder,
                        fit: fit ?? BoxFit.cover,
                        // fit: BoxFit.contain,
                        color: placeholderColor,
                      );
                    case LoadState.completed:
                      break;
                  }
                  return null;
                },
                //cancelToken: cancellationToken,
              ),
            ),
          )
        : imagePath != null && imageType == MediaPathType.ASSETS.name
        ? GestureDetector(
            onTap: onTap,
            child: SizedBox(
              width: width,
              child: ExtendedImage.asset(
                imagePath!,
                color: imageColor,
                fit: fit ?? BoxFit.cover,
                loadStateChanged: (state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return Image.asset(
                        imagePlaceholder,
                        fit: fit ?? BoxFit.cover,
                        color: placeholderColor,
                      );

                    case LoadState.failed:
                      return Image.asset(
                        imagePlaceholder,
                        fit: fit ?? BoxFit.cover,
                        color: placeholderColor,
                      );

                    case LoadState.completed:
                      return SizedBox();
                  }
                },
                //cancelToken: cancellationToken,
              ),
            ),
          )
        : Image.asset(
            imagePlaceholder,
            fit: fit ?? BoxFit.cover,
            color: placeholderColor,
          );
  }
}

enum MediaPathType { FILE, NETWORK, ASSETS }
