import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/pending_order_cubit/pending_order_cubit.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/ui/pages/order/order_management.dart';

class OrderManageWidget extends StatelessWidget {
  const OrderManageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          redirectTo(context: context, form: OrderManageScreen());
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${tr(LocaleKeys.lblOrderManage)}",
                style: TextStyle(
                  color: SScolor.primaryColor,
                  fontSize: FontSize.semiBig - 4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10),
              BlocBuilder<PendingOrderCubit, PendingOrderState>(
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      color: SScolor.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 6,vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.cart,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Text(
                        "${state.pendingOrderList.length}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14
                        ),
                      ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
