import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/blocs/pending_order_cubit/pending_order_cubit.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/order_pending_model.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';

class CheckoutDialog extends StatefulWidget {
  const CheckoutDialog({
    super.key,
    this.width,
  });

  final double? width;

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  bool isTakeAway = false;

  TextEditingController tableController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    remarkController.text = context.read<CartCubit>().state.remark;
    isTakeAway =
        context.read<CartCubit>().state.dine_in_or_percel == 0 ? true : false;
    tableController.text =
        context.read<CartCubit>().state.tableNumber.toString();

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: BlocConsumer<CartCubit, CartState>(
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
                    "${tr(LocaleKeys.lblCart)}",
                    style: TextStyle(
                      fontSize: FontSize.big - 5,
                      color: SScolor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
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
                          return "${tr(LocaleKeys.lblNeedTableId)}";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "${tr(LocaleKeys.lblEnterTableId)}",
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
                        Icon(
                          isTakeAway
                              ? Icons.radio_button_off
                              : Icons.radio_button_checked,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Dine In")
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
                        Text("Take Away")
                      ],
                    ),
                  ),

                  SizedBox(height: 25),
                  Text(
                    "${tr(LocaleKeys.lblRemark)}",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextField(
                    controller: remarkController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "${tr(LocaleKeys.lblEnterRemark)}",
                      hintStyle: TextStyle(fontSize: FontSize.normal - 3),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),

                  SizedBox(height: 20),

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
                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) {
                          return custamizableElevated(
                            child: Text("${tr(LocaleKeys.lblConfirm)}"),
                            onPressed: () async {
                              await _confirmOrderProcess(context, state);
                            },
                          );
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

  ///CONFIRM ORDDER PROCESS
  Future<void> _confirmOrderProcess(
    BuildContext context,
    CartState state,
  ) async {
    String orderUniqueId = "ORD-${generateRandomId(10)}";
    print("the id is : ${orderUniqueId}");
    await context.read<PendingOrderCubit>().addPendingOrder(
          pendingOrder: PendingOrder(
            items: state.items,
            time: DateTime.now(),
            tableId: state.tableId,
            tableNumber: int.parse(tableController.text),
            remark: remarkController.text,
            dine_in_or_percel: isTakeAway ? 0 : 1,
            orderUniqueId: orderUniqueId,
            menu_type_id: state.menu_type_id
          ),
        );

    await Future.delayed(Duration(milliseconds: 10));
    await context.read<CartCubit>().clearOrderr();
    Navigator.pop(context);
    showSnackBar(
        text:
            "Order Completed! You can checkout the orders in order management",
        context: context);
  }
}
