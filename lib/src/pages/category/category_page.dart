import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klontong/src/data/response/category_response.dart';
import 'package:klontong/src/pages/category/form/form_category_page.dart';
import 'package:klontong/src/utils/const.dart';
import 'package:klontong/src/utils/form_key.dart';
import 'package:klontong/src/utils/navigation_utils.dart';
import 'package:klontong/src/utils/utils.dart';

import 'category.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final PagingController<int, CategoryResponse> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      context.read<CategoryCubit>().getList(pageKey: pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state is ListCategory) {
          if (state.nextPageKey is int) {
            _pagingController.appendPage(
                state.itemList ?? [], state.nextPageKey);
          }
          if (state.nextPageKey == null) {
            _pagingController.appendLastPage(state.itemList ?? []);
          }
        }

        if (state is CategoryFailure) {
          _pagingController.error = state.error;
        }

        if (state is CategoryRefreshData) {
          _pagingController.refresh();
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedListView<int, CategoryResponse>.separated(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<CategoryResponse>(
              animateTransitions: true,
              firstPageErrorIndicatorBuilder: (context) => Icon(
                Icons.error_outline_rounded,
                size: 100.sp,
                color: Colors.red,
              ),
              noItemsFoundIndicatorBuilder: (context) => Icon(
                Icons.hourglass_empty,
                size: 100.sp,
                color: AppColors.secondary,
              ),
              itemBuilder: (context, data, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16.h),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.name ?? "-",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                      ),
                      PopupMenuButton(
                        icon: Container(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.more_vert_rounded,
                            size: 24.sp,
                          ),
                        ),
                        color: Colors.white,
                        offset: Offset(-5, 60),
                        elevation: 2,
                        constraints: BoxConstraints(minWidth: 187.w),
                        itemBuilder: (context) => [
                          popupMenuItemWidget(
                              title: "Edit",
                              icon: FontAwesomeIcons.penToSquare,
                              iconColor: AppColors.warning,
                              onTap: () => NavigationUtils.rootNavigatePage(
                                      context,
                                      FormCategoryPage(
                                        initialFormData: {
                                          FormKeyCategory.ID: data.id,
                                          FormKeyCategory.NAME: data.name,
                                        },
                                      )).then((value) {
                                    if (value == Const.ACTION_REFRESH) {
                                      _pagingController.refresh();
                                      Utils.showToast(
                                          context, "Update Category Success");
                                    }
                                  })),
                          popupMenuItemWidget(
                            title: "Delete",
                            icon: FontAwesomeIcons.trash,
                            iconColor: AppColors.danger,
                            onTap: () {
                              context
                                  .read<CategoryCubit>()
                                  .deleteCategory(data.id ?? "0")
                                  .then((_) {
                                _pagingController.refresh();
                                Utils.showToast(
                                    context, "Delete Category Success");
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            separatorBuilder: (_, __) => SizedBox(
              height: 20.h,
            ),
          ),
        );
      },
    );
  }

  PopupMenuItem popupMenuItemWidget(
      {VoidCallback? onTap, String? title, IconData? icon, Color? iconColor}) {
    return PopupMenuItem(
      onTap: onTap,
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24.sp,
            color: iconColor,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text("${title}",
              style: TextStyle(fontSize: 18.sp, color: Color(0xFF959191))),
        ],
      ),
    );
  }
}
