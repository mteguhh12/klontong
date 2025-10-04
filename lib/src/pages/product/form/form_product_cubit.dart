import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:klontong/src/data/network/repository/app_repository.dart';
import 'package:klontong/src/data/network/service/api_result.dart';
import 'package:klontong/src/data/network/service/network_exceptions.dart';
import 'package:klontong/src/data/request/product_request.dart';
import 'package:klontong/src/data/response/category_response.dart';
import 'package:klontong/src/utils/form_key.dart';
import 'package:klontong/src/utils/logger.dart';
import 'package:klontong/src/utils/utils.dart';
import 'package:klontong/src/widget/form_dropdown.dart';

import 'form_product.dart';

class FormProductCubit extends Cubit<FormProductState> {
  final AppRepository appRepository;
  final Map<String, dynamic> formData;
  final TextEditingController photoUrlController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final MoneyMaskedTextController priceController = MoneyMaskedTextController(
    decimalSeparator: '',
    thousandSeparator: ',',
    precision: 0,
  );

  List<DropdownData> listCategory = [];
  FormProductCubit({required this.appRepository, required this.formData})
      : super(FormProductInitial()) {
    formData[FormKeyProduct.CATEGORYID] =
        formData[FormKeyProduct.CATEGORYID] ?? "";
    skuController.text = formData[FormKeyProduct.SKU] ?? "";
    nameController.text = formData[FormKeyProduct.NAME] ?? "";
    descriptionController.text = formData[FormKeyProduct.DESCRIPTION] ?? "";
    weightController.text = formData[FormKeyProduct.WEIGHT] is int
        ? formData[FormKeyProduct.WEIGHT].toString()
        : "";
    photoUrlController.text = formData[FormKeyProduct.IMAGE] ?? "";
    priceController.updateValue(double.tryParse(
            formData[FormKeyProduct.PRICE] is int
                ? formData[FormKeyProduct.PRICE].toString()
                : "0") ??
        0);
  }

  void getCategory() async {
    emit(FormProductLoading());
    ApiResult<List<CategoryResponse>> apiResult =
        await appRepository.categoryList();
    apiResult.when(success: (List<CategoryResponse> response) async {
      listCategory = response
          .map((e) => DropdownData(id: e.id.toString(), name: e.name))
          .toList();

      if (formData[FormKeyProduct.CATEGORYID] is String) {
        formData[FormKeyProduct.CATEGORYID] = listCategory.firstWhereOrNull(
            (e) => e.id == formData[FormKeyProduct.CATEGORYID]);
      }

      emit(GetCategorySuccess());
    }, failure: (NetworkExceptions error) {
      emit(FormProductFailure(NetworkExceptions.getErrorMessage(error)));
    });
  }

  void updateData(String key, dynamic value) async {
    emit(FormProductLoading());
    formData[key] = value;
    logger.d(formData);
    emit(FormProductInitial());
  }

  void submitForm(bool isUpdate) async {
    emit(FormProductLoading());

    final request = ProductRequest(
      categoryId: int.parse(
          (formData[FormKeyProduct.CATEGORYID] as DropdownData).id ?? "0"),
      sku: formData[FormKeyProduct.SKU],
      name: formData[FormKeyProduct.NAME],
      description: formData[FormKeyProduct.DESCRIPTION],
      weight: formData[FormKeyProduct.WEIGHT] is int
          ? formData[FormKeyProduct.WEIGHT]
          : int.parse(formData[FormKeyProduct.WEIGHT]),
      image: formData[FormKeyProduct.IMAGE],
      price: formData[FormKeyProduct.PRICE] is String
          ? Utils.parseMoneytoInt(formData[FormKeyProduct.PRICE])
          : formData[FormKeyProduct.PRICE],
    );

    if (!isUpdate) {
      ApiResult<dynamic> apiResult = await appRepository.insertProduct(request);
      apiResult.when(success: (response) async {
        emit(FormProductSuccess());
      }, failure: (NetworkExceptions error) async {
        emit(FormProductFailure(NetworkExceptions.getErrorMessage(error)));
      });
    } else {
      ApiResult<dynamic> apiResult = await appRepository
          .updateProduct(formData[FormKeyProduct.ID], request: request);
      apiResult.when(success: (dynamic response) async {
        emit(FormProductSuccess());
      }, failure: (NetworkExceptions error) async {
        emit(FormProductFailure(NetworkExceptions.getErrorMessage(error)));
      });
    }
  }
}
