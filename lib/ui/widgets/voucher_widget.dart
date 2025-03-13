// ignore_for_file: unused_element
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/discount_cubit/discount_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';

class VoucherWidget extends StatelessWidget {
  const VoucherWidget({
    super.key,
    required this.paidAmount,
    required this.subTotal,
    required this.grandTotal,
    required this.date,
    required this.orderNumber,
    required this.cartItems,
    required this.dine_in_or_percel,
    required this.remark,
    required this.table_number,
    required this.showEditButton,
    required this.paymentType,
    this.refund = 0,
    required this.discount,
    required this.isBuffet,
    required this.isCashPayment,
  });

  final int paidAmount;
  final int subTotal;
  final int grandTotal;
  final String date;
  final String orderNumber;
  final List<CartItem> cartItems;
  final int dine_in_or_percel;
  final String remark;
  final int table_number;
  final bool showEditButton;
  final String paymentType;
  final int refund;
  final String? discount;
  final bool isBuffet;
  final bool isCashPayment;

  @override
  Widget build(BuildContext context) {
    //num commercialVAT = grandTotal - subTotal;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${tr(LocaleKeys.lblOrderSummary)}",
                style: TextStyle(
                  fontSize: FontSize.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 9),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  "${tr(LocaleKeys.lblTableId)}",
                  style: TextStyle(fontSize: FontSize.normal - 2.5),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  ":",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: FontSize.normal - 2.5),
                ),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${table_number}",
                    style: TextStyle(fontSize: FontSize.normal - 2.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  "${tr(LocaleKeys.lblslitId)}",
                  style: TextStyle(fontSize: FontSize.normal - 2.5),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  ":",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: FontSize.normal - 2.5),
                ),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${orderNumber}",
                    style: TextStyle(fontSize: FontSize.normal - 2.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  "${tr(LocaleKeys.lblDate)}",
                  style: TextStyle(
                    fontSize: FontSize.normal - 2.5,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  ":",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: FontSize.normal - 2.5,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "${date}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: FontSize.normal - 2.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dine_in_or_percel == 1 ? "Dine In" : "Take Away"),
              isBuffet ? Text(" (Buffet)") : Container(),
              Spacer(),
              Text(
                "${tr(LocaleKeys.lblRemark)} : ${remark} ",
                textAlign: TextAlign.right,
              ),
            ],
          ),
          SizedBox(height: 10),
          _productsTitleRow(),
          SizedBox(height: 15),
          Column(
            children: cartItems.map(
              (e) {
                return _voucherItemWidget(e, context);
              },
            ).toList(),
          ),
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Divider(
              height: 0,
              thickness: 1,
            ),
          ),
          Column(
            children: [
              ///subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      "${tr(LocaleKeys.lblTotalAmount)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        ":",
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "${NumberFormat('#,##0').format(subTotal)} THB",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              // Discount
              SizedBox(height: 10),
              BlocBuilder<DiscountCubit, DiscountState>(
                  builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        "${tr(LocaleKeys.lbldiscount)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text(
                          ":",
                          textAlign: TextAlign.center,
                        )),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "${state.numbers}%",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                );
              }),

              ///commercial VAT
              SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       flex: 4,
              //       child: Text(
              //         "${tr(LocaleKeys.lblVAT)}",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //         flex: 1,
              //         child: Text(
              //           ":",
              //           textAlign: TextAlign.center,
              //         )),
              //     Expanded(
              //       flex: 4,
              //       child: Text(
              //         "${NumberFormat('#,##0').format(commercialVAT)} THB",
              //         textAlign: TextAlign.right,
              //         style: TextStyle(
              //           fontWeight: FontWeight.normal,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              ///grand total
              // SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      "${tr(LocaleKeys.lblGrandTotal)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        ":",
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "${NumberFormat('#,##0').format(grandTotal)} THB",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),

              ///cash
              Container(
                margin: EdgeInsets.only(
                  top: MyPadding.normal + 10,
                  bottom: MyPadding.normal + 10,
                ),
                child: Divider(
                  height: 0,
                  thickness: 1,
                ),
              ),
              SizedBox(height: 10),

              _discountRow(),
              SizedBox(height: 10),
              isCashPayment
                  ? Column(
                      children: [
                        _amountRow(
                          cashAmount: paidAmount,
                          title: "${tr(LocaleKeys.lblCash)}",
                        ),
                        SizedBox(height: 10),
                        _amountRow(
                          cashAmount: refund,
                          title: "${tr(LocaleKeys.lblRefundAmount)}",
                        ),
                      ],
                    )
                  : _amountRow(
                      cashAmount: paidAmount,
                      title: "${tr(LocaleKeys.lblPromptPay)}",
                    ),
              // SizedBox(height: 10),
              // Visibility(
              //   visible: refund != 0,
              //   child: _refundRow(refund: refund),
              // ),

              SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }

  Row _discountRow() {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Text(
            "${tr(LocaleKeys.lbldiscount)}",
            style: TextStyle(
              fontSize: FontSize.small,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(
              ":",
              textAlign: TextAlign.center,
            )),
        Expanded(
          flex: 4,
          child: Text(
            "0 THB",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: FontSize.small,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  // cash row
  Row _amountRow({required int cashAmount, required String title}) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Text(
            "${title}",
            style: TextStyle(
              fontSize: FontSize.small,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            ":",
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            "${formatNumber(cashAmount)} THB",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: FontSize.small,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Row _refundRow({required int refund}) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Text(
            "${tr(LocaleKeys.lblRefund)}",
            style: TextStyle(
              fontSize: FontSize.small,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(
              ":",
              textAlign: TextAlign.center,
            )),
        Expanded(
          flex: 4,
          child: Text(
            "${formatNumber(refund)} THB",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: FontSize.small,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Row _productsTitleRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "Name ",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Qty",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Price",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Amount",
            style: TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  ///voucher cart product item widget
  Container _voucherItemWidget(CartItem e, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "${e.name}",
              style: TextStyle(
                fontSize: FontSize.small,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              e.is_gram ? "${e.qty} gram" : "${e.qty}",
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${e.price}",
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${e.totalPrice}",
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  ///voucher cart product item widget
  Container _voucherItemWidgetOld(CartItem e) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "${e.name}",
                    style: TextStyle(
                      fontSize: FontSize.small,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  e.is_gram
                      ? "${e.qty} gram x  ${formatNumber(e.price)} THB "
                      : "${e.qty} qty x ${formatNumber(e.price)} THB",
                )
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Text("${NumberFormat('#,##0').format(e.totalPrice)} THB"))
        ],
      ),
    );
  }
}
