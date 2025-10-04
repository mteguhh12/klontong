import 'dart:ui';

class Const {
  static const String IS_LOGIN = "IS_LOGIN";
  static const String HEADER_KEY_DEVICE_TOKEN = "DEVICE_TOKEN";
  static const String ENDPOINT_STAGING =
      "https://68e09dd093207c4b4794e4af.mockapi.io/api/";
  static const String ENDPOINT_PRODUCTION =
      "https://68e09dd093207c4b4794e4af.mockapi.io/api/";

  // date & time
  static const String DATE_FORMAT_REQUEST = "dd-MM-yyyy";
  static const String DATE_FORMAT = "dd MMMM yyyy";
  static const String DATE_FORMAT_EN = "MMM dd, yyyy";
  static const String DATE_FORMAT_EN2 = "MMM dd, yyyy - HH:mm";
  static const String DATE_TIME_FORMAT = "dd MMMM yyyy , HH:mm";
  static const String DATE_FORMAT_EXPIRATION = "dd/MM/yyyy";
  static const String DATE_FORMAT_POINT = "dd/MM/yyyy  -  HH:mm";
  static const String DATE_FORMAT_DB = "yyyy-MM-dd";
  static const String DATE_FORMAT_DART = "yyyy,MM,dd";
  static const String DATE_MONTHYEAR_FORMAT = "yyyy-MM";
  static const String DATETIME_FORMAT = "yyyy-MM-dd HH:mm";
  static const String DATETIME_FORMAT_FULL = "yyyy-MM-dd HH:mm:ss";
  static const String DATE_MONTH_YEAR = "MMM yyyy";
  static const String DATE_YEAR = "yyyy";
  static const String DATE_FULL_DAY = "EEEE, dd MMM yyyy";
  static const String DATE_NEWS = "dd MMMM yyyy | HH.mm";

  // locales
  static const String LANGUAGE = "LANGUAGE";
  static const String LOCALE_EN = "en"; // accept: en, en-US
  static const String LOCALE_EN2 = "en_US"; // accept: en, en-US
  static const String LOCALE_EN_SHORT = "en_short";
  static const String LOCALE_IN = "id"; // accept: in, in-ID
  static const String LOCALE_IN2 = "id_ID"; // accept: in, in-ID
  static const List<String> LIST_LOCALE = [LOCALE_EN, LOCALE_IN];

  static const String ACTION_REFRESH = "Refresh";
  static const String ACTION_DELETE = "Delete";

  static const String ERROR = "Opps, sorry there was an error";
  static const String NODATA = "No data found";

  static const String IS_REQUIRED = "Field is required.";
  static const String IS_VALID_EMAIL =
      "Field must contain a valid email address.";
  static const String IS_MATCH = "Confirm password not matching";
}

class AppColors {
  static const primary = Color(0xFF027239);
  static const secondary = Color(0xFF023C1E);
  static const background = Color(0xFFFFF8EC);
  static const gold = Color(0xFFB39651);
  static const border = Color(0xFFFAEACE);
  static const success = Color.fromRGBO(41, 199, 112, 1);
  static const warning = Color.fromRGBO(255, 158, 67, 1);
  static const danger = Color.fromRGBO(234, 83, 86, 1);
  static const shadowColor = Color(0xFF323F3D3D);
}

class AppImages {
  static String logo = 'assets/images/logo.svg';
  static String product = 'assets/images/product.png';
}

class AppIcons {
  static String ic_gallery = 'assets/icons/ic-gallery.png';
  static String ic_camera = 'assets/icons/ic-camera.svg';
  static String ic_close_square = 'assets/icons/ic-close-square.svg';
  static String ic_gallery_svg = 'assets/icons/ic-gallery.svg';
}
