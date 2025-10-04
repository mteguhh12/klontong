import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/src/data/network/repository/app_repository.dart';
import 'package:klontong/src/data/network/service/api_result.dart';
import 'package:klontong/src/data/network/service/network_exceptions.dart';
import 'package:klontong/src/data/response/category_response.dart';
import 'package:klontong/src/data/response/product_response.dart';

import 'product.dart';

class ProductCubit extends Cubit<ProductState> {
  final AppRepository appRepository;
  String? search;
  ProductCubit({required this.appRepository}) : super(ProductInitial());

  Future<CategoryResponse?> getCategory(String id) async {
    CategoryResponse? result;
    ApiResult<CategoryResponse> apiResult = await appRepository.category(id);
    apiResult.when(success: (CategoryResponse response) async {
      result = response;
    }, failure: (NetworkExceptions error) {
      print(error);
      result = null;
    });

    return result;
  }

  void getList({required int pageKey}) async {
    emit(ProductInitial());
    ApiResult<List<ProductResponse>> apiResult = await appRepository
        .productList(page: pageKey, limit: 10, search: search);
    apiResult.when(success: (List<ProductResponse> response) async {
      int lastpage = response.length;
      final isLastPage = lastpage < 10;
      final nextPageKey = isLastPage ? null : pageKey + 1;
      emit(ListProduct(
        itemList: response,
        nextPageKey: nextPageKey,
        error: null,
      ));
    }, failure: (NetworkExceptions error) {
      emit(ProductFailure(NetworkExceptions.getErrorMessage(error)));
    });
  }

  void getProduct(String id) async {
    emit(ProductLoading());
    ApiResult<ProductResponse> apiResult = await appRepository.product(id);
    apiResult.when(success: (ProductResponse response) async {
      emit(GetProductSuccess(product: response));
    }, failure: (NetworkExceptions error) {
      emit(ProductFailure(NetworkExceptions.getErrorMessage(error)));
    });
  }

  void deleteProduct(String categoryId, String id) async {
    emit(ProductLoading());
    ApiResult<dynamic> apiResult =
        await appRepository.deleteProduct(categoryId, id);
    apiResult.when(success: (dynamic response) async {
      emit(DeleteProductSuccess());
    }, failure: (NetworkExceptions error) {
      emit(ProductFailure(NetworkExceptions.getErrorMessage(error)));
    });
  }

  void inputSearch({String? value}) {
    emit(ProductInitial());
    search = value;
    emit(ProductRefreshData());
  }

  void refreshData() {
    emit(ProductInitial());
    emit(ProductRefreshData());
  }
}
