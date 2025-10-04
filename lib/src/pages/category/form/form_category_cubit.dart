import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/src/data/network/repository/app_repository.dart';
import 'package:klontong/src/data/network/service/api_result.dart';
import 'package:klontong/src/data/network/service/network_exceptions.dart';
import 'package:klontong/src/data/request/category_request.dart';
import 'package:klontong/src/pages/category/form/form_category_state.dart';
import 'package:klontong/src/utils/form_key.dart';
import 'package:klontong/src/utils/logger.dart';

class FormCategoryCubit extends Cubit<FormCategoryState> {
  final AppRepository appRepository;
  final Map<String, dynamic> formData;
  final TextEditingController nameController = TextEditingController();

  FormCategoryCubit({required this.appRepository, required this.formData})
      : super(FormCategoryInitial()) {
    nameController.text = formData[FormKeyCategory.NAME] ?? "";
  }

  void updateData(String key, dynamic value) async {
    emit(FormCategoryLoading());
    formData[key] = value;
    logger.d(formData);
    emit(FormCategoryInitial());
  }

  void submitForm(bool isUpdate) async {
    emit(FormCategoryLoading());

    final request = CategoryRequest(
      name: formData[FormKeyCategory.NAME],
    );

    if (!isUpdate) {
      ApiResult<dynamic> apiResult =
          await appRepository.insertCategory(request);
      apiResult.when(success: (response) async {
        emit(FormCategorySuccess());
      }, failure: (NetworkExceptions error) async {
        emit(FormCategoryFailure(NetworkExceptions.getErrorMessage(error)));
      });
    } else {
      ApiResult<dynamic> apiResult = await appRepository
          .updateCategory(formData[FormKeyCategory.ID], request: request);
      apiResult.when(success: (dynamic response) async {
        emit(FormCategorySuccess());
      }, failure: (NetworkExceptions error) async {
        emit(FormCategoryFailure(NetworkExceptions.getErrorMessage(error)));
      });
    }
  }
}
