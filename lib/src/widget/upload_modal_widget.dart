import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klontong/src/utils/const.dart';
import 'package:klontong/src/utils/navigation_utils.dart';
import 'package:klontong/src/widget/icon_svg_widget.dart';

class UploadModalWidget extends StatelessWidget {
  final VoidCallback? onTapCamera;
  final VoidCallback? onTapStorage;
  final VoidCallback? onTapGallery;
  const UploadModalWidget(
      {super.key, this.onTapCamera, this.onTapStorage, this.onTapGallery});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upload Image",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => NavigationUtils.pop(context),
                    child: IconSvgWidget(
                      icon: AppIcons.ic_close_square,
                      size: 30.h,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 32.h,
              ),
              if (onTapCamera != null) ...[
                GestureDetector(
                  onTap: onTapCamera,
                  child: Container(
                    height: 44.h,
                    width: double.infinity,
                    child: Row(
                      children: [
                        IconSvgWidget(
                          icon: AppIcons.ic_camera,
                          size: 24.h,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Text(
                            "Camera",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20.h,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: AppColors.border,
                  height: 20.h,
                ),
              ],
              if (onTapGallery != null) ...[
                GestureDetector(
                  onTap: onTapGallery,
                  child: Container(
                    height: 44.h,
                    width: double.infinity,
                    child: Row(
                      children: [
                        IconSvgWidget(
                          icon: AppIcons.ic_gallery_svg,
                          size: 24.h,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Text(
                            "Gallery",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20.h,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: AppColors.border,
                  height: 20.h,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
