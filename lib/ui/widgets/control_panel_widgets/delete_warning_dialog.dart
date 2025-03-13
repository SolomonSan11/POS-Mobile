import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';

///delete category warning dialog box
Future<dynamic> deleteWarningDialog({
  required BuildContext context,
  required Size screenSize,
  required Widget child,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(MyPadding.big - 10),
          width: screenSize.width / 3.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Text(
                "${tr(LocaleKeys.lblDeletePrompt)}",
                style: TextStyle(fontSize: FontSize.normal),
              ),
              SizedBox(height: 15),
              child
            ],
          ),
        ),
      );
    },
  );
}
