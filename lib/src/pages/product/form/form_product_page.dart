import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:klontong/src/data/network/repository/app_repository.dart';
import 'package:klontong/src/utils/const.dart';
import 'package:klontong/src/utils/form_key.dart';
import 'package:klontong/src/utils/navigation_utils.dart';
import 'package:klontong/src/utils/utils.dart';
import 'package:klontong/src/widget/button_widget.dart';
import 'package:klontong/src/widget/custom_appbar.dart';
import 'package:klontong/src/widget/form_dropdown.dart';
import 'package:klontong/src/widget/form_input.dart';
import 'package:klontong/src/widget/stack_loading_view.dart';
import 'package:klontong/src/widget/upload_modal_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'form_product.dart';

class FormProductPage extends StatefulWidget {
  final Map<String, dynamic>? initialFormData;
  const FormProductPage({super.key, this.initialFormData});

  @override
  State<FormProductPage> createState() => _FormProductPageState();
}

class _FormProductPageState extends State<FormProductPage> {
  final _formKey = GlobalKey<FormState>();
  late FormProductCubit _cubit;
  bool isUpdate = false;

  @override
  void initState() {
    AppRepository appRepository = AppRepository();
    Map<String, dynamic> formData = {};

    if (widget.initialFormData != null) {
      formData = widget.initialFormData!;
      isUpdate = true;
    }
    _cubit = FormProductCubit(
      appRepository: appRepository,
      formData: formData,
    );

    _cubit.getCategory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: appBar(context, "Form Product"),
        body: BlocProvider(
          create: (context) => _cubit,
          child: BlocConsumer<FormProductCubit, FormProductState>(
            listener: (context, state) {
              if (state is FormProductSuccess) {
                NavigationUtils.pop(context, result: Const.ACTION_REFRESH);
              }
            },
            builder: (context, state) {
              return KeyboardVisibilityBuilder(
                builder: (context, isKeyboardVisible) {
                  return GestureDetector(
                    onTap: () => Utils.hideKeyboard(context),
                    child: StackLoadingView(
                      visibleLoading: state is FormProductLoading,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.h, horizontal: 20.w),
                                children: [
                                  FormInput(
                                    controller: _cubit.photoUrlController,
                                    label: "Photo Url",
                                    isRequired: true,
                                    onChanged: (value) {
                                      _cubit.updateData(
                                          FormKeyProduct.IMAGE, value);
                                    },
                                  ),
                                  FormDropdown(
                                    label: "Category",
                                    listData: _cubit.listCategory,
                                    selectedItem: _cubit.formData[FormKeyProduct
                                            .CATEGORYID] is DropdownData
                                        ? _cubit
                                            .formData[FormKeyProduct.CATEGORYID]
                                        : null,
                                    withClearData: false,
                                    isRequired: true,
                                    onChanged: (data) {
                                      _cubit.updateData(
                                          FormKeyProduct.CATEGORYID, data);
                                    },
                                  ),
                                  FormInput(
                                    controller: _cubit.skuController,
                                    label: "SKU",
                                    isRequired: true,
                                    onChanged: (value) {
                                      _cubit.updateData(
                                          FormKeyProduct.SKU, value);
                                    },
                                  ),
                                  FormInput(
                                    controller: _cubit.nameController,
                                    label: "Name",
                                    isRequired: true,
                                    onChanged: (value) {
                                      _cubit.updateData(
                                          FormKeyProduct.NAME, value);
                                    },
                                  ),
                                  FormInput(
                                    controller: _cubit.descriptionController,
                                    label: "Description",
                                    maxLines: 2,
                                    isRequired: true,
                                    onChanged: (value) {
                                      _cubit.updateData(
                                          FormKeyProduct.DESCRIPTION, value);
                                    },
                                  ),
                                  FormInput(
                                    controller: _cubit.weightController,
                                    label: "Weight",
                                    keyboardType: TextInputType.number,
                                    isRequired: true,
                                    onChanged: (value) {
                                      _cubit.updateData(
                                          FormKeyProduct.WEIGHT, value);
                                    },
                                  ),
                                  FormInput(
                                    controller: _cubit.priceController,
                                    label: "Price",
                                    keyboardType: TextInputType.number,
                                    isRequired: true,
                                    onChanged: (value) {
                                      _cubit.updateData(
                                          FormKeyProduct.PRICE, value);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (!isKeyboardVisible)
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppColors.shadowColor,
                                        blurRadius: 3.0,
                                        offset: Offset(0.0, -3.0))
                                  ],
                                  color: Colors.white,
                                ),
                                child: ButtonWidget(
                                    title: isUpdate ? "Update" : "Submit",
                                    onTap: () => {
                                          if (_formKey.currentState!.validate())
                                            _cubit.submitForm(isUpdate)
                                        }),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _photoProduct() {
    return Container(
      padding: EdgeInsets.only(bottom: 25.h),
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.primary))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Photo Product",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.secondary,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Container(
                  height: 109.h,
                  width: 109.w,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    FontAwesomeIcons.image,
                    size: 40.sp,
                    color: Color(0xFF80869A),
                  )),
              Expanded(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Utils.hideKeyboard(context);
                        showModalUpload();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 11.h, horizontal: 50.w),
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Text(
                          "Upload Photo",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void showModalUpload() {
    showBarModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      expand: false,
      useRootNavigator: true,
      builder: (context) {
        return UploadModalWidget(
          onTapCamera: () {
            NavigationUtils.pop(context);
          },
          onTapGallery: () {
            NavigationUtils.pop(context);
          },
        );
      },
    );
  }
}
