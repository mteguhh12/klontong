import 'package:klontong/src/data/network/service/api_result.dart';
import 'package:klontong/src/data/network/service/app_client.dart';
import 'package:klontong/src/data/request/category_request.dart';
import 'package:klontong/src/data/request/product_request.dart';
import 'package:klontong/src/data/response/category_response.dart';
import 'package:klontong/src/data/response/product_response.dart';

import 'base_repository.dart';

class AppRepository extends BaseRepository {
  Future<ApiResult<List<ProductResponse>>> productList({
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      List<ProductResponse> response =
          await appClient.productList(page, limit, search);
      return ApiResult.success(data: response);
    } catch (e) {
      return handleErrorApi(e);
    }
  }

  Future<ApiResult<ProductResponse>> product(String id) async {
    try {
      ProductResponse response = await appClient.product(id);
      return ApiResult.success(data: response);
    } catch (e) {
      return handleErrorApi(e);
    }
  }

  Future<ApiResult<dynamic>> insertProduct(ProductRequest request) async {
    try {
      dynamic response = await appClient.insertProduct(request);
      return ApiResult.success(data: response);
    } catch (e) {
      return handleErrorApi(e);
    }
  }

  Future<ApiResult<dynamic>> updateProduct(String id,
      {required ProductRequest request}) async {
    try {
      dynamic response = await appClient.updateProduct(id, request);
      return ApiResult.success(data: response);
    } catch (e) {
      return handleErrorApi(e);
    }
  }

  Future<ApiResult<dynamic>> deleteProduct(String categoryId, String id) async {
    try {
      dynamic response = await appClient.deleteProduct(categoryId, id);
      return ApiResult.success(data: response);
    } catch (e) {
      return handleErrorApi(e);
    }
  }

  Future<ApiResult<List<CategoryResponse>>> categoryList({
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      List<CategoryResponse> response =
          await appClient.categoryList(page, limit, search);
      return ApiResult.success(data: response);
    } catch (e) {
      return handleErrorApi(e);
    }
  }

  Future<ApiResult<CategoryResponse>> category(String id) async {
    try {
      CategoryResponse response = await appClient.category(id);
      return ApiResult.success(data: response);
    } catch (e) {
      return handleErrorApi(e);
    }
  }

  Future<ApiResult<dynamic>> insertCategory(CategoryRequest request) async {
    try {
      dynamic response = await appClient.insertCategory(request);
      return ApiResult.success(data: response);
    } catch (e) {
      return handleErrorApi(e);
    }
  }

  Future<ApiResult<dynamic>> updateCategory(String id,
      {required CategoryRequest request}) async {
    try {
      dynamic response = await appClient.updateCategory(id, request);
      return ApiResult.success(data: response);
    } catch (e) {
      return handleErrorApi(e);
    }
  }

  Future<ApiResult<dynamic>> deleteCategory(
    String id,
  ) async {
    try {
      dynamic response = await appClient.deleteCategory(id);
      return ApiResult.success(data: response);
    } catch (e) {
      return handleErrorApi(e);
    }
  }
}
