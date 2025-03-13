import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';

class CancelAndConfirmDialogButton extends StatelessWidget {
  const CancelAndConfirmDialogButton({super.key, required this.onConfirm});
  final Future Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          bgColor: SScolor.primaryColor,
          child: Text("${tr(LocaleKeys.lblConfirm)}"),
          onPressed: () async {
            await onConfirm();
            print("testing bbb");
          },
        ),
      ],
    );
  }
}
