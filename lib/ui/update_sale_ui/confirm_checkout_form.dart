import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:golden_thailand/blocs/edit_sale_cart_cubit/edit_sale_cart_state.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/ui/pages/payment/edit_bank.dart';
import 'package:golden_thailand/ui/pages/payment/edit_cash.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';

class EditSaleCheckoutDialog extends StatefulWidget {
  const EditSaleCheckoutDialog({
    super.key,
    required this.PromptPayment,
    required this.cashPayment,
    this.width,
    required this.orderNo,
    required this.date,
    required this.dine_in_or_percel,
  });
  final bool PromptPayment;
  final bool cashPayment;
  final double? width;
  final String orderNo;
  final String date;
  final int dine_in_or_percel;
  @override
  State<EditSaleCheckoutDialog> createState() => _EditSaleCheckoutDialogState();
}

class _EditSaleCheckoutDialogState extends State<EditSaleCheckoutDialog> {
  bool isTakeAway = false;

  TextEditingController tableController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    isTakeAway = widget.dine_in_or_percel == 0 ? true : false;

    remarkController.text = context.read<EditSaleCartCubit>().state.remark;
    tableController.text =
        context.read<EditSaleCartCubit>().state.tableNumber.toString();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EditSaleCartCubit cartCubit = BlocProvider.of<EditSaleCartCubit>(context);

    var screenSize = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: BlocConsumer<EditSaleCartCubit, EditSaleCartState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Container(
              width:
                  widget.width == null ? screenSize.width / 3.8 : widget.width,
              padding: EdgeInsets.all(MyPadding.big),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${tr(LocaleKeys.lblCart)} ",
                    style: TextStyle(
                        fontSize: FontSize.big - 5,
                        color: SScolor.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "${tr(LocaleKeys.lblTableId)}",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: tableController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Table Number is required!";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Add table number",
                        hintStyle: TextStyle(fontSize: FontSize.normal - 3),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Dine In or Take Away",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isTakeAway = false;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(isTakeAway
                            ? Icons.radio_button_off
                            : Icons.radio_button_checked),
                        SizedBox(width: 10),
                        Text("${tr(LocaleKeys.lblDineIn)}")
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isTakeAway = true;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(isTakeAway
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off),
                        SizedBox(width: 10),
                        Text("${tr(LocaleKeys.lblTakeAway)}")
                      ],
                    ),
                  ),

                  SizedBox(height: 25),
                  Text(
                    "",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextField(
                    controller: remarkController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "${tr(LocaleKeys.lblRemark)}",
                      hintStyle: TextStyle(fontSize: FontSize.normal - 3),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),

                  SizedBox(height: 15),

                  ///buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      customizableOTButton(
                        elevation: 0,
                        child: Text("${tr(LocaleKeys.lblCancel)}"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 10),
                      custamizableElevated(
                        child: Text("${tr(LocaleKeys.lblUpdate)}"),
                        onPressed: () {
                          String remarkString = "${remarkController.text}";
                          context.read<EditSaleCartCubit>().addAdditionalData(
                                tableNumber: tableController.text == ""
                                    ? 0
                                    : int.parse(tableController.text),
                              );
                          if (_formKey.currentState!.validate()) {
                            if (widget.cashPayment && !widget.PromptPayment) {
                              redirectTo(
                                context: context,
                                //replacement: true,
                                ///^^^^^^^^^^ important ^^^^^^^^^^
                                form: EditCashScreen(
                                  date: widget.date,
                                  orderNo: widget.orderNo,
                                  remark: remarkString,
                                  table_number: int.parse(tableController.text),
                                  dine_in_or_percel: isTakeAway ? 0 : 1,
                                  subTotal: cartCubit.getTotalAmount(),
                                  VAT: get7percentage(
                                      cartCubit.getTotalAmount()),
                                ),
                              );
                            } else if (!widget.cashPayment &&
                                widget.PromptPayment) {
                              return redirectTo(
                                context: context,
                                //replacement: true,
                                form: EditOnlinePaymentScreen(
                                  date: widget.date,
                                  orderNo: widget.orderNo,
                                  remark: remarkString,
                                  table_number: int.parse(tableController.text),
                                  dine_in_or_percel: isTakeAway ? 0 : 1,
                                  subTotal: cartCubit.getTotalAmount(),
                                  VAT: get7percentage(
                                      cartCubit.getTotalAmount()),
                                ),
                              );
                            } else if (widget.cashPayment &&
                                widget.PromptPayment) {
                              // return redirectTo(
                              //   context: context,
                              //   form: EditPromptAndCashScreen(
                              //     date: widget.date,
                              //     orderNo: widget.orderNo,
                              //     remark: remarkString,
                              //     table_number: int.parse(tableController.text),
                              //     dine_in_or_percel: dine_in_or_percel ? 0 : 1,
                              //     subTotal: cartCubit.getTotalAmount(),
                              //     VAT: get7percentage(
                              //         cartCubit.getTotalAmount()),
                              //   ),
                              // );
                            }
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
