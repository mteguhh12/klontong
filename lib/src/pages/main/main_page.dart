import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:klontong/src/pages/category/category_cubit.dart';
import 'package:klontong/src/pages/category/category_page.dart';
import 'package:klontong/src/pages/category/form/form_category_page.dart';
import 'package:klontong/src/pages/product/form/form_product_page.dart';
import 'package:klontong/src/pages/product/product_cubit.dart';
import 'package:klontong/src/pages/product/product_page.dart';
import 'package:klontong/src/utils/const.dart';
import 'package:klontong/src/utils/navigation_utils.dart';
import 'package:klontong/src/utils/utils.dart';
import 'package:klontong/src/widget/form_input.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: GestureDetector(
          onTap: () => Utils.hideKeyboard(context),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16.h,
              right: 16.w,
              left: 16.w,
              bottom: 16.h,
            ),
            child: Column(
              children: [
                FormInput(
                  label: "Search Product",
                  controller: searchController,
                  isUnderLineBorder: false,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                  textInputAction: TextInputAction.search,
                  prefixIcon: Icon(
                    Icons.search,
                    size: 25.sp,
                    color: AppColors.primary,
                  ),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();
                    _debounce = Timer(const Duration(seconds: 1), () {
                      context
                          .read<ProductCubit>()
                          .inputSearch(value: value.isNotEmpty ? value : null);
                    });
                  },
                  onFieldSubmitted: (value) {
                    context
                        .read<ProductCubit>()
                        .inputSearch(value: value.isNotEmpty ? value : null);
                  },
                ),
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                        icon: _tabWidget(
                            icon: FontAwesomeIcons.boxOpen, name: "Product")),
                    Tab(
                        icon: _tabWidget(
                            icon: FontAwesomeIcons.list, name: "Category")),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ProductPage(),
                      CategoryPage(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          type: ExpandableFabType.up,
          childrenAnimation: ExpandableFabAnimation.none,
          distance: 70,
          overlayStyle: ExpandableFabOverlayStyle(
            color: Colors.white.withOpacity(0.3),
          ),
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: Icon(Icons.add, size: 30),
          ),
          children: [
            FloatingActionButton(
              heroTag: "product_add",
              child: Icon(
                FontAwesomeIcons.boxOpen,
                size: 24.sp,
              ),
              onPressed: () =>
                  NavigationUtils.rootNavigatePage(context, FormProductPage())
                      .then((value) {
                if (value == Const.ACTION_REFRESH) {
                  context.read<ProductCubit>().refreshData();
                  Utils.showToast(context, "Insert Product Success");
                }
              }),
            ),
            FloatingActionButton(
              heroTag: "category_add",
              child: Icon(
                FontAwesomeIcons.list,
                size: 24.sp,
              ),
              onPressed: () =>
                  NavigationUtils.rootNavigatePage(context, FormCategoryPage())
                      .then((value) {
                if (value == Const.ACTION_REFRESH) {
                  context.read<CategoryCubit>().refreshData();
                  Utils.showToast(context, "Insert Category Success");
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabWidget({IconData? icon, required String name}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 26.sp,
        ),
        SizedBox(
          width: 16.w,
        ),
        Text(
          name,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
