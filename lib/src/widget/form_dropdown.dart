import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klontong/src/utils/const.dart';

class FormDropdown extends StatefulWidget {
  final String? label;
  final String? labelDesc;
  final List<DropdownData> listData;
  final DropdownData? selectedItem;
  final String? hintText;
  final bool isTopLabel, isRequired;
  final Function(DropdownData?)? onChanged;
  final IconData? icon;
  final bool withClearData;
  final bool withoutLabel;
  final double? heightLabelWithForm;
  final bool isUnderLineBorder, withBorder;
  final double? borderRadius;
  final Widget? prefixIcon;

  const FormDropdown(
      {super.key,
      this.label,
      this.labelDesc,
      required this.listData,
      this.selectedItem,
      this.isTopLabel = false,
      this.isRequired = false,
      this.hintText,
      this.onChanged,
      this.icon,
      this.withClearData = true,
      this.withoutLabel = false,
      this.heightLabelWithForm,
      this.isUnderLineBorder = true,
      this.withBorder = true,
      this.borderRadius,
      this.prefixIcon});

  @override
  State<FormDropdown> createState() => _FormDropdownState();
}

class _FormDropdownState extends State<FormDropdown> {
  Color lineColor = AppColors.primary;
  bool errorColor = false;

  void changeColor(Color color, {bool error = false}) {
    setState(() {
      errorColor = error;
      lineColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
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
          DropdownSearch<DropdownData>(
            suffixProps: DropdownSuffixProps(
              clearButtonProps: ClearButtonProps(
                isVisible: widget.withClearData,
                iconSize: 20.h,
                padding: EdgeInsets.zero,
                alignment: Alignment.centerRight,
              ),
            ),
            popupProps: PopupProps.modalBottomSheet(
              title: !widget.isTopLabel
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
                      child: Text(
                        widget.label ?? "",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    )
                  : null,
              showSearchBox: true,
              modalBottomSheetProps: ModalBottomSheetProps(
                barrierColor: Colors.black87,
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: "Cari data...",
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24.h,
                  ),
                  prefixIconColor: lineColor,
                  isDense: true,
                  hintStyle: TextStyle(
                    fontSize: 12.sp,
                    color: Color.fromRGBO(115, 115, 115, 1),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              listViewProps: ListViewProps(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.w,
                ),
              ),
              itemBuilder: (context, item, isSelected, selected) {
                bool _selected = item == widget.selectedItem;
                return Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColors.secondary))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name ?? "",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: _selected
                            ? Icon(
                                Icons.check,
                                size: 24.h,
                                color: AppColors.primary,
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                );
              },
            ),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
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
                isDense: true,
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: Color.fromRGBO(115, 115, 115, 1),
                ),
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.secondary,
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
              baseStyle: TextStyle(
                fontSize: 14.sp,
                color: AppColors.secondary,
              ),
            ),
            itemAsString: (item) => item.name ?? "",
            items: (f, cs) => widget.listData,
            selectedItem: widget.selectedItem,
            onChanged: widget.onChanged,
            compareFn: (item1, item2) => item1.id == item2.id,
            validator: (DropdownData? item) {
              if (widget.isRequired && item == null) {
                changeColor(AppColors.danger, error: true);
                return Const.IS_REQUIRED;
              }

              return null;
            },
          )
        ],
      ),
    );
  }
}

class DropdownData {
  String? id;
  String? name;

  DropdownData({this.id, this.name});

  DropdownData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
