import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/sale_process_cubit/sale_process_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/data/models/request_models/sale_request_model.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/payment_button.dart';

class PaymentEditDialog extends StatefulWidget {
  const PaymentEditDialog({
    super.key,
    required this.paymentType,
    required this.saleModel,
  });
  final String paymentType;
  final SaleModel saleModel;

  @override
  State<PaymentEditDialog> createState() => _PaymentEditDialogState();
}

class _PaymentEditDialogState extends State<PaymentEditDialog> {
  bool PromptPayment = false;
  bool cashPayment = false;
  String paymentType = "";

  @override
  void initState() {
    checPromptmentType();
    super.initState();
  }

  int getCashAmount() {
    if (cashPayment == true && PromptPayment == false) {
      return widget.saleModel.grand_total;
    } else {
      return 0;
    }
  }

  int getPromptAmount() {
    if (cashPayment == false && PromptPayment == true) {
      return widget.saleModel.grand_total;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.8,
        padding: EdgeInsets.symmetric(
            horizontal: MyPadding.big, vertical: MyPadding.normal),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.clear),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "${tr(LocaleKeys.lblEditPaymentType)}",
              style: TextStyle(
                fontSize: FontSize.normal,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
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
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        PromptPayment = !PromptPayment;
                        cashPayment = false;
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                custamizableElevated(
                  child: Text("${tr(LocaleKeys.lblConfirm)}"),
                  onPressed: () async {
                    if (cashPayment && PromptPayment) {
                    } else {
                      await context
                          .read<SaleProcessCubit>()
                          .updateSale(
                            orderId: widget.saleModel.order_no,
                            saleRequest: widget.saleModel.copyWith(
                              paid_cash: getCashAmount(),
                              paid_online: getPromptAmount(),
                            ),
                          )
                          .then(
                        (value) {
                          Navigator.pop(
                            context,
                            getCashAmount() > getPromptAmount() ? "cash" : "Prompt",
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  ///to check the payment type
  void checPromptmentType() {
    if (widget.paymentType == "cash") {
      cashPayment = true;
    }

    if (widget.paymentType == "Prompt") {
      PromptPayment = true;
    }
    if (widget.paymentType == "Cash / Prompt") {
      PromptPayment = false;
      cashPayment = false;
    }

    setState(() {});
  }
}
