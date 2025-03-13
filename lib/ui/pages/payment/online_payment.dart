import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/blocs/discount_cubit/discount_cubit.dart';
import 'package:golden_thailand/blocs/pending_order_cubit/pending_order_cubit.dart';
import 'package:golden_thailand/blocs/sale_process_cubit/sale_process_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/order_pending_model.dart';
import 'package:golden_thailand/data/models/request_models/sale_request_model.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
import 'package:golden_thailand/ui/pages/order/checkout_form.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/cart_item_widget.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/internetCheckWidget.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/size_const.dart';

class OnlinePaymentScreen extends StatefulWidget {
  const OnlinePaymentScreen({
    super.key,
    required this.subTotal,
    required this.VAT,
    required this.grandTotal,
    required this.order,
    required this.discount,
  });

  final int subTotal;
  final int grandTotal;
  final int VAT;
  final int discount;
  final PendingOrder order;

  @override
  State<OnlinePaymentScreen> createState() => _OnlinePaymentScreenState();
}

class _OnlinePaymentScreenState extends State<OnlinePaymentScreen> {
  TextEditingController cashController = TextEditingController();

  int PromptAmount = 0;
  int grandTotal = 0;
  int VATAmount = 0;
  int discountAmount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    CartCubit cartCubit = BlocProvider.of<CartCubit>(context);

    grandTotal = widget.subTotal + widget.VAT;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 160,
        leading: appBarLeading(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Prompt Pay"),
      ),
      body: InternetCheckWidget(
        child: _cashPaymentForm(
          screenSize,
          cartCubit,
        ),
        onRefresh: () {},
      ),
    );
  }

  ///cash payment form widget
  Widget _cashPaymentForm(Size screenSize, CartCubit cartCubit) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// left side of the screen
          _saleSummaryForm(screenSize, cartCubit),

          ///right side
          _paymentMethodAndEditButton(screenSize),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  ///payment method and edit button widget
  Container _paymentMethodAndEditButton(Size screenSize) {
    return Container(
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
              SizedBox(height: 25),
              Container(
                width: 200,
                height: 50,
                margin: EdgeInsets.only(right: 15),
                child: custamizableElevated(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
    );
  }

  ///sale summary form
  Widget _saleSummaryForm(Size screenSize, CartCubit cartCubit) {
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
          child: BlocBuilder<CartCubit, CartState>(
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
                  _costWidget(cartCubit: cartCubit),

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
    required CartCubit cartCubit,
  }) {
    return BlocBuilder<SaleProcessCubit, SaleProcessState>(
      builder: (context, state) {
        if (state is SaleProcessLoadingState) {
          return loadingWidget();
        } else {
          return custamizableElevated(
            enabled: true,
            width: double.infinity,
            elevation: 0,
            height: 70,
            child: Text("Check Out"),
            onPressed: () async {
              ///*****///

              _proceedSaleProcesss(context);
            },
          );
        }
      },
    );
  }

  ///PROCEED SALE PROCESS
  Future<void> _proceedSaleProcesss(BuildContext context) async {
    int? discount = int.parse(await context.read<DiscountCubit>().getValue());
    bool status = await context.read<SaleProcessCubit>().makeSale(
      saleRequest: {
        "table_id": widget.order.tableId,
        "payment_type_id": null,
        "remark_id": widget.order.remark,
        "order_no": widget.order.orderUniqueId,
        "dine_in_or_percel": widget.order.dine_in_or_percel,
        "sub_total": widget.subTotal,
        "VAT": widget.VAT,
        "discount": discount,
        "grand_total": widget.grandTotal,
        "paid_cash": 0,
        "paid_online": grandTotal,
        "refund": 0,
        "products": [
          ...widget.order.items.map((e) => e.toJson()).toList(),
        ]
      },
    );
    if (status) {
      context.read<CartCubit>().clearOrderr();
      context
          .read<PendingOrderCubit>()
          .removePendingOrder(pendingOrder: widget.order);
      redirectTo(
        context: context,
        form: CheckOutForm(
          cartItems: widget.order.items,
          isBuffet: checkBuffet(list: widget.order.items),
          saleData: SaleModel(
            table_number: widget.order.tableNumber,
            order_no: widget.order.orderUniqueId,
            dine_in_or_percel: widget.order.dine_in_or_percel,
            sub_total: widget.subTotal,
            VAT: widget.VAT,
            grand_total: widget.grandTotal,
            paid_online: widget.grandTotal,
            paid_cash: 0,
            refund: 0,
            products: [],
            remark: widget.order.remark,
          ),
          dateTime: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          paymentType: "prompt",
          isEditSale: false,
        ),
      );
    }
  }

  ///total cost widget
  Widget _costWidget({required CartCubit cartCubit}) {
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
          ///cost or discount
          BlocBuilder<DiscountCubit, DiscountState>(
            builder: (context, state) {
              return _amountRowWidget(amount: state.numbers, title: "Discount",isChange: true);
            },
          ),
          SizedBox(height: 5),
          _amountRowWidget(amount: grandTotal, title: "GrandTotal"),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  ///total amount widget(row)
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
}
