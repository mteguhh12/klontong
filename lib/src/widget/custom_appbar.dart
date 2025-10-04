import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klontong/src/utils/const.dart';

AppBar appBar(BuildContext context, String title,
    {Widget? rightWidget,
    PreferredSizeWidget? bottom,
    Widget? leadingWidget,
    Color? textColor,
    Color? leadingBackground,
    double? leadingWidth}) {
  return AppBar(
    backgroundColor: AppColors.background,
    toolbarHeight: 60.h,
    leadingWidth: leadingWidth ?? 60.w,
    forceMaterialTransparency: true,
    leading: leadingWidget == null
        ? (Navigator.of(context).canPop() == true
            ? InkWell(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  margin: EdgeInsets.only(left: 20.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                    color: leadingBackground,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 19.sp,
                  ),
                ),
              )
            : null)
        : leadingWidget,
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: textColor ?? AppColors.secondary,
      ),
    ),
    actions: rightWidget == null ? null : [rightWidget],
    bottom: bottom,
  );
}
