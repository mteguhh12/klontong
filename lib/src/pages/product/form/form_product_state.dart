import 'package:equatable/equatable.dart';

abstract class FormProductState extends Equatable {
  FormProductState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class FormProductInitial extends FormProductState {}

class FormProductLoading extends FormProductState {
  @override
  String toString() => 'FormProductLoading';
}

class FormProductSuccess extends FormProductState {
  @override
  String toString() => 'FormProductSuccess';
}

class FormProductFailure extends FormProductState {
  final String? error;

  FormProductFailure(this.error);

  @override
  String toString() {
    return 'FormProductFailure {error: $error}';
  }
}

class GetCategorySuccess extends FormProductState {
  @override
  String toString() => 'GetCategorySuccess';
}
