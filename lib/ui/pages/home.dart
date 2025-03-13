import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/discount_cubit/discount_cubit.dart';
import 'package:golden_thailand/blocs/table_cubit/table_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/total_and_tax_widget.dart';
import 'package:golden_thailand/ui/widgets/table_number_dialog.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/blocs/category_cubit/category_cubit.dart';
import 'package:golden_thailand/blocs/products_cubit/products_cubit.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
import 'package:golden_thailand/data/models/response_models/category_model.dart';
import 'package:golden_thailand/data/models/response_models/product_model.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/cart_item_list_widget.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/checkout_dialog.dart';
import 'package:golden_thailand/ui/widgets/order_manage_button.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/product_list_widget.dart';
import 'package:golden_thailand/ui/widgets/internetCheckWidget.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/home_drawer.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  TextEditingController _pendingOrderController = TextEditingController();

  ScrollController categoryScrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ///VAT amount
  num VATAmount = 0;

  ///payment type
  bool PromptPayment = false;
  bool cashPayment = true;

  bool isTakeAway = false;

  int discount = 0;

  ScrollController _scrollController = ScrollController();

  CartItem? defaultItem;

  TextEditingController tableController = TextEditingController();

  RefreshController refresherController = RefreshController();

  @override
  void didChangeDependencies() {
    defaultItem = null;
    super.didChangeDependencies();
  }

  // This method triggers a UI rebuild
  void updateLanguage() {
    setState(() {}); // Triggers a rebuild of the widget tree
  }

  @override
  void initState() {
    super.initState();

    context.read<ProductsCubit>().getAllProducts();
    context.read<CategoriesCubit>().getAllCategories();
    context.read<TableCubit>().getAllLevels(); context.read<DiscountCubit>().getValue().then((value){
      setState(() {
        discount = int.parse(value);
      });
    });

    //show table number dialog at the first state of the app
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) {
    //     showDialog(
    //       context: _scaffoldKey.currentContext!,
    //       barrierDismissible: false,
    //       builder: (context) {
    //         return TableNumberDialog(
    //           tableController: tableController,
    //         );
    //       },
    //     );
    //   },
    // );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pendingOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///cart bloc(cubit)
    CartCubit cartCubit = BlocProvider.of<CartCubit>(context);

    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: _homeAppBar(),
      drawer: HomeDrawer(
        onNavigate: () {
          setState(() {
            defaultItem = null;
          });
        },
      ),
      body: InternetCheckWidget(
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 context.read<PaymentApiCubit>().getData();
//               },
//               child: Text("testing"),
//             ),
//             BlocBuilder<PaymentApiCubit, PaymentApiState>(
//               builder: (context, state) {
//                 if (state is PaymentApiLoaded) {
// // Decode the base64 string into bytes
//                   Uint8List bytes =
//                       base64Decode(state.paymentModel.image_path.toString());

//                   // Return the Image widget using the decoded bytes
//                   return Image.memory(bytes);
//                 } else {
//                   return Container();
//                 }
//               },
//             )
//           ],
//         ),
        child: _form(screenSize: screenSize, cartCubit: cartCubit),
        onRefresh: () {
          context.read<ProductsCubit>().getAllProducts();
          context.read<CategoriesCubit>().getAllCategories();
        },
      ),
    );
  }

  ///home page app bar
  AppBar _homeAppBar() {
    return AppBar(
      centerTitle: true,
      leadingWidth: 85,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: MyPadding.normal),
          Container(
            margin: EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: IconButton(
                onPressed: () {
                  if (_scaffoldKey.currentState != null) {
                    _scaffoldKey.currentState!.openDrawer();
                  }
                },
                icon: Icon(
                  Icons.menu,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: OrderManageWidget()),
        SizedBox(
          width: MyPadding.normal,
        ),
      ],
      title: Text(
        "Golden Thailand",
        style: TextStyle(fontFamily: "Outfit"),
      ),
    );
  }

  ///receive form (show cart items with payment buttons) right part of the home sreen
  Widget _receiveForm({
    required Size screenSize,
    required CartCubit cartCubit,
  }) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height + 100,
            margin: EdgeInsets.only(
              right: MyPadding.normal,
              top: 5,
              bottom: 10,
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: MyPadding.small),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.bookmark),
                        SizedBox(width: 10),
                        Text(
                          "${tr(LocaleKeys.lblCart)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: SScolor.primaryColor,
                            fontSize: FontSize.semiBig - 3,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            context.read<CartCubit>().clearOrderr();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return TableNumberDialog(
                                  tableController: tableController,
                                  isBuffet: false,
                                  //cartCubit: cartCubit,
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // border: Border.all(
                              //   width: 0.5,
                              //   color: SScolor.primaryColor,
                              // ),
                              color: SScolor.whiteColor,
                            ),
                            child: Text(
                              "${tr(LocaleKeys.lblclearCart)}",
                              //"Clear Order",
                              style: TextStyle(
                                color: SScolor.primaryColor,
                                fontSize: FontSize.small - 4,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5),

                  ///cart item list widget
                  cartItemListWidget(
                    screenSize: screenSize,
                    state: state,
                    context: context,
                    tableController: tableController,
                  ),

                  ///total price,VAT and grand total widgt
                  totalAndVATHomeWidget(context: context,cartCubit: cartCubit,discount: discount),

                  //place order
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          showCheckoutDialog(cartCubit, context, screenSize);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.cart),
                            SizedBox(width: 8),
                            Text("${tr(LocaleKeys.lblNewOrder)}"),
                          ],
                        ),
                        //child: Text("Place Order"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///SHOW CHECKOUT DIALOG
  void showCheckoutDialog(
    CartCubit cartCubit,
    BuildContext context,
    Size screenSize,
  ) {
    if (cartCubit.state.items.length > 0) {
      if (cashPayment == false && PromptPayment == false) {
        showCustomSnackbar(
          message: "Choose Payment method",
          context: context,
        );
      } else {
        List<String> productNameList = [];
        cartCubit.state.items.forEach((element) {
          productNameList.add(element.name);
        });

        showDialog(
          context: context,
          builder: (context) {
            return CheckoutDialog(
              width: screenSize.width / 3,
            );
          },
        );
      }
    } else {
      showCustomSnackbar(
        message: "Items not added။",
        context: context,
      );
    }
  }

  ///widgets that show products  items
  Widget _productsForm({
    required Size screenSize,
    required CartCubit cartCubit,
  }) {
    return Container(
      width: screenSize.width * 0.71,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(left: MyPadding.normal),
      child: Column(
        children: [
          SizedBox(height: 6),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return BlocBuilder<CategoriesCubit, CategoriesState>(
                  builder: (context, state) {
                    if (state is CategoriesLoadingState) {
                      return loadingWidget();
                    } else if (state is CategoriesLoadedState) {
                      List<CategoryModel> categoryList =
                          state.categoriesList.reversed.toList();
                      return SmartRefresher(
                        enablePullDown: true,
                        //enablePullUp: true,
                        controller: refresherController,
                        physics: BouncingScrollPhysics(),
                        onRefresh: () async {
                          await context
                              .read<CategoriesCubit>()
                              .getAllCategories();
                          await context.read<ProductsCubit>().getAllProducts();

                          refresherController.refreshCompleted();

                          setState(() {});
                        },
                        child: Wrap(
                          runSpacing: MyPadding.normal,
                          spacing: MyPadding.normal,
                          alignment: WrapAlignment.start,
                          children: [
                            ///categories box row
                            ...categoryList
                                .map(
                                  (e) => categoryBoxWithProducts(
                                    constraints: constraints,
                                    category: e,
                                    isFirstIndex: categoryList.indexOf(e) == 0,
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
          ),
          SizedBox(height: 20),
          copyRightWidget(),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  ///category box widget
  Widget categoryBoxWithProducts({
    required BoxConstraints constraints,
    required CategoryModel category,
    required bool isFirstIndex,
  }) {
    var nomalWidth = (constraints.maxWidth / 3) - (MyPadding.normal);
    var firstWidth = (constraints.maxWidth - MyPadding.normal);
    return Container(
      width: isFirstIndex ? firstWidth : nomalWidth,
      height: isFirstIndex ? 150 : (constraints.maxHeight / 1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 10,
            color: Colors.grey.shade200,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
            height: 38,
            child: Center(
              child: Text(
                "${category.name}",
                style: TextStyle(
                  fontSize: FontSize.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: Divider(
              height: 0,
              thickness: 1,
            ),
          ),
          BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoadingState) {
                return Expanded(child: loadingWidget());
              } else if (state is ProductsLoadedState) {
                checkDefaultProduct(products: state.products);

                List<ProductModel> productList = state.products
                    .where((element) => element.category == category.name)
                    .toList();

                return productListScrollBar(
                  productList: productList,
                  context: context,
                  scrollController: _scrollController,
                  tableController: tableController,
                  isEditState: false,
                );
              } else {
                return Text("");
              }
            },
          ),
        ],
      ),
    );
  }

  ///to check the default product (eg. hinyi/anit)
  void checkDefaultProduct({required List<ProductModel> products}) {
    try {
      ProductModel? defaultProduct =
          products.where((element) => element.is_default == true).first;

      // ignore: unnecessary_null_comparison
      if (defaultProduct != null) {
        defaultItem = CartItem(
          id: defaultProduct.id!,
          name: defaultProduct.name.toString(),
          name_th: defaultProduct.name_th.toString(),
          price: defaultProduct.price ?? 0,
          qty: 1,
          totalPrice: defaultProduct.price ?? 0,
          is_gram: defaultProduct.is_gram ?? false,
          is_buffet: defaultProduct.is_buffet
        );
      }
    } catch (e) {
      print("error : ${e}");
    }
  }

  ///main form of the home screen
  Row _form({required Size screenSize, required CartCubit cartCubit}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///left side of the screen
        _productsForm(
          screenSize: screenSize,
          cartCubit: cartCubit,
        ),

        ///right side of the screen
        _receiveForm(
          screenSize: screenSize,
          cartCubit: cartCubit,
        ),
      ],
    );
  }
}
