import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/discount_cubit/discount_cubit.dart';
import 'package:golden_thailand/blocs/payment_api/payment_api_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:golden_thailand/blocs/sales_history_cubit/sales_history_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/blocs/sale_process_cubit/sale_process_cubit.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/request_models/sale_request_model.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
import 'package:golden_thailand/ui/pages/home.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/ui/widgets/payment_edit_dialog.dart';
import 'package:golden_thailand/ui/widgets/voucher_widget.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

// ignore: must_be_immutable
class CheckOutForm extends StatefulWidget {
  CheckOutForm({
    super.key,
    required this.cartItems,
    required this.saleData,
    required this.dateTime,
    required this.paymentType,
    required this.isEditSale,
    this.refund = 0,
    required this.isBuffet,
  });

  final List<CartItem> cartItems;
  final SaleModel saleData;
  final String dateTime;
  String paymentType;
  int refund;
  bool isBuffet;

  ///check if it's edit state
  final bool isEditSale;

  @override
  State<CheckOutForm> createState() => _CheckOutFormState();
}

class _CheckOutFormState extends State<CheckOutForm> {
  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  @override
  void initState() {
    super.initState();

    context.read<CartCubit>().clearOrderr();

    ///initialize sunmi printer
    _initializePrinter();
  }

  void _initializePrinter() async {
    await _bindingPrinter().then(
      (bool? isBind) async {
        SunmiPrinter.paperSize().then((int size) {});

        SunmiPrinter.printerVersion().then((String version) {});

        SunmiPrinter.serialNumber().then((String serial) {});

        if (widget.paymentType == "cash") {
          print("opening drawer");
          await SunmiPrinter.openDrawer();
        } else {
          print("not opening drawer");
        }
      },
    );

    await context.read<PaymentApiCubit>().getData().then(
      (e) {
        if (e != null) {
          Uint8List bytes = base64Decode(e.image_path.toString());

          _printVoucher(image: bytes);
        } else {
          _printVoucher();
        }
      },
    );
  }

  /// print receipt
  Future _printVoucher({Uint8List? image}) async {
    //String discount = await context.read<DiscountCubit>().getValue();
    int? discount = int.parse(await context.read<DiscountCubit>().getValue());

    int? discountAmount =
        await calculateDiscount(context, widget.saleData.sub_total);
    print(
        "${widget.isBuffet} pr lr:${DateFormat('hh:mm a', 'en_US').format(DateTime.now().add(Duration(hours: 2)))} - ${DateFormat('hh:mm a', 'en_US').format(DateTime.now().add(Duration(hours: 4)))} (2 hrs)");
    print("printing:${widget.saleData.VAT}");
    await printReceipt(
        isBuffet: widget.isBuffet,
        paymentType: widget.paymentType,
        tableNumber: widget.saleData.table_number,
        remark: "${widget.saleData.remark}",
        cashAmount: widget.saleData.paid_cash,
        PromptAmount: widget.saleData.paid_online ?? 0,
        date: "${DateFormat('E d, MMM yyyy', 'en_US').format(DateTime.now())}",
        discount: discount,
        discountAmount: discountAmount,
        grandTotal: widget.saleData.grand_total,
        subTotal: widget.saleData.sub_total,
        orderNumber: widget.saleData.order_no,
        products: widget.cartItems,
        VATAmount: (widget.saleData.grand_total - widget.saleData.sub_total),
        dine_in_or_percel: widget.saleData.dine_in_or_percel,
        image: image,
        refund: widget.saleData.refund,
        time: widget.isBuffet
            ? "${DateFormat('hh:mm a', 'en_US').format(DateTime.now())} - ${DateFormat('hh:mm a', 'en_US').format(DateTime.now().add(Duration(hours: 2)))} (2 hrs)"
            : "${DateFormat('hh:mm a', 'en_US').format(DateTime.now())} ");
    print("printing done!!");
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    CartCubit cartCubit = BlocProvider.of<CartCubit>(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///left side
              _saleSuccessForm(context, screenSize),

              ///right side
              _voucherWidget(
                screenSize: screenSize,
                saleData: widget.saleData,
                cartCubit: cartCubit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _saleSuccessForm(BuildContext context, Size screenSize) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      padding: EdgeInsets.all(MyPadding.big + 20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // "test",
                "${tr(LocaleKeys.lblSuccessfullySale)}",
                style: TextStyle(
                  fontSize: FontSize.normal + 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 25),
            ],
          ),
          SizedBox(height: 25),
          Container(
            height: 250,
            child: Image.asset(
              "assets/images/cashier.png",
            ),
          ),
          SizedBox(height: 65),
          _processButtons(screenSize, context),
        ],
      ),
    );
  }

  ///process bu8ttons
  Widget _processButtons(Size screenSize, BuildContext context) {
    return Column(
      children: [
        BlocBuilder<PaymentApiCubit, PaymentApiState>(
          builder: (context, state) {
            return Container(
              width: (screenSize.width / 2.8),
              height: 60,
              child: custamizableElevated(
                child: Text("${tr(LocaleKeys.lblPrintReceived)}"),
                onPressed: () async {
                  if (state is PaymentApiLoaded) {
                    String text = "";
                        Uint8List.fromList(utf8.encode(text));
                    Uint8List noWrapCommand =
                        Uint8List.fromList([0x1B, 0x33, 0x00]);
                    await SunmiPrinter.printRawData(noWrapCommand);
                  //  await SunmiPrinter.printRawData(encodedText);

                    // Uint8List noWrapCommand = Uint8List.fromList([0x1B, 0x33, 0x00]);
                    // SunmiPrinter.printRawData(noWrapCommand);
                    //64 string into bytes
                    Uint8List bytes =
                        base64Decode(state.paymentModel.image_path.toString());

                    _printVoucher(image: bytes);
                  } else {
                    _printVoucher();
                  }
                },
              ),
            );
          },
        ),
        Container(
          width: (screenSize.width / 2.8),
          height: 60,
          child: customizableOTButton(
            child: Text("${tr(LocaleKeys.lblEditPaymentType)}"),
            onPressed: () async {
              String? result = await showDialog(
                context: context,
                builder: (context) {
                  return PaymentEditDialog(
                    paymentType: widget.paymentType,
                    saleModel: widget.saleData,
                  );
                },
              );

              if (result != null || result != "") {
                widget.paymentType = result ?? "";

                if (result == "cash") {
                  widget.saleData.paid_cash = widget.saleData.grand_total;
                  widget.saleData.paid_online = 0;
                } else if (result == "Prompt") {
                  widget.saleData.paid_online = widget.saleData.grand_total;
                  widget.saleData.paid_cash = 0;
                }
              }
            },
          ),
        ),
        Container(
          width: (screenSize.width / 2.8),
          height: 60,
          child: widget.isEditSale
              ? customizableOTButton(
                  child: Text("${tr(LocaleKeys.lblNewAdd)}"),
                  onPressed: () {
                    Navigator.pop(context);
                    context
                        .read<SalesHistoryCubit>()
                        .getHistoryByPagination(page: 1);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              : customizableOTButton(
                  child: Text("${tr(LocaleKeys.lblNewOrder)}"),
                  onPressed: () {
                    pushAndRemoveUntil(
                      form: HomeScreen(),
                      context: context,
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// voucher widget to show the sale voucher
  Widget _voucherWidget(
      {required Size screenSize,
      required SaleModel saleData,
      required CartCubit cartCubit,
      String? discount}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: MyPadding.big + 20,
          right: MyPadding.big + 20,
          top: MyPadding.normal,
        ),
        child: BlocBuilder<SaleProcessCubit, SaleProcessState>(
          builder: (context, state) {
            if (state is SaleProcessSuccessState) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    VoucherWidget(
                      showEditButton: true,
                      paymentType: widget.paymentType,
                      table_number: saleData.table_number,
                      remark: widget.saleData.remark.toString(),
                      paidAmount: saleData.paid_cash != 0
                          ? saleData.paid_cash
                          : saleData.paid_online ?? 0,
                      isCashPayment: saleData.paid_cash > 0 ? true : false,
                      subTotal: saleData.sub_total,
                      cartItems: widget.cartItems,
                      date: widget.isBuffet
                          ? "${DateFormat('hh:mm a', 'en_US').format(DateTime.now())} - ${DateFormat('hh:mm a', 'en_US').format(DateTime.now().add(Duration(hours: 2)))}"
                          : "${DateFormat('E d, MMM yyyy', 'en_US').format(DateTime.now())} \n (${DateFormat('hh:mm a', 'en_US').format(DateTime.now())})",
                      grandTotal: saleData.grand_total,
                      orderNumber: saleData.order_no,
                      dine_in_or_percel: saleData.dine_in_or_percel,
                      refund: widget.refund,
                      discount: discount,
                      //   discountAmount: state.discountAmount,
                      isBuffet: widget.isBuffet,
                    ),
                  ],
                ),
              );
            } else if (state is SaleProcessLoadingState) {
              return loadingWidget();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  ///to remove the .0 in the numbers
  String removeZero(String number) {
    String numStr = number;
    if (numStr.endsWith('.0')) {
      numStr = numStr.substring(0, numStr.length - 2);
    }
    return numStr;
  }

  int? getPaidAmount() {
    if (widget.paymentType == "cash") {
      return widget.saleData.paid_cash;
    } else if (widget.paymentType == "Prompt") {
      return widget.saleData.paid_online;
    } else {
      return widget.saleData.paid_online! + widget.saleData.paid_cash;
    }
  }
}
