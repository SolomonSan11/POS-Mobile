import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/blocs/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
import 'package:golden_thailand/data/models/response_models/product_model.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/custom_dialog.dart';

class ProductWeightOrDetailControl extends StatefulWidget {
  const ProductWeightOrDetailControl({
    super.key,
    required this.produt,
    required this.isEditState,
  });

  final ProductModel produt;
  final bool isEditState;

  @override
  State<ProductWeightOrDetailControl> createState() =>
      _ProductWeightOrDetailControlState();
}

class _ProductWeightOrDetailControlState
    extends State<ProductWeightOrDetailControl> {
  TextEditingController gram = TextEditingController(text: "100");

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: widget.produt.is_gram
          ? gramControlWidget(context)
          : quantityControlWidget(),
    );
  }

  Column gramControlWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${widget.produt.name}",
          style: TextStyle(
            fontSize: FontSize.semiBig,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 15),

        _weightControl(),

        //_levelChoose(),
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
              child: Text("${tr(LocaleKeys.lblAdd)}"),
              onPressed: () {
                addToCartGram(context);

                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }

  ///add to cart gram
  void addToCartGram(BuildContext context) {
    if (widget.isEditState) {
      context.read<EditSaleCartCubit>().addToCartByGram(
            item: CartItem(
                is_buffet: widget.produt.is_buffet,
                is_gram: widget.produt.is_gram ?? false,
                name: "${widget.produt.name.replaceAll(',', '')}",
                name_th: "${widget.produt.name_th?.replaceAll(',', '')}",
                id: widget.produt.id!,
                qty: int.parse(gram.text),
                price: widget.produt.price ?? 0,
                totalPrice: widget.produt.price ?? 0),
            gram: int.parse(gram.text),
          );
    } else {
      context.read<CartCubit>().addToCartByGram(
            item: CartItem(
              is_buffet: widget.produt.is_buffet,
              is_gram: widget.produt.is_gram ?? false,
              name: "${widget.produt.name.replaceAll(',', '')}",
              name_th: "${widget.produt.name_th?.replaceAll(',', '')}",
              id: widget.produt.id!,
              qty: int.parse(gram.text),
              price: widget.produt.price ?? 0,
              totalPrice: widget.produt.price ?? 0,
            ),
            gram: int.parse(gram.text),
          );
    }
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
              num value = num.parse(gram.text);
              if (value > 0) {
                value -= 100;
                gram.text = value.toString();
              }
              if (value == 0) {
                gram.text = "100";
              }
              setState(() {});
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

  ///quantity control
  Widget quantityControlWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${widget.produt.name}",
          style: TextStyle(
            fontSize: FontSize.semiBig,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 15),

        _quantityControl(),

        //_levelChoose(),
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
              child: Text("${tr(LocaleKeys.lblAdd)}"),
              onPressed: () {
                addToCartByQuantity();
              },
            ),
          ],
        )
      ],
    );
  }

  ///add to cart by quantity
  void addToCartByQuantity() {
    if (widget.isEditState) {
      context.read<EditSaleCartCubit>().addToCartByQuantity(
            item: CartItem(
              is_buffet: widget.produt.is_buffet,
              is_gram: widget.produt.is_gram ?? false,
              name: "${widget.produt.name.replaceAll(',', '')}",
              name_th: "${widget.produt.name_th?.replaceAll(',', '')}",
              id: widget.produt.id!,
              qty: 1,
              price: widget.produt.price ?? 0,
              totalPrice: widget.produt.price ?? 0,
            ),
            quantity: quantity,
          );
    } else {
      context.read<CartCubit>().addToCartByQuantity(
            item: CartItem(
              is_buffet: widget.produt.is_buffet,
              is_gram: widget.produt.is_gram ?? false,
              name: "${widget.produt.name.replaceAll(',', '')}",
              name_th: "${widget.produt.name_th?.replaceAll(',', '')}",
              id: widget.produt.id!,
              qty: 1,
              price: widget.produt.price ?? 0,
              totalPrice: widget.produt.price ?? 0,
            ),
            quantity: quantity,
          );
    }

    Navigator.pop(context);
  }

  ///weight control widget
  Center _quantityControl() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (quantity > 1) {
                quantity--;
                setState(() {});
              }
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
          Center(
            child: Container(
              width: 70,
              child: Text(
                "${quantity}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: FontSize.semiBig),
              ),
            ),
          ),
          SizedBox(width: 30),
          InkWell(
            onTap: () {
              quantity++;
              setState(() {});
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
