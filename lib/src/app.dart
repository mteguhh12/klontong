import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:klontong/src/data/network/repository/app_repository.dart';
import 'package:klontong/src/data/preferences/app_preferences.dart';
import 'package:klontong/src/pages/category/category_cubit.dart';
import 'package:klontong/src/pages/main/main_page.dart';
import 'package:klontong/src/pages/product/product_cubit.dart';
import 'package:klontong/src/pages/splash/splash_page.dart';
import 'package:klontong/src/utils/custom_theme.dart';
import 'package:klontong/src/utils/utils.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/authentication/authentication.dart';

class App extends StatefulWidget {
  final AppPreferences appPreferences;
  const App({super.key, required this.appPreferences});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late AuthenticationCubit _authenticationCubit;

  @override
  void initState() {
    _authenticationCubit = GetIt.I<AuthenticationCubit>();

    Future.delayed(Duration(seconds: 2), () {
      _authenticationCubit.openApp();
    });

    Utils.onWidgetDidBuild(() {
      _authenticationCubit.refreshSplash();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => _authenticationCubit,
        ),
        BlocProvider(
          create: (_) => ProductCubit(appRepository: AppRepository()),
        ),
        BlocProvider(
          create: (_) => CategoryCubit(appRepository: AppRepository()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(440, 956),
        fontSizeResolver: (fontSize, instance) =>
            FontSizeResolvers.radius(fontSize, instance),
        builder: (context, child) => RefreshConfiguration(
          headerBuilder: () => WaterDropMaterialHeader(),
          footerBuilder: () => ClassicFooter(
            loadStyle: LoadStyle.HideAlways,
          ),
          child: OverlaySupport(
            child: MaterialApp(
              title: "GEMS",
              debugShowCheckedModeBanner: false,
              theme: lightMode,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('id', 'ID'),
              ],
              builder: (context, widget) {
                return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: TextScaler.linear(1.0)),
                    child: widget!);
              },
              home: BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  print(state);
                  if (state is AuthenticationUninitialized)
                    return SplashPage();
                  else
                    return MainPage();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
