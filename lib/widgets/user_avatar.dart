import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/assets_path.dart';
import 'package:bee_kind/widgets/custom_extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({
    super.key,
    this.selectedImgPath,
    this.setImage,
    this.isViewOnly,
    this.radius,
    this.borderColor,
    this.placeHolder,
    this.onTap,
  });
  final String? selectedImgPath;
  final String? placeHolder;
  final Function(String?)? setImage;
  final bool? isViewOnly;
  final double? radius;
  final Color? borderColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return isViewOnly == true
        ? Container(
            height: radius ?? 0.15.sh,
            width: radius ?? 0.15.sh,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border.all(
                color: borderColor ?? AppColors.yellow2,
                width: 1.5,
              ),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: CustomExtendedImageWidget(
                onTap: onTap,
                imagePath: selectedImgPath,
                imageType:
                    selectedImgPath != null &&
                        selectedImgPath!.startsWith('https://')
                    ? MediaPathType.NETWORK.name
                    : MediaPathType.FILE.name,
                fit: BoxFit.cover,
                imagePlaceholder: placeHolder ?? AssetsPath.placeholder,
              ),
            ),
          )
        : GestureDetector(
            onTap: isViewOnly == true ? null : onTap,
            child: Stack(
              children: [
                Container(
                  height: radius ?? 0.15.sh,
                  width: radius ?? 0.15.sh,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    border: Border.all(
                      color:
                          borderColor ??
                          AppColors.yellow2.withValues(alpha: 0.4),
                      width: 5,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: CustomExtendedImageWidget(
                      onTap: onTap,
                      imagePath: selectedImgPath,
                      imageType: selectedImgPath!.startsWith('uploads')
                          ? MediaPathType.NETWORK.name
                          : MediaPathType.FILE.name,
                      fit: BoxFit.cover,
                      imagePlaceholder: placeHolder ?? AssetsPath.placeholder,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.transparentColor,
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
