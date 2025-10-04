import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klontong/src/utils/const.dart';

class ButtonWidget extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const ButtonWidget(
      {super.key,
      required this.title,
      this.onTap,
      this.backgroundColor,
      this.width,
      this.height});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width ?? 320.w,
        height: widget.height ?? 60.h,
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 24.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.onTap != null
              ? (widget.backgroundColor ?? AppColors.primary)
              : Color.fromRGBO(163, 163, 163, 1),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
