import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/discount_cubit/discount_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/ui/update_sale_ui/confirm_checkout_form.dart';
import 'package:iconly/iconly.dart';
import 'package:golden_thailand/blocs/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:golden_thailand/blocs/edit_sale_cart_cubit/edit_sale_cart_state.dart';
import 'package:golden_thailand/blocs/category_cubit/category_cubit.dart';
import 'package:golden_thailand/blocs/products_cubit/products_cubit.dart';
import 'package:golden_thailand/blocs/sales_history_cubit/sales_history_cubit.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
import 'package:golden_thailand/data/models/response_models/category_model.dart';
import 'package:golden_thailand/data/models/response_models/product_model.dart';
import 'package:golden_thailand/data/models/response_models/sale_history_model.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/cart_item_widget.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/product_row_widget.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/quantity_dialog_control.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/weight_dialog_control.dart';
import 'package:golden_thailand/ui/widgets/internetCheckWidget.dart';
import 'package:golden_thailand/ui/widgets/payment_button.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';

class EditSaleScreen extends StatefulWidget {
  const EditSaleScreen({
    super.key,
    required this.orderNo,
    required this.saleHistory,
  });

  final String orderNo;
  final SaleHistoryModel saleHistory;

  @override
  State<EditSaleScreen> createState() => _EditSaleScreenState();
}

class _EditSaleScreenState extends State<EditSaleScreen> {
  TextEditingController _pendingOrderController = TextEditingController();
  ScrollController scrollController = ScrollController();

  ScrollController categoryScrollController = ScrollController();

  ///bar code
  late bool visible;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ///payment type
  bool PromptPayment = false;
  bool cashPayment = true;

  bool isTakeAway = false;

  FocusNode searchFocusNode = FocusNode();

  CartItem? defaultItem;

  TextEditingController tableController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      setState(() {});
    });

    context.read<EditSaleCartCubit>().addAllData(
          items: widget.saleHistory.products
              .map(
                (e) => CartItem(
                  id: e.productId,
                  name: e.name,
                  name_th: e.name,
                  is_buffet: e.is_buffet,
                  price: e.price,
                  qty: e.qty,
                  totalPrice: e.totalPrice,
                  is_gram: e.isGram,
                ),
              )
              .toList(),
          tableNumber: int.parse(widget.saleHistory.tableNumber),
          remark: widget.saleHistory.remark,
        );
  }

  @override
  void dispose() {
    scrollController.dispose();
    _pendingOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EditSaleCartCubit cartCubit = BlocProvider.of<EditSaleCartCubit>(context);

    var screenSize = MediaQuery.of(context).size;

    if (cartCubit.state.tableNumber == 0) {}

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leadingWidth: 160,
          leading: appBarLeading(
            onTap: () {
              context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
              Navigator.pop(context);
            },
          ),
          title: Text(
            "${tr(LocaleKeys.lblEditOrder)} ${widget.orderNo}",
            style: TextStyle(
              fontFamily: "",
            ),
          ),
        ),
        body: InternetCheckWidget(
          child: _form(screenSize: screenSize, cartCubit: cartCubit),
          onRefresh: () {
            context.read<ProductsCubit>().getAllProducts();
            context.read<CategoriesCubit>().getAllCategories();
          },
        ),
      ),
    );
  }

  ///main form of the home screen
  Row _form({required Size screenSize, required EditSaleCartCubit cartCubit}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /**
         * left side of the screen
         */
        _productsAndCategoriesForm(
          screenSize: screenSize,
          cartCubit: cartCubit,
        ),

        /**
         * right side of the screen
         */
        _receiveForm(
          screenSize: screenSize,
          cartCubit: cartCubit,
        ),
      ],
    );
  }

  // ignore: unused_element
  Container _searchBox() {
    return Container(
      width: double.infinity,
      child: TextField(
        focusNode: searchFocusNode,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1.5, color: SScolor.primaryColor),
          ),
          hintText: "Search...",
          suffixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20,
          ),
        ),
      ),
    );
  }

  ///receive form (show cart items with payment buttons) right part of the home sreen
  Widget _receiveForm({
    required Size screenSize,
    required EditSaleCartCubit cartCubit,
  }) {
    return BlocBuilder<EditSaleCartCubit, EditSaleCartState>(
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
                        Icon(IconlyLight.bookmark),
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
                      ],
                    ),
                  ),
                  SizedBox(height: 5),

                  ///cart item list widget
                  _cartItemListWidget(
                    screenSize: screenSize,
                    state: state,
                    context: context,
                  ),

                  ///total price,VAT and grand total widgt
                  _totalAndVATWidget(cartCubit: cartCubit),
                  SizedBox(height: 25),

                  ///payment buttons widget
                  _paymentButtonsWidget(),

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
                          showEditCheckoutDialog(
                              cartCubit, context, screenSize);
                        },
                        child: Text("${tr(LocaleKeys.lblEditOrder)}"),
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

  void showEditCheckoutDialog(
    EditSaleCartCubit cartCubit,
    BuildContext context,
    Size screenSize,
  ) {
    if (cartCubit.state.items.length > 0) {
      if (cashPayment == false && PromptPayment == false) {
        showCustomSnackbar(
          message: "Choose Payment Type",
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
            return EditSaleCheckoutDialog(
              dine_in_or_percel: widget.saleHistory.dine_in_or_percel,
              date: widget.saleHistory.created_at.toString(),
              orderNo: widget.orderNo,
              width: screenSize.width / 3,
              PromptPayment: PromptPayment,
              cashPayment: cashPayment,
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

  ///payment buttons widget
  Container _paymentButtonsWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 11),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  cashPayment = true;
                  PromptPayment =false;
                  // PromptPayment = false;
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
                  PromptPayment = true;
                  // cashPayment = false;
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

  ///cart item list widget
  Container _cartItemListWidget({
    required Size screenSize,
    required EditSaleCartState state,
    required BuildContext context,
  }) {
    return Container(
      height: screenSize.height * 0.48,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: MyPadding.normal),
              child: Text("Table no. : ${state.tableNumber}"),
            ),
            ...state.items
                .map(
                  (e) => cartItemWidget(
                    ontapDisable: false,
                    cartItem: e,
                    screenSize: screenSize,
                    context: context,
                    onEdit: () {
                      ///show cart item quantity control
                      if (e.is_gram) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CartItemWeightControlDialog(
                              screenSizeWidth: screenSize.width,
                              weightGram: e.qty,
                              cartItem: e,
                              isEditState: true,
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CartItemQtyDialogControl(
                              screenSizeWidth: screenSize.width,
                              quantity: e.qty,
                              cartItem: e,
                              isEditState: true,
                            );
                          },
                        );
                      }
                    },
                    onDelete: () {
                      context.read<EditSaleCartCubit>().removeFromCart(item: e);
                    },
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  ///widget that shows total and VAT
  Widget _totalAndVATWidget({required EditSaleCartCubit cartCubit}) {
    // num grandTotal =
    //     get7percentage(cartCubit.getTotalAmount()) + cartCubit.getTotalAmount();
    return FutureBuilder(
      future: calculateDiscount(context, cartCubit.getTotalAmount()),
      builder:(context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: loadingWidget(),
          );
        }
    
        int discountedTotal = snapshot.data!;
        int vatAmount = get7percentage(discountedTotal);
        int grandTotal = vatAmount + discountedTotal;
        print("d mr pyit dr lrr :${discountedTotal}");
        print("vat total:${vatAmount}");
        print("grandTotal:${grandTotal}");
        return Container(
          padding: EdgeInsets.symmetric(horizontal: MyPadding.normal),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 15, top: 5),
                child: Divider(
                  height: 1,
                  thickness: 0.5,
                  color: SScolor.greyColor,
                ),
              ),

              SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${tr(LocaleKeys.lblSubtotal)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.normal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${NumberFormat('#,##0').format(cartCubit.getTotalAmount())} THB",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: FontSize.normal),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${tr(LocaleKeys.lbldiscount)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.normal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<DiscountCubit, DiscountState>(
                      builder: (context, state) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${state.numbers} %",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // ///VAT
              // SizedBox(height: 5),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: Text(
              //         "${tr(LocaleKeys.lblVAT)}",
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold, fontSize: FontSize.normal),
              //       ),
              //     ),
              //     Expanded(
              //       child: Align(
              //         alignment: Alignment.centerRight,
              //         child: Text(
              //           "${formatNumber(get7percentage(cartCubit.getTotalAmount()))}(7%)",
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold, fontSize: FontSize.normal),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              ///grand total
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${tr(LocaleKeys.lblGrandTotal)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.normal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${NumberFormat('#,##0').format(grandTotal)} THB",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: FontSize.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } ,
    );
  }

  ///widgets that show products and menu items
  Widget _productsAndCategoriesForm({
    required Size screenSize,
    required EditSaleCartCubit cartCubit,
  }) {
    double maxWidth = screenSize.width * 0.71;
    return Container(
      width: maxWidth,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(left: MyPadding.normal, top: 6),
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoadingState) {
            return loadingWidget();
          } else if (state is CategoriesLoadedState) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Wrap(
                runSpacing: MyPadding.normal,
                spacing: MyPadding.normal,
                alignment: WrapAlignment.start,
                children: [
                  ///categories box row
                  ...state.categoriesList
                      .map(
                        (e) => _categoryBoxWidget(
                          maxWidth: maxWidth,
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
      ),
    );
  }

  ///category box widget
  Widget _categoryBoxWidget({
    required double maxWidth,
    required CategoryModel category,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: Container(
        width: (maxWidth / 3) - (MyPadding.normal),
        height: 400,
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
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoadingState) {
                    return loadingWidget();
                  } else if (state is ProductsLoadedState) {
                    try {
                      ProductModel? defaultProduct = state.products
                          .where((element) => element.is_default == true)
                          .first;

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

                    List<ProductModel> productList = state.products
                        .where((element) =>
                            element.category == category.name &&
                            element.is_default == false)
                        .toList();

                    return _productListScrollBar(
                        productList: productList,
                        context: context,
                        tableController: tableController,
                        scrollController: scrollController,
                        isEditState: true);
                  } else {
                    return Text("hello world");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///product list widget (display with scrollbar)
  Widget _productListScrollBar({
    required List<ProductModel> productList,
    required ScrollController scrollController,
    required TextEditingController tableController,
    required BuildContext context,
    required bool isEditState,
  }) {
    return Container(
      padding: EdgeInsets.only(right: 0, bottom: 10),
      child: Scrollbar(
        thickness: 4,
        controller: scrollController,
        radius: Radius.circular(25),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: productList
                .map(
                  (e) => productRowWidget(
                    index: productList.indexOf(e),
                    product: e,
                    context: context,
                    tableController: tableController,
                    isEditState: isEditState,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
