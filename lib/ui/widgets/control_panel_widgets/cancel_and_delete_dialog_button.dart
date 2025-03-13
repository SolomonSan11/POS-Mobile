import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';

class CancelAndDeleteDialogButton extends StatelessWidget {
  const CancelAndDeleteDialogButton({super.key, required this.onDelete});
  final Future Function() onDelete;

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
          bgColor: Colors.red,
          child: Text("${tr(LocaleKeys.lblDelete)}"),
          onPressed: () async {
            await onDelete();
            print("testing delete");
          },
        ),
      ],
    );
  }
}
