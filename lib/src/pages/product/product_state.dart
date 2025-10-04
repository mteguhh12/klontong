import 'package:equatable/equatable.dart';
import 'package:klontong/src/data/response/product_response.dart';

abstract class ProductState extends Equatable {
  ProductState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {
  @override
  String toString() => 'ProductLoading';
}

class ProductSuccess extends ProductState {
  @override
  String toString() => 'ProductSuccess';
}

class ProductRefreshData extends ProductState {
  @override
  String toString() => 'ProductRefreshData';
}

class ProductFailure extends ProductState {
  final String? error;

  ProductFailure(this.error);

  @override
  String toString() {
    return 'ProductFailure {error: $error}';
  }
}

class ListProduct extends ProductState {
  final List<ProductResponse>? itemList;
  final dynamic error;
  final int? nextPageKey;

  ListProduct({
    this.itemList,
    this.error,
    this.nextPageKey = 0,
  });

  @override
  String toString() {
    return 'ListProduct {itemList: $itemList, error: $error, nextPageKey: $nextPageKey}';
  }
}

class GetProductSuccess extends ProductState {
  final ProductResponse? product;

  GetProductSuccess({
    this.product,
  });

  @override
  String toString() {
    return 'GetProductSuccess {product: $product}';
  }
}

class DeleteProductSuccess extends ProductState {
  @override
  String toString() => 'DeleteProductSuccess';
}
