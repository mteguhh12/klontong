import 'package:collection/collection.dart';
import 'package:klontong/src/utils/const.dart';

class AppConfig {
  static final Environment environment = _load();

  static Environment _load() {
    const env = String.fromEnvironment("KLONTONG_ENV");
    return Environment.values
            .firstWhereOrNull((element) => element.name == env) ??
        Environment.STAGING;
  }
}

enum Environment {
  STAGING,
  PRODUCTION,
}

extension EnvironmentExt on Environment {
  String get suffix {
    switch (this) {
      case Environment.STAGING:
        //return ".stg";
        return "";
      case Environment.PRODUCTION:
        return "";
    }
  }

  String get clientId {
    switch (this) {
      case Environment.STAGING:
        return "mobile-app-client";
      case Environment.PRODUCTION:
        return "mobile-app-client";
    }
  }

  String get apiEndpoint {
    switch (this) {
      case Environment.STAGING:
        return "${Const.ENDPOINT_STAGING}";
      case Environment.PRODUCTION:
        return "${Const.ENDPOINT_PRODUCTION}";
    }
  }

  String get authEndpoint {
    switch (this) {
      case Environment.STAGING:
        return "${Const.ENDPOINT_STAGING}login";
      case Environment.PRODUCTION:
        return "${Const.ENDPOINT_PRODUCTION}login";
    }
  }

  String get logoutEndpoint {
    switch (this) {
      case Environment.STAGING:
        return "${Const.ENDPOINT_STAGING}logout";
      case Environment.PRODUCTION:
        return "${Const.ENDPOINT_PRODUCTION}logout";
    }
  }
}
