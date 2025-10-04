import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klontong/src/utils/const.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: SvgPicture.asset(
              AppImages.logo,
              width: 150.h,
              height: 150.h,
            ),
          ),
        ),
      ),
    );
  }
}
