import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/src/data/network/repository/app_repository.dart';
import 'package:klontong/src/data/network/service/api_result.dart';
import 'package:klontong/src/data/network/service/network_exceptions.dart';
import 'package:klontong/src/data/response/category_response.dart';

import 'category.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final AppRepository appRepository;
  CategoryCubit({required this.appRepository}) : super(CategoryInitial());

  void getList({required int pageKey, String? search}) async {
    emit(CategoryInitial());
    ApiResult<List<CategoryResponse>> apiResult = await appRepository
        .categoryList(page: pageKey, limit: 10, search: search);
    apiResult.when(success: (List<CategoryResponse> response) async {
      int lastpage = response.length;
      final isLastPage = lastpage < 10;
      final nextPageKey = isLastPage ? null : pageKey + 1;
      emit(ListCategory(
        itemList: response,
        nextPageKey: nextPageKey,
        error: null,
      ));
    }, failure: (NetworkExceptions error) {
      emit(CategoryFailure(NetworkExceptions.getErrorMessage(error)));
    });
  }

  Future<void> deleteCategory(String id) async {
    emit(CategoryLoading());
    ApiResult<dynamic> apiResult = await appRepository.deleteCategory(id);
    apiResult.when(success: (dynamic response) async {
      emit(DeleteCategorySuccess());
    }, failure: (NetworkExceptions error) {
      emit(CategoryFailure(NetworkExceptions.getErrorMessage(error)));
    });
  }

  void refreshData() {
    emit(CategoryInitial());
    emit(CategoryRefreshData());
  }
}
