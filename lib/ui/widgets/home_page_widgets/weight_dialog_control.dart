// ignore: must_be_immutable
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/blocs/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/custom_dialog.dart';

// ignore: must_be_immutable
class CartItemWeightControlDialog extends StatefulWidget {
  CartItemWeightControlDialog(
      {super.key,
      required this.screenSizeWidth,
      required this.weightGram,
      required this.cartItem,
      required this.isEditState});
  final double screenSizeWidth;
  int weightGram;
  final CartItem cartItem;
  final bool isEditState;

  @override
  State<CartItemWeightControlDialog> createState() =>
      _CartItemWeightControlDialogState();
}

class _CartItemWeightControlDialogState
    extends State<CartItemWeightControlDialog> {
  TextEditingController gram = TextEditingController();

  @override
  void initState() {
    gram.text = "${widget.weightGram}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${widget.cartItem.name}",
            style: TextStyle(
              fontSize: FontSize.semiBig,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 15),
          _weightControl(),
          SizedBox(height: 20),
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
                elevation: 0,
                child: Text("${tr(LocaleKeys.lblUpdate)}"),
                onPressed: () {
                  if (widget.isEditState) {
                    context.read<EditSaleCartCubit>().addToCartByGram(
                          item: widget.cartItem,
                          gram: int.parse(gram.text),
                        );
                  } else {
                    context.read<CartCubit>().addToCartByGram(
                          item: widget.cartItem,
                          gram: int.parse(gram.text),
                        );
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  ///weight control widget
  Center _weightControl() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                num value = num.parse(gram.text);
                if (value > 0) {
                  value -= 100;
                  gram.text = value.toString();
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.remove,
                color: Colors.black,
                weight: 10,
              ),
            ),
          ),
          SizedBox(width: 30),
          Container(
            width: 100,
            child: TextField(
              controller: gram,
              style: TextStyle(fontSize: FontSize.normal),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
          ),
          Text("/g"),
          SizedBox(width: 30),
          InkWell(
            onTap: () {
              setState(() {
                num value = num.parse(gram.text);
                value += 100;
                gram.text = value.toString();
              });
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
