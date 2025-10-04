import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:klontong/src/utils/const.dart';
import 'package:klontong/src/utils/enum.dart';
import 'package:path/path.dart';
import 'logger.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart' as flutterToast;

T? castOrNull<T>(dynamic x) => x is T ? x : null;

T castOrFallback<T>(dynamic x, T fallback) => x is T ? x : fallback;

class Utils {
  static Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      logger.d('Internet not connect');
    }
    return false;
  }

  static bool isTablet() {
    final data = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
    return data.size.shortestSide >= 600;
  }

  static void showSnackBar(BuildContext context, String? text) {
    if (Utils.isEmpty(text)) return;
    final snackBar = SnackBar(
      content: Text(
        text ?? "",
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static void showErrorSnackBar(BuildContext context, String? text) {
    onWidgetDidBuild(() => showSnackBar(context, text));
  }

  static bool isEmpty(Object? text) {
    if (text is String) return text.isEmpty;
    if (text is List) return text.isEmpty;
    return text == null;
  }

  static bool isEmptyArray(List? list) {
    return list == null || list.isEmpty;
  }

  static bool isInteger(num value) =>
      value is int || value == value.roundToDouble();

  static Color parseStringToColor(String? color, {Color? defaultColor}) {
    if (Utils.isEmpty(color))
      return defaultColor ?? Colors.black;
    else
      return Color(int.parse('0xff' + color!.trim().substring(1)));
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static void hideKeyboard(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  static Future<dynamic> fetchImageData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.bodyBytes;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  static String getFileName(String path) {
    return basenameWithoutExtension(path);
  }

  static DateFormat dateGetMonthYear = DateFormat('MMMM, y', 'id');
  static DateFormat dateGetMonthYear2 = DateFormat('MMM, y', 'id');
  static DateFormat dateGetMonth = DateFormat('MMMM', 'id');
  static DateFormat dateGetMonth3 = DateFormat('MMM', 'id');
  static DateFormat dateGetFullDate = DateFormat('MMM dd, y', 'id');
  static DateFormat dateGetDay = DateFormat('EEE', 'id');
  static DateFormat dateGetDayNumber = DateFormat('dd', 'id');
  static DateFormat dateGetTime = DateFormat('HH:mm:ss', 'id');
  static DateFormat dateGetTime2 = DateFormat('HH:mm', 'id');

  static List<String> allowedExtensions = [
    "doc",
    "pdf",
    "docx",
    "xlsx",
    "xls",
    "xltx",
    "pptx",
    "ppt",
    "jpg",
    "png",
    "jpeg"
  ];

  static String getExtensionsFromUrl(String url) {
    for (var i = 0; i < allowedExtensions.length; i++) {
      if (url.contains(".${allowedExtensions[i]}"))
        return "${allowedExtensions[i]}";
    }

    return "";
  }

  static int parseMoneytoInt(String value) {
    return int.parse(value.replaceAll(RegExp('[^0-9]'), ''));
  }

  static String? formatMoney(dynamic amount) {
    if (amount == null) return null;
    if (amount is String) {
      amount = double.parse(amount);
    }
    return NumberFormat("#,##0").format(amount);
  }

  static String toCapitalize(String word) {
    return word.split(' ').map((word) => word.capitalize()).join(' ');
  }

  static void showToast(BuildContext context, String? text,
      {ToastType? type = ToastType.SUCCESS, bool? isPrefixIcon = false}) {
    Color mainColor = AppColors.success;
    Color textColor = Colors.white;
    IconData iconData = CupertinoIcons.info;
    if (type == ToastType.WARNING) {
      mainColor = AppColors.warning;
    } else if (type == ToastType.ERROR) {
      mainColor = AppColors.danger;
    }
    onWidgetDidBuild(() {
      FToast fToast = FToast();
      fToast.init(context);
      Widget toast = Container(
        width: ScreenUtil().screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 6.h),
        decoration: BoxDecoration(
            borderRadius: isPrefixIcon == true
                ? BorderRadius.zero
                : BorderRadius.circular(16),
            border: Border.all(color: mainColor, width: 1),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: 0)
            ],
            color: mainColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isPrefixIcon == true
                ? Container(
                    margin: EdgeInsets.only(right: 10.w),
                    child: Icon(iconData, size: 12.h, color: textColor))
                : Container(),
            Expanded(
              child: Text(text ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: textColor)),
            ),
            SizedBox(
              width: 8.w,
            ),
            GestureDetector(
              onTap: () => fToast.removeCustomToast(),
              child: Icon(
                CupertinoIcons.xmark,
                size: 16.h,
                color: textColor,
              ),
            )
          ],
        ),
      );

      fToast.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        positionedToastBuilder: (context, child, _) {
          return Positioned(
            child: child,
            top: MediaQuery.of(context).padding.top + 5.h,
            left: 0,
            right: 0,
          );
        },
        toastDuration: const Duration(seconds: 3),
      );
    });
  }

  static void showToastDefault(String text,
      {bool isLong = false, ToastType? type = ToastType.SUCCESS}) {
    Color mainColor = AppColors.success;
    if (type == ToastType.WARNING) {
      mainColor = AppColors.warning;
    } else if (type == ToastType.ERROR) {
      mainColor = AppColors.danger;
    }

    if (!isEmpty(text))
      // toast(text, duration: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT);

      flutterToast.Fluttertoast.showToast(
          msg: text,
          gravity: ToastGravity.TOP_RIGHT,
          backgroundColor: mainColor,
          toastLength: isLong
              ? flutterToast.Toast.LENGTH_LONG
              : flutterToast.Toast.LENGTH_SHORT);
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isNotEmpty) {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
    return "";
  }
}
