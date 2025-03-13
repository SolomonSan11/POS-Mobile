import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:golden_thailand/core/size_const.dart';

Widget commonCrudCard({
  required String title,
   String? description,
   Function()? onEdit,
  required Function() onDelete,
}) {
  return Container(
    padding: EdgeInsets.only(
      top: MyPadding.normal - 3,
      bottom: MyPadding.normal - 3,
      left: MyPadding.big,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FontSize.normal,
                color: Colors.black,
              ),
            ),
            Visibility(
              visible: description != "",
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Text(
                    "${description ?? ''}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: FontSize.normal - 3,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Spacer(),
        Spacer(),
        InkWell(
          onTap: onEdit,
          child: Container(
            padding: EdgeInsets.all(16),
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
            padding: EdgeInsets.all(16),
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
  );
}
