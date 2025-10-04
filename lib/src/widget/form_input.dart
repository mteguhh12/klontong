import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klontong/src/utils/const.dart';

class FormInput extends StatefulWidget {
  const FormInput(
      {super.key,
      this.label,
      this.labelDesc,
      this.isTopLabel = false,
      required this.controller,
      this.hintText,
      this.prefixIcon,
      this.onChanged,
      this.onFieldSubmitted,
      this.onTap,
      this.isPassword = false,
      this.validation,
      this.isEmail = false,
      this.isRequired = false,
      this.suffixIcon,
      this.focusNode,
      this.maxLines,
      this.borderRadius,
      this.isChangeColorIcon = true,
      this.isUnderLineBorder = true,
      this.readOnly,
      this.keyboardType = TextInputType.text,
      this.inputFormatters,
      this.textInputAction = TextInputAction.done,
      this.heightLabelWithForm,
      this.isMatch = false,
      this.textMatches,
      this.withBorder = true,
      this.paddingWidget,
      this.maxHeightForm = double.infinity,
      this.contentPadding,
      this.fillColor,
      this.withoutLabel = false});
  final String? label;
  final String? labelDesc;
  final String? hintText;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final bool isTopLabel,
      isPassword,
      isEmail,
      isRequired,
      isUnderLineBorder,
      isMatch,
      withBorder;
  final validation;
  final FocusNode? focusNode;
  final int? maxLines;
  final double? borderRadius;
  final bool isChangeColorIcon;
  final bool? readOnly;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final double? heightLabelWithForm;
  final String? textMatches;
  final EdgeInsetsGeometry? paddingWidget;
  final double maxHeightForm;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool withoutLabel;

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  bool obscureText = false;
  Color lineColor = AppColors.primary;
  bool errorColor = false;

  @override
  void initState() {
    super.initState();
    if (widget.isPassword) {
      obscureText = widget.isPassword;
    }
  }

  void changeColor(Color color, {bool error = false}) {
    setState(() {
      errorColor = error;
      lineColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.paddingWidget ?? EdgeInsets.only(bottom: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.withoutLabel) ...[
            if (widget.isTopLabel) ...[
              Text(
                "${widget.label}",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(
                height: widget.heightLabelWithForm ?? 12.h,
              ),
            ],
          ],
          Focus(
            onFocusChange: (value) {
              if (widget.isChangeColorIcon) {
                if (!errorColor) {
                  if (value) {
                    changeColor(AppColors.secondary);
                  } else {
                    changeColor(AppColors.primary);
                  }
                }
              }
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: widget.maxHeightForm),
              child: TextFormField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                onFieldSubmitted: widget.onFieldSubmitted,
                obscureText: obscureText,
                focusNode: widget.focusNode,
                maxLines: widget.maxLines ?? (widget.isPassword ? 1 : null),
                readOnly: widget.readOnly ?? false,
                decoration: InputDecoration(
                  filled: widget.fillColor != null ? true : false,
                  fillColor: widget.fillColor,
                  contentPadding: widget.contentPadding,
                  label: widget.isTopLabel
                      ? null
                      : (!widget.withoutLabel
                          ? ((widget.label ?? "").isNotEmpty
                              ? Text.rich(
                                  TextSpan(
                                    text: widget.label,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: !errorColor
                                          ? AppColors.secondary
                                          : AppColors.danger,
                                    ),
                                    children: [
                                      if (widget.isRequired) ...[
                                        WidgetSpan(
                                          alignment: PlaceholderAlignment.top,
                                          child: Transform.translate(
                                            offset: Offset(0, -1),
                                            child: Text(
                                              " * ",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: AppColors.danger,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      if (widget.labelDesc != null) ...[
                                        WidgetSpan(
                                          alignment: PlaceholderAlignment.top,
                                          child: Transform.translate(
                                            offset: Offset(0, -1),
                                            child: Text(
                                              widget.labelDesc ?? "",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: AppColors.danger,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                )
                              : null)
                          : null),
                  hintText: widget.hintText,
                  prefixIcon: widget.prefixIcon,
                  prefixIconColor: lineColor,
                  suffixIcon: widget.suffixIcon ??
                      (widget.isPassword
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: obscureText
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility))
                          : null),
                  isDense: (widget.label ?? "").isNotEmpty,
                  hintStyle: TextStyle(
                    fontSize: 12.sp,
                    color: Color.fromRGBO(115, 115, 115, 1),
                  ),
                  border: widget.withBorder
                      ? (widget.isUnderLineBorder
                          ? UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  widget.borderRadius ?? 20),
                              borderSide: BorderSide(color: AppColors.primary),
                            ))
                      : InputBorder.none,
                  focusedBorder: widget.withBorder
                      ? (widget.isUnderLineBorder
                          ? UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  widget.borderRadius ?? 20),
                              borderSide: BorderSide(color: AppColors.primary),
                            ))
                      : InputBorder.none,
                  errorBorder: widget.withBorder
                      ? (widget.isUnderLineBorder
                          ? UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.danger),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  widget.borderRadius ?? 20),
                              borderSide: BorderSide(color: AppColors.danger),
                            ))
                      : InputBorder.none,
                ),
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                textInputAction: widget.textInputAction,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.secondary,
                ),
                validator: (value) {
                  final emailRegExp =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (widget.isRequired && value!.isEmpty) {
                    changeColor(AppColors.danger, error: true);
                    return Const.IS_REQUIRED;
                  }
                  if (widget.isEmail && !emailRegExp.hasMatch(value!)) {
                    changeColor(AppColors.danger, error: true);
                    return Const.IS_VALID_EMAIL;
                  }

                  if (widget.isMatch && widget.textMatches != null) {
                    if (widget.textMatches != value) {
                      return Const.IS_MATCH;
                    }
                  }
                  changeColor(AppColors.primary);
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
