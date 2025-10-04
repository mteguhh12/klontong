import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:klontong/src/data/response/product_response.dart';
import 'package:klontong/src/pages/product/form/form_product_page.dart';
import 'package:klontong/src/pages/product/product.dart';
import 'package:klontong/src/utils/const.dart';
import 'package:klontong/src/utils/form_key.dart';
import 'package:klontong/src/utils/navigation_utils.dart';
import 'package:klontong/src/utils/utils.dart';
import 'package:klontong/src/widget/stack_loading_view.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;
  const ProductDetailPage({super.key, required this.id});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductResponse? product;

  @override
  void initState() {
    context.read<ProductCubit>().getProduct(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BlocConsumer<ProductCubit, ProductState>(
          listener: (context, state) {
            if (state is GetProductSuccess) {
              product = state.product;
            }

            if (state is DeleteProductSuccess) {
              NavigationUtils.pop(context, result: Const.ACTION_DELETE);
            }
          },
          builder: (context, state) {
            return StackLoadingView(
              visibleLoading: state is ProductLoading,
              child: Stack(
                children: [
                  FutureBuilder(
                      future: context
                          .read<ProductCubit>()
                          .getCategory(product?.categoryId ?? "0"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 350.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(product?.image ?? ""),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Expanded(
                                child: ListView(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.h, horizontal: 20.w),
                                  children: [
                                    Text(
                                      product?.name ?? "-",
                                      style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary),
                                    ),
                                    Text(
                                      "Category: ${snapshot.data?.name ?? "-"}",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Color(0xFF80869A)),
                                    ),
                                    Text(
                                      "SKU: ${product?.sku ?? "-"}",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Color(0xFF80869A)),
                                    ),
                                    Text(
                                      "Price: ${Utils.formatMoney(product?.price ?? 0)} | Weigth: ${product?.weight ?? "-"}",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Color(0xFF80869A)),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      product?.description ?? "",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.secondary),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }

                        return SizedBox();
                      }),
                  Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: 15.w,
                    child: InkWell(
                      onTap: () => NavigationUtils.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 24.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top,
                    right: 15.w,
                    child: PopupMenuButton(
                      icon: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: Icon(
                          Icons.more_vert_rounded,
                          size: 24.sp,
                          color: Colors.white,
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
                                    FormProductPage(
                                      initialFormData: {
                                        FormKeyProduct.ID: product?.id,
                                        FormKeyProduct.CATEGORYID:
                                            product?.categoryId,
                                        FormKeyProduct.SKU: product?.sku,
                                        FormKeyProduct.NAME: product?.name,
                                        FormKeyProduct.DESCRIPTION:
                                            product?.description,
                                        FormKeyProduct.WEIGHT: product?.weight,
                                        FormKeyProduct.IMAGE: product?.image,
                                        FormKeyProduct.PRICE: product?.price,
                                      },
                                    )).then((value) {
                                  if (value == Const.ACTION_REFRESH) {
                                    try {
                                      context
                                          .read<ProductCubit>()
                                          .getProduct(widget.id);
                                      context
                                          .read<ProductCubit>()
                                          .refreshData();
                                      Utils.showToast(
                                          context, "Update Product Success");
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  }
                                })),
                        popupMenuItemWidget(
                          title: "Delete",
                          icon: FontAwesomeIcons.trash,
                          iconColor: AppColors.danger,
                          onTap: () {
                            context.read<ProductCubit>().deleteProduct(
                                product?.categoryId ?? "0", product?.id ?? "0");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
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
