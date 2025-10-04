import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppPreferenceData {
  Map<String, dynamic> toJson();
}

class AppPreferences {
  AppPreferences._privateConstructor();

  static final AppPreferences _instance = AppPreferences._privateConstructor();

  factory AppPreferences() {
    SharedPreferences.getInstance().then((value) {
      _instance._preference = value;
    });
    return _instance;
  }

  SharedPreferences? _preference;

  String? getString(String key) {
    String? value = _preference?.getString(key);
    if (value?.isEmpty == true) value = null;
    return value;
  }

  List<String> getListString(String key) {
    return _preference?.getStringList(key) ?? [];
  }

  bool? getBool(String key) {
    return _preference?.getBool(key);
  }

  int? getInt(String key) {
    return _preference?.getInt(key);
  }

  double? getDouble(String key) {
    return _preference?.getDouble(key);
  }

  void setData(String key, Object? data) {
    if (data == null) return;
    if (data is int) {
      _preference?.setInt(key, data);
    }
    if (data is String) {
      _preference?.setString(key, data);
    }
    if (data is bool) {
      _preference?.setBool(key, data);
    }
    if (data is List<dynamic>) {
      _preference?.setStringList(key, data.map((e) => e.toString()).toList());
    }
    if (data is double) {
      _preference?.setDouble(key, data);
    }
  }

  void removeData(String key) {
    _preference?.remove(key);
  }

  T? _parse<T>(String key, T factory(dynamic data)) {
    String? raw = _preference?.getString(key);
    if (raw != null) {
      dynamic rawJson = json.decode(raw);
      if (rawJson != null) {
        return factory(rawJson);
      }
    }
    return null;
  }

  T? _save<T extends AppPreferenceData>(String key, T? object) {
    if (object == null) {
      _preference?.remove(key);
    } else {
      String raw = json.encode(object.toJson());
      _preference?.setString(key, raw);
    }
    return object;
  }
}

AppPreferences appPreferences = AppPreferences();
