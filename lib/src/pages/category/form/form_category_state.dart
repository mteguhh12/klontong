import 'package:equatable/equatable.dart';

abstract class FormCategoryState extends Equatable {
  FormCategoryState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class FormCategoryInitial extends FormCategoryState {}

class FormCategoryLoading extends FormCategoryState {
  @override
  String toString() => 'FormCategoryLoading';
}

class FormCategorySuccess extends FormCategoryState {
  @override
  String toString() => 'FormCategorySuccess';
}

class FormCategoryFailure extends FormCategoryState {
  final String? error;

  FormCategoryFailure(this.error);

  @override
  String toString() {
    return 'FormCategoryFailure {error: $error}';
  }
}
