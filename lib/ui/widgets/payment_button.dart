import 'package:flutter/material.dart';
import 'package:golden_thailand/core/app_theme_const.dart';

class PaymentButton extends StatelessWidget {
  const PaymentButton({
    super.key,
    required this.isSelected,
    required this.title,
  });
  final bool isSelected;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1.5,
          color: isSelected ? SScolor.primaryColor : Colors.transparent,
        ),
      ),
      child: Center(
        child: Text(
          "${title}",
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? SScolor.primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}
