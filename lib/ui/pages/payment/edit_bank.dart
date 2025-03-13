// ignore_for_file: dead_code
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/discount_cubit/discount_cubit.dart';
import 'package:golden_thailand/blocs/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:golden_thailand/blocs/edit_sale_cart_cubit/edit_sale_cart_state.dart';
import 'package:golden_thailand/blocs/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:golden_thailand/blocs/sale_process_cubit/sale_process_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/request_models/sale_request_model.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
import 'package:golden_thailand/ui/pages/order/checkout_form.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/cart_item_widget.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/internet_error_widget.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/size_const.dart';

class EditOnlinePaymentScreen extends StatefulWidget {
  const EditOnlinePaymentScreen({
    super.key,
    required this.subTotal,
    required this.VAT,
    required this.dine_in_or_percel,
    required this.table_number,
    this.remark_id,
    required this.remark,
    required this.orderNo,
    required this.date,
  });

  final int subTotal;
  final int VAT;
  final int dine_in_or_percel;
  final int table_number;
  final int? remark_id;
  final String remark;
  final String orderNo;
  final String date;

  @override
  State<EditOnlinePaymentScreen> createState() =>
      _EditOnlinePaymentScreenState();
}

class _EditOnlinePaymentScreenState extends State<EditOnlinePaymentScreen> {
  bool showButtons = true;

  TextEditingController cashController = TextEditingController();

  int PromptAmount = 0;
  int grandTotal = 0;
  int VATAmount = 0;
  bool alreadyPrint = false;

  @override
  void initState() {
    super.initState();
  }

  ScrollController categoryScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    EditSaleCartCubit cartCubit = BlocProvider.of<EditSaleCartCubit>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 160,
        leading: appBarLeading(onTap: () {
          Navigator.pop(context);
        }),
        title: Text("Prompt Pay"),
      ),
      body: BlocConsumer<InternetConnectionBloc, InternetConnectionState>(
        builder: (context, state) {
          if (state is InternetConnectedState) {
            return Container(
              padding: EdgeInsets.only(top: 15),
              child: _cashPaymentForm(
                screenSize,
                cartCubit,
              ),
            );
          } else if (state is InternetDisconnectedState) {
            return Center(child: InternetErrorWidget());
          } else if (state is InternetLoadingState) {
            return loadingWidget();
          } else {
            return Container();
          }
        },
        listener: (BuildContext context, InternetConnectionState state) {},
      ),
    );
  }

  ///cash payment form widget
  Widget _cashPaymentForm(
      Size screenSize, EditSaleCartCubit EditSaleCartCubit) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// left side of the screen
          _saleSummaryForm(screenSize, EditSaleCartCubit),

          ///right side
          Container(
            padding: EdgeInsets.only(
              top: MyPadding.big,
              right: MyPadding.big,
              left: MyPadding.big,
              bottom: MyPadding.big,
            ),
            margin: EdgeInsets.only(bottom: 15, right: MyPadding.normal),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
            height: 180,
            width: screenSize.width * 0.5,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${tr(LocaleKeys.lblPaymentType)} :",
                          style: TextStyle(
                            fontSize: FontSize.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Prompt",
                          style: TextStyle(
                            fontSize: FontSize.normal,
                            fontWeight: FontWeight.bold,
                            color: SScolor.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 200,
                      height: 50,
                      margin: EdgeInsets.only(right: 15),
                      child: custamizableElevated(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 7),
                            Text("Order Update"),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  ///sale summary form
  Widget _saleSummaryForm(Size screenSize, EditSaleCartCubit cartCubit) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: MyPadding.normal,
          bottom: MyPadding.normal,
          right: MyPadding.normal,
        ),
        child: Container(
          padding: EdgeInsets.all(MyPadding.normal),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: BlocBuilder<EditSaleCartCubit, EditSaleCartState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "${tr(LocaleKeys.lblSummary)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: SScolor.primaryColor,
                        fontSize: FontSize.semiBig,
                      ),
                    ),
                  ),

                  Container(
                    height: screenSize.height * 0.45,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: state.items
                            .map(
                              (e) => cartItemWidget(
                                ontapDisable: true,
                                cartItem: e,
                                screenSize: screenSize,
                                context: context,
                                onDelete: () {},
                                onEdit: () {},
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  ///total and VAT widget
                  _cashAndCost(cartCubit: cartCubit),

                  Spacer(),

                  SizedBox(height: 10),
                  _checkoutButton(
                    screenSize: screenSize,
                    cartItems: state.items,
                    cartCubit: cartCubit,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  ///checkout button
  BlocBuilder _checkoutButton({
    required Size screenSize,
    required List<CartItem> cartItems,
    required EditSaleCartCubit cartCubit,
  }) {
    return BlocBuilder<SaleProcessCubit, SaleProcessState>(
      builder: (context, state) {
        if (state is SaleProcessLoadingState) {
          return loadingWidget();
        } else {
          return custamizableElevated(
            enabled: isCheckoutEnabled(),
            width: double.infinity,
            elevation: 0,
            height: 70,
            child: Text("${tr(LocaleKeys.lblCheckedout)}"),
            onPressed: () async {
              int discount = await calculateDiscount(context, widget.subTotal);
              grandTotal = discount;
              VATAmount = widget.VAT;

              PromptAmount = grandTotal;

              if (true) {
                ///check conditions that if the curret sale process items is from pending orders or not

                SaleModel saleModel = SaleModel(
                  remark: widget.remark,
                  dine_in_or_percel: widget.dine_in_or_percel,
                  grand_total: grandTotal,
                  order_no: "${widget.orderNo}",
                  paid_cash: 0,
                  products: context
                      .read<EditSaleCartCubit>()
                      .state
                      .items
                      .map(
                        (e) => Product(
                          product_id: e.id,
                          qty: e.qty,
                          price: e.price,
                          total_price: e.totalPrice,
                        ),
                      )
                      .toList(),
                  table_number: widget.table_number,
                  refund: 0,
                  sub_total: widget.subTotal,
                  VAT: VATAmount,
                  paid_online: PromptAmount,
                );
                await context
                    .read<SaleProcessCubit>()
                    .updateSale(saleRequest: saleModel, orderId: widget.orderNo)
                    .then(
                  (value) {
                    if (value) {
                      redirectTo(
                        context: context,
                        form: CheckOutForm(
                          isBuffet: checkBuffet(
                            list: context.read<EditSaleCartCubit>().state.items,
                          ),
                          saleData: saleModel,
                          cartItems: cartItems,
                          paymentType: "Prompt",
                          dateTime: widget.date,
                          isEditSale: true,
                        ),
                        replacement: true,
                      );
                    } else {}
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  Widget _cashAndCost({required EditSaleCartCubit cartCubit}) {
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
          BlocBuilder<DiscountCubit,DiscountState>(
              builder: (context,state){
                return _amountRowWidget(
                  isChange: true,
                  amount: state.numbers,
                  title: "${tr(LocaleKeys.lbldiscount)}",
                );
              }
          ),
          SizedBox(height: 5),
          FutureBuilder(
              future: calculateDiscount(context, widget.subTotal),
              builder: (context,snapshot) {
                if(!snapshot.hasData){
                  return Center(
                    child: loadingWidget(),
                  );
                }
                int? discount = snapshot.data;
                grandTotal = discount ?? 0;
                return _amountRowWidget(
                  amount: grandTotal,
                  title: "GrandTotal",
                );
              }
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Row _amountRowWidget({
    required String title,
    required num amount,
    bool isChange = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "${title}",
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
              isChange
                  ? "${formatNumber(amount)} %"
                  : "${formatNumber(amount)} THB",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: FontSize.normal,
                color:  Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool isCheckoutEnabled() {
    if (true) {
      return true;
    } else {
      return false;
    }
  }
}
