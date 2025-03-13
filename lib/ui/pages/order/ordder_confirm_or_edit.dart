// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/discount_cubit/discount_cubit.dart';
import 'package:golden_thailand/blocs/pending_order_cubit/pending_order_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/data/models/order_pending_model.dart';
import 'package:golden_thailand/ui/pages/payment/online_payment.dart';
import 'package:golden_thailand/ui/pages/payment/cash.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/total_and_tax_widget.dart';
import 'package:golden_thailand/ui/widgets/payment_button.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/blocs/category_cubit/category_cubit.dart';
import 'package:golden_thailand/blocs/products_cubit/products_cubit.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
import 'package:golden_thailand/data/models/response_models/category_model.dart';
import 'package:golden_thailand/data/models/response_models/product_model.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/cart_item_list_widget.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/checkout_dialog.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/product_list_widget.dart';
import 'package:golden_thailand/ui/widgets/internetCheckWidget.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/home_drawer.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';

class OrderConfirmOrEdit extends StatefulWidget {
  const OrderConfirmOrEdit({super.key, required this.pendingOrder});

  final PendingOrder pendingOrder;

  @override
  State<OrderConfirmOrEdit> createState() => _OrderConfirmOrEditState();
}

class _OrderConfirmOrEditState extends State<OrderConfirmOrEdit> {
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

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().updateCart(
          remark: widget.pendingOrder.remark,
          items: widget.pendingOrder.items,
          dine_in_or_percel: isTakeAway ? 0 : 1,
          tableId: widget.pendingOrder.tableId,
          tableNumber: widget.pendingOrder.tableNumber,
          menu_type_id: widget.pendingOrder.menu_type_id,
        );
    context.read<ProductsCubit>().getAllProducts();
    context.read<CategoriesCubit>().getAllCategories();
    context.read<DiscountCubit>().getValue().then((value) {
      setState(() {
        discount = int.parse(value);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pendingOrderController.dispose();
    super.dispose();
  }

  void getDiscountData() async {}

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        return WillPopScope(
          onWillPop: () async {
            await _updatePendingOrderListAndPop(context, cartState);
            return true;
          },
          child: Scaffold(
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
              child: _form(screenSize: screenSize),
              onRefresh: () {
                context.read<ProductsCubit>().getAllProducts();
                context.read<CategoriesCubit>().getAllCategories();
              },
            ),
          ),
        );
      },
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
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, cartState) {
                  return IconButton(
                    onPressed: () async {
                      await _updatePendingOrderListAndPop(context, cartState);
                    },
                    icon: Icon(
                      Icons.clear,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      title: Text(
        "${tr(LocaleKeys.lblTableId)} ${widget.pendingOrder.tableNumber}",
        style: TextStyle(fontFamily: "Outfit"),
      ),
    );
  }

  Future<void> _updatePendingOrderListAndPop(
    BuildContext context,
    CartState cartState,
  ) async {
    print("testing");
    await context.read<PendingOrderCubit>().updateCardItemOrPendingOrder(
          pendingOrder: widget.pendingOrder,
          cartItem: cartState.items,
        );
    await Future.delayed(Duration(milliseconds: 1));
    await context.read<CartCubit>().clearOrderr();
    Navigator.pop(context);
  }

  ///main form of the home screen
  Row _form({required Size screenSize}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///left side of the screen
        _productsForm(
          screenSize: screenSize,
        ),

        ///right side of the screen
        _receiveForm(
          screenSize: screenSize,
        ),
      ],
    );
  }

  ///receive form (show cart items with payment buttons) right part of the home sreen
  Widget _receiveForm({
    required Size screenSize,
  }) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        CartCubit cartCubit = BlocProvider.of<CartCubit>(context);
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
                          "${tr(LocaleKeys.lblPendingOrder)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: SScolor.primaryColor,
                            fontSize: FontSize.semiBig - 3,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),

                  ///cart item list widget
                  cartItemListWidget(
                      screenSize: screenSize,
                      state: state,
                      context: context,
                      tableController: tableController),

                  ///total price,VAT and grand total widgt
                  totalAndVATHomeWidget(
                      context: context,
                      cartCubit: cartCubit,
                      discount: discount),

                  SizedBox(height: 10),

                  ///
                  _paymentButtonsWidget(),
                  //place order
                  SizedBox(height: 10),
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
                        onPressed: () async {
                          if (state.items.length > 0) {
                            int subAmount = cartCubit.getTotalAmount();
                            int totalAmount =
                                await calculateDiscount(context, subAmount);
                            int VAT = get7percentage(totalAmount);
                            int grandTotal = VAT+totalAmount;
                            int discount = int.parse(await context.read<DiscountCubit>().getValue());
                            if (cashPayment) {
                              redirectTo(
                                context: context,
                                form: CashScreen(
                                  subTotal: totalAmount,
                                  VAT: VAT,
                                  order: widget.pendingOrder,
                                  grandTotal: grandTotal,
                                  discount: discount,
                                ),
                              );
                            } else if (PromptPayment) {
                              redirectTo(
                                context: context,
                                form: OnlinePaymentScreen(
                                  subTotal: totalAmount,
                                  VAT: VAT,
                                  order: widget.pendingOrder,
                                  grandTotal: grandTotal,
                                  discount: discount,
                                ),
                              );
                            }
                          } else {
                            showCustomSnackbar(
                                context: context,
                                message: "Order List is empty!");
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.cart),
                            SizedBox(width: 8),
                            Text("${tr(LocaleKeys.lblCheckedout)}"),
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

  ///PAYMENT BUTTONS WIDGET
  Container _paymentButtonsWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 11),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  cashPayment = !cashPayment;
                  PromptPayment = false;
                });
              },
              child: PaymentButton(
                isSelected: cashPayment,
                title: "Cash",
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  cashPayment = false;
                  PromptPayment = !PromptPayment;
                });
              },
              child: PaymentButton(
                isSelected: PromptPayment,
                title: "Prompt Pay",
              ),
            ),
          ),
        ],
      ),
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
          message: "Choose payment method",
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
                            ...state.categoriesList
                                .map(
                                  (e) => categoryBoxWithProducts(
                                    constraints: constraints,
                                    category: e,
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
  }) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: Container(
        width: (constraints.maxWidth / 3) - (MyPadding.normal),
        height: constraints.maxHeight / 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
                    fontWeight: FontWeight.normal,
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
                  return loadingWidget();
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
                  return Text("hello world");
                }
              },
            ),
          ],
        ),
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
          is_buffet: defaultProduct.is_buffet,
          name: defaultProduct.name.toString(),
          name_th: defaultProduct.name_th.toString(),
          price: defaultProduct.price ?? 0,
          qty: 1,
          totalPrice: defaultProduct.price ?? 0,
          is_gram: defaultProduct.is_gram ?? false,
        );
      }
    } catch (e) {
      print("error : ${e}");
    }
  }
}
