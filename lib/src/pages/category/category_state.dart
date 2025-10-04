import 'package:equatable/equatable.dart';
import 'package:klontong/src/data/response/category_response.dart';

abstract class CategoryState extends Equatable {
  CategoryState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {
  @override
  String toString() => 'CategoryLoading';
}

class CategorySuccess extends CategoryState {
  @override
  String toString() => 'CategorySuccess';
}

class CategoryFailure extends CategoryState {
  final String? error;

  CategoryFailure(this.error);

  @override
  String toString() {
    return 'CategoryFailure {error: $error}';
  }
}

class CategoryRefreshData extends CategoryState {
  @override
  String toString() => 'CategoryRefreshData';
}

class ListCategory extends CategoryState {
  final List<CategoryResponse>? itemList;
  final dynamic error;
  final int? nextPageKey;

  ListCategory({
    this.itemList,
    this.error,
    this.nextPageKey = 0,
  });

  @override
  String toString() {
    return 'ListCategory {itemList: $itemList, error: $error, nextPageKey: $nextPageKey}';
  }
}

class DeleteCategorySuccess extends CategoryState {
  @override
  String toString() => 'DeleteProductSuccess';
}
