import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/product_crud_cubit/product_crud_cubit.dart';
import 'package:golden_thailand/blocs/products_cubit/products_cubit.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/data/models/response_models/product_model.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/cancel_and_delete_dialog_button.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/delete_warning_dialog.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/product_card_widget.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/products_curd_dialog.dart';

class ProductCRUDPage extends StatefulWidget {
  const ProductCRUDPage({super.key, required this.title});
  final String title;

  @override
  State<ProductCRUDPage> createState() => _ProductCRUDPageState();
}

class _ProductCRUDPageState extends State<ProductCRUDPage> {
  var categoryNameController = TextEditingController();
  var productPriceController = TextEditingController();

  @override
  void initState() {
    context.read<ProductsCubit>().getAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        centerTitle: true,
        leading: appBarLeading(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("${widget.title}"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: SScolor.primaryColor,
        label: Text("${tr(LocaleKeys.lblNewAdd)}"),
        icon: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ProductCRUDDialog(
                screenSize: screenSize,
              );
            },
          );
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MyPadding.normal,
        ),
        child: _productListWidget(
          screenSize,
        ),
      ),
    );
  }

  Widget _productListWidget(Size screenSize) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoadingState) {
          return loadingWidget();
        } else if (state is ProductsLoadedState) {
          return state.products.length > 0
              ? GridView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20, top: 7.5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: MyPadding.normal,
                    crossAxisSpacing: MyPadding.normal,
                    childAspectRatio: screenSize.width * 0.002,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    ProductModel product = state.products[index];
                    return Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: productCardWidget(
                        context: context,
                        product: product,
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ProductCRUDDialog(
                                screenSize: screenSize,
                                product: product,
                              );
                            },
                          );
                        },
                        onDelete: () {
                          _deleteWarningDialog(
                            context: context,
                            screenSize: screenSize,
                            productId: product.id.toString(),
                          );
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "ထုတ်ကုန်မရှိပါ။!",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }

  ///delete category warning dialog box
  Future<dynamic> _deleteWarningDialog({
    required BuildContext context,
    required Size screenSize,
    required String productId,
  }) {
    return deleteWarningDialog(
      context: context,
      screenSize: screenSize,
      child: BlocBuilder<ProductCrudCubit, ProductCrudState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return loadingWidget();
          } else {
            return CancelAndDeleteDialogButton(
              onDelete: () async {
                await _deleteProductData(context, productId);
              },
            );
          }
        },
      ),
    );
  }

  ///delete product data
  Future<void> _deleteProductData(
    BuildContext context,
    String productId,
  ) async {
    await context
        .read<ProductCrudCubit>()
        .deleteProduct(productId: productId)
        .then(
      (value) {
        if (value) {
          Navigator.pop(context);
          context.read<ProductsCubit>().getAllProducts();
        }
      },
    );
  }
}
