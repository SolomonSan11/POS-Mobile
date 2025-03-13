import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:shimmer/shimmer.dart';

InputDecoration customTextDecoration({
  String labelText = "",
  String hintText = "",
  Widget? prefixIcon,
  Widget? suffixIcon,
  //Widget? prefixWidget,
  double fontSize = FontSize.small,
  Color? labelColor,
  Color? hintColor,
  bool floatLabel = false,
}) {
  return InputDecoration(
    labelText: "${labelText}",
    labelStyle: TextStyle(
      color: labelColor == null ? SScolor.greyColor : labelColor,
      fontSize: fontSize,
    ),
    floatingLabelBehavior:
        floatLabel ? FloatingLabelBehavior.auto : FloatingLabelBehavior.never,
    hintText: hintText,
    hintStyle: TextStyle(fontSize: FontSize.small, color: Colors.grey),
    prefixIcon: prefixIcon ?? Container(),
    suffixIcon: suffixIcon ??
        Icon(
          Icons.abc,
          color: Colors.transparent,
        ),
    //prefixIcon: prefixWidget ?? Container(),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 0.5,
        color: SScolor.greyColor,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 0.5,
        color: SScolor.greyColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 1,
        color: Colors.red,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 1,
        color: SScolor.primaryColor,
      ),
    ),
    filled: true,
    fillColor: Colors.white,
    focusColor: SScolor.greyColor,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 0,
    ),
  );
}

InputDecoration customTextDecoration2(
    {String labelText = "",
    String hintText = "",
    double fontSize = FontSize.small,
    Color? labelColor,
    Color? hintColor,
    bool floatLabel = false,
    double verticalPadding = 0}) {
  return InputDecoration(
    labelText: "${labelText}",
    labelStyle: TextStyle(
      color: labelColor == null ? SScolor.greyColor : labelColor,
      fontSize: fontSize,
    ),
    floatingLabelBehavior:
        floatLabel ? FloatingLabelBehavior.auto : FloatingLabelBehavior.never,
    hintText: hintText,
    hintStyle: TextStyle(fontSize: FontSize.small, color: Colors.grey),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 0.5,
        color: SScolor.greyColor,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 0.5,
        color: SScolor.greyColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 0.5,
        color: Colors.red,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 1,
        color: SScolor.primaryColor,
      ),
    ),
    filled: true,
    fillColor: Colors.white,
    focusColor: SScolor.greyColor,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 15,
      vertical: verticalPadding,
    ),
  );
}

///custumizable elevated button
Container custamizableElevated({
  Color fgColor = Colors.white,
  Color? bgColor,
  required Widget child,
  double width = 100,
  double radius = 15,
  double height = 45,
  double elevation = 0,
  required Function() onPressed,
  double fontSize = FontSize.normal,
  bool enabled = true,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5),
    //width: width,
    height: height,
    constraints: BoxConstraints(minWidth: width),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: fontSize),
        elevation: elevation,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        backgroundColor: bgColor == null ? SScolor.primaryColor : bgColor,
      ),
      onPressed: enabled ? onPressed : null,
      child: child,
    ),
  );
}

///shimmer loading widget
Shimmer categoryShimmer({double height = 35}) {
  return Shimmer.fromColors(
    baseColor: Colors.white,
    highlightColor: Colors.grey.shade300.withOpacity(0.5),
    child: Container(
      //margin: EdgeInsets.only(right: 15),
      constraints: BoxConstraints(
        minWidth: 170,
        minHeight: height,
      ),
      padding: EdgeInsets.only(
        top: 1,
        bottom: 1,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          "testing",
          style: TextStyle(
            color: Colors.transparent,
          ),
        ),
      ),
    ),
  );
}

///custumizable elevated button
Container customizableOTButton({
  Color? fgColor,
  Color? bgColor,
  required Widget child,
  double width = 100,
  double radius = 15,
  double height = 45,
  double elevation = 0,
  required Function() onPressed,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5),
    //width: width,
    constraints: BoxConstraints(minWidth: width, minHeight: height),

    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        elevation: elevation,
        foregroundColor: fgColor == null ? SScolor.greyColor : fgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        backgroundColor: bgColor == null ? Colors.white : bgColor,
      ),
      onPressed: onPressed,
      child: child,
    ),
  );
}

///appbar leading
InkWell appBarLeading({required Function() onTap}) {
  return InkWell(
    onTap: onTap,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: MyPadding.normal),
        Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Container(
            padding: EdgeInsets.only(
              left: 13,
              right: 13,
              top: 5,
              bottom: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                15,
              ),
            ),
            child: Center(
              child: Icon(
                IconlyBold.arrow_left_2,
                // size: 15,
              ),
            ),
          ),
        ),
        // SizedBox(width: 5),
        // Text(
        //   "${tr(LocaleKeys.lblBack)}",
        //   style: TextStyle(
        //     color: SScolor.primaryColor,
        //     fontWeight: FontWeight.normal,
        //   ),
        // )
      ],
    ),
  );
}



///locading Circle widget
Widget loadingWidget({
  Color? color,
  double? size,
  double? height,
}) {
  return Center(
    //child: CircularProgressIndicator(),
    child: CupertinoActivityIndicator(
      color: SScolor.primaryColor,
      radius: size == null ? 15 : size,
    ),
  );
}

Row copyRightWidget() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(width: 40),
      Text(
        "Copyright © 2024 - ${DateFormat('y').format(DateTime.now())} TermsFeed®. All rights reserved.",
        style: TextStyle(
          fontSize: FontSize.normal,
        ),
      ),
      SizedBox(width: 10),
      Row(
        children: [
          Text(
            "Developed By",
            style: TextStyle(
              fontSize: FontSize.normal,
            ),
          ),
          Text(
            " Softnovations",
            style: TextStyle(
              fontSize: FontSize.normal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      SizedBox(width: 30),
    ],
  );
}


// ///locading Circle widget
// Widget loadingDots({
//   Color? color,
//   double? size,
//   double? height,
// }) {
//   return Center(
//     child: Image.asset(
      
//       height: height == null ? 80 : height,
//       fit: BoxFit.contain,
//     ),
//   );
// }
