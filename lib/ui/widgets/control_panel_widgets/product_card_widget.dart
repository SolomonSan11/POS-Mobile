import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/response_models/product_model.dart';

///product card widget from control panel
Widget productCardWidget({
  required ProductModel product,
  required Function() onEdit,
  required Function() onDelete,
  required BuildContext context,
}) {
  return Container(
    padding: EdgeInsets.only(
      top: MyPadding.normal - 3,
      bottom: MyPadding.normal - 3,
      left: MyPadding.big,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                     "${product.name}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: FontSize.normal,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "${formatNumber(product.price as num)} THB",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: FontSize.normal + 3,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            InkWell(
              onTap: onEdit,
              child: Container(
                padding: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
            ),
            InkWell(
              onTap: onDelete,
              child: Container(
                padding: EdgeInsets.only(right: 15, left: 5),
                child: Icon(
                  CupertinoIcons.delete,
                  size: 20,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ],
    ),
  );
}
