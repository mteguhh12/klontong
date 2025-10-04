import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:klontong/main.config.dart';
import 'package:klontong/src/app.dart';
import 'package:klontong/src/data/preferences/app_preferences.dart';
import 'package:klontong/src/utils/const.dart';
import 'package:klontong/src/utils/logger.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.i('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.i(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    logger.i("Error",
        time: DateTime.now(), error: error, stackTrace: stacktrace);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true, // default
  asExtension: false,
)
void configureDependencies() {
  $initGetIt(getIt);
}

void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(Const.LOCALE_EN, null); // 'id' = Indonesia
  configureDependencies();

  HttpOverrides.global = MyHttpOverrides();
  runApp(App(appPreferences: AppPreferences()));
}
