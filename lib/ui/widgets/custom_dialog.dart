import 'package:flutter/material.dart';
import 'package:golden_thailand/core/size_const.dart';

// ignore: must_be_immutable
class CustomDialog extends StatelessWidget {
   CustomDialog({
    super.key,
    required this.child,
    this.width,
    this.paddingInVertical = true,
  });
  final Widget child;
  final double? width;
  bool paddingInVertical;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical:paddingInVertical ? MyPadding.big : 0,
          horizontal: MyPadding.big,
        ),
        width: width == null ? size.width / 3.8 : width,
        child: child,
      ),
    );
  }
}
