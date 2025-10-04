import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'authentication.dart';

@LazySingleton()
class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationUninitialized());

  void refreshSplash() {
    emit(AuthenticationLoading());
    print("refreshSplash");
    emit(AuthenticationUninitialized());
  }

  void openApp() async {
    emit(AuthenticationLoading());
    emit(AuthenticationAuthenticated());
  }

  void welcomeToHome() {
    emit(AuthenticationUninitialized());
    print("welcomeToHome");
    emit(AuthenticationAuthenticated());
  }

  void welcomeToLogin() {
    emit(AuthenticationWelcome());
    print("welcomeToLogin");
    emit(AuthenticationUnauthenticated());
  }

  void login() {
    emit(AuthenticationLoading());
    print("login");
    emit(AuthenticationAuthenticated());
  }

  void logout() {
    emit(AuthenticationLoading());
    print("logout");
    emit(AuthenticationUnauthenticated());
  }

  void skipBoarding() {
    emit(AuthenticationLoading());
    emit(AuthenticationUnauthenticated());
  }
}
