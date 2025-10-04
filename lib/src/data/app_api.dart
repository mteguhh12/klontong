import 'package:dio/dio.dart';
import 'package:klontong/src/data/request/category_request.dart';
import 'package:klontong/src/data/request/product_request.dart';
import 'package:klontong/src/data/response/category_response.dart';
import 'package:klontong/src/data/response/product_response.dart';
import 'package:klontong/src/utils/logger.dart';

import 'package:retrofit/http.dart';

part 'app_api.g.dart';

@RestApi()
abstract class AppApi {
  factory AppApi(Dio dio, {String baseUrl}) = _AppApi;

  @GET("product")
  Future<List<ProductResponse>> productList(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("search") String? search,
  );

  @GET("product/{id}")
  Future<ProductResponse> product(
    @Path("id") String id,
  );

  @POST("product")
  Future<dynamic> insertProduct(
    @Body() ProductRequest? request,
  );

  @PUT("product/{id}")
  Future<dynamic> updateProduct(
    @Path("id") String id,
    @Body() ProductRequest? request,
  );

  @DELETE("category/{categoryId}/product/{id}")
  Future<dynamic> deleteProduct(
    @Path("categoryId") String categoryId,
    @Path("id") String id,
  );

  @GET("category")
  Future<List<CategoryResponse>> categoryList(
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("search") String? search,
  );

  @GET("category/{id}")
  Future<CategoryResponse> category(
    @Path("id") String id,
  );

  @POST("category")
  Future<dynamic> insertCategory(
    @Body() CategoryRequest? request,
  );

  @PUT("category/{id}")
  Future<dynamic> updateCategory(
    @Path("id") String id,
    @Body() CategoryRequest? request,
  );

  @DELETE("category/{id}")
  Future<dynamic> deleteCategory(
    @Path("id") String id,
  );
}
