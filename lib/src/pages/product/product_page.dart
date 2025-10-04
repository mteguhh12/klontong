import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klontong/src/data/response/product_response.dart';
import 'package:klontong/src/pages/product/product.dart';
import 'package:klontong/src/pages/product/product_detail_page.dart';
import 'package:klontong/src/utils/const.dart';
import 'package:klontong/src/utils/navigation_utils.dart';
import 'package:klontong/src/utils/utils.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PagingController<int, ProductResponse> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      context.read<ProductCubit>().getList(pageKey: pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ListProduct) {
          if (state.nextPageKey is int) {
            _pagingController.appendPage(
                state.itemList ?? [], state.nextPageKey);
          }
          if (state.nextPageKey == null) {
            _pagingController.appendLastPage(state.itemList ?? []);
          }
        }

        if (state is ProductFailure) {
          _pagingController.error = state.error;
        }

        if (state is ProductRefreshData) {
          _pagingController.refresh();
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedListView<int, ProductResponse>.separated(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<ProductResponse>(
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
                return FutureBuilder(
                    future: context
                        .read<ProductCubit>()
                        .getCategory(data.categoryId ?? "0"),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GestureDetector(
                          onTap: () => NavigationUtils.rootNavigatePage(
                              context,
                              ProductDetailPage(
                                id: data.id ?? "0",
                              )).then((value) {
                            if (value == Const.ACTION_DELETE) {
                              context.read<ProductCubit>().refreshData();
                              Utils.showToast(
                                  context, "Delete Product Success");
                            }
                          }),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 108.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(data.image ?? ""),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  width: 104.w,
                                  height: 108.h,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 12.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.name ?? "-",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary),
                                        ),
                                        Text(
                                          snapshot.data?.name ?? "-",
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Color(0xFF80869A)),
                                        ),
                                        Spacer(),
                                        Text(
                                          data.description ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppColors.secondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 24.sp,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SizedBox();
                    });
              },
            ),
            separatorBuilder: (_, __) => SizedBox(
              height: 20.h,
            ),
          ),
        );
      },
    );

    // return ListView.separated(
    //   padding: EdgeInsets.symmetric(vertical: 16.h),
    //   itemBuilder: (context, index) {
    //     return GestureDetector(
    //       onTap: () =>
    //           NavigationUtils.rootNavigatePage(context, ProductDetailPage()),
    //       child: Container(
    //         width: MediaQuery.of(context).size.width,
    //         height: 108.h,
    //         decoration: BoxDecoration(
    //           color: Colors.white.withOpacity(0.7),
    //           borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(20),
    //             bottomLeft: Radius.circular(20),
    //           ),
    //         ),
    //         child: Row(
    //           children: [
    //             Container(
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.only(
    //                   topLeft: Radius.circular(20),
    //                   bottomLeft: Radius.circular(20),
    //                 ),
    //                 image: DecorationImage(
    //                   image: AssetImage(AppImages.product),
    //                   fit: BoxFit.cover,
    //                 ),
    //               ),
    //               width: 104.w,
    //               height: 108.h,
    //             ),
    //             Expanded(
    //               child: Padding(
    //                 padding:
    //                     EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       "Ciki ciki",
    //                       style: TextStyle(
    //                           fontSize: 16.sp,
    //                           fontWeight: FontWeight.w600,
    //                           color: AppColors.primary),
    //                     ),
    //                     Text(
    //                       "Cemilan",
    //                       style: TextStyle(
    //                           fontSize: 12.sp, color: Color(0xFF80869A)),
    //                     ),
    //                     Text(
    //                       "Ciki ciki yang super enak, hanya di toko klontong kami",
    //                       maxLines: 2,
    //                       overflow: TextOverflow.ellipsis,
    //                       style: TextStyle(
    //                           fontSize: 14.sp, color: AppColors.secondary),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.symmetric(horizontal: 10.w),
    //               child: Icon(
    //                 Icons.chevron_right,
    //                 size: 24.sp,
    //                 color: AppColors.secondary,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    //   separatorBuilder: (_, __) => SizedBox(
    //     height: 20.h,
    //   ),
    //   itemCount: 10,
    // );
  }
}
