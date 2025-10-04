import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconSvgWidget extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double? size;
  final Color? iconColor;
  const IconSvgWidget(
      {super.key,
      required this.icon,
      this.onTap,
      this.padding,
      this.size,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: SvgPicture.asset(
          icon,
          colorFilter: iconColor != null
              ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
              : null,
          width: size ?? 24.h,
          height: size ?? 24.h,
        ),
      ),
    );
  }
}
