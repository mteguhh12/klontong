import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUninitialized';
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => 'AuthenticationLoading';
}

class AuthenticationWelcome extends AuthenticationState {
  @override
  String toString() {
    return 'AuthenticationWelcome';
  }
}

class AuthenticationAuthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationAuthenticated {}';
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() {
    return 'AuthenticationUnauthenticated';
  }
}

class AuthenticationBoarding extends AuthenticationState {
  @override
  String toString() {
    return 'AuthenticationBoarding';
  }
}
