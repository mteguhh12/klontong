import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klontong/src/data/network/repository/app_repository.dart';
import 'package:klontong/src/utils/const.dart';
import 'package:klontong/src/utils/form_key.dart';
import 'package:klontong/src/utils/navigation_utils.dart';
import 'package:klontong/src/utils/utils.dart';
import 'package:klontong/src/widget/button_widget.dart';
import 'package:klontong/src/widget/custom_appbar.dart';
import 'package:klontong/src/widget/form_input.dart';
import 'package:klontong/src/widget/stack_loading_view.dart';

import 'form_category.dart';

class FormCategoryPage extends StatefulWidget {
  final Map<String, dynamic>? initialFormData;
  const FormCategoryPage({super.key, this.initialFormData});

  @override
  State<FormCategoryPage> createState() => _FormCategoryPageState();
}

class _FormCategoryPageState extends State<FormCategoryPage> {
  final _formKey = GlobalKey<FormState>();

  late FormCategoryCubit _cubit;
  bool isUpdate = false;

  @override
  void initState() {
    AppRepository appRepository = AppRepository();
    Map<String, dynamic> formData = {};

    if (widget.initialFormData != null) {
      formData = widget.initialFormData!;
      isUpdate = true;
    }
    _cubit = FormCategoryCubit(
      appRepository: appRepository,
      formData: formData,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: appBar(context, "Form Category"),
        body: BlocProvider(
            create: (context) => _cubit,
            child: BlocConsumer<FormCategoryCubit, FormCategoryState>(
                listener: (context, state) {
              if (state is FormCategorySuccess) {
                NavigationUtils.pop(context, result: Const.ACTION_REFRESH);
              }
            }, builder: (context, state) {
              return KeyboardVisibilityBuilder(
                builder: (context, isKeyboardVisible) {
                  return GestureDetector(
                    onTap: () => Utils.hideKeyboard(context),
                    child: StackLoadingView(
                      visibleLoading: state is FormCategoryLoading,
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
                                    controller: _cubit.nameController,
                                    label: "Name",
                                    isRequired: true,
                                    onChanged: (value) {
                                      _cubit.updateData(
                                          FormKeyCategory.NAME, value);
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
            })),
      ),
    );
  }
}
