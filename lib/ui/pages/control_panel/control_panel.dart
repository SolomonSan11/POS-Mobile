import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/ui/pages/control_panel/category_crud_page.dart';
import 'package:golden_thailand/ui/pages/control_panel/expense_crud_page.dart';
import 'package:golden_thailand/ui/pages/control_panel/products_crud_page.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/discount_crud_page.dart';
import 'package:golden_thailand/ui/widgets/home_page_widgets/table_crub_page.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({super.key});

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        centerTitle: true,
        leading: appBarLeading(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("${tr(LocaleKeys.lblSetting)}"),
      ),
      body: _mainForm(context),
    );
  }

  ///main form
  Container _mainForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MyPadding.normal, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              _cardWidget(
                name: "${tr(LocaleKeys.lblTable)}",
                redirectForm: TableCRUDScreen(title: "${tr(LocaleKeys.lblTable)}"),
                widget: Icon(
                  CupertinoIcons.table_fill,
                  size: 35,
                ),
              ),
              SizedBox(width: MyPadding.normal),
              _cardWidget(
                name: "${tr(LocaleKeys.lblProduct)}",
                redirectForm: ProductCRUDPage(
                  title: "${tr(LocaleKeys.lblProduct)}",
                ),
                widget: Icon(
                  CupertinoIcons.bag,
                  size: 35,
                ),
              ),
              SizedBox(width: MyPadding.normal),
              _cardWidget(
                name: "${tr(LocaleKeys.lblCategory)}",
                redirectForm: CategoryCRUDScreen(title: "${tr(LocaleKeys.lblCategory)}"),
                widget: Icon(
                  CupertinoIcons.square_list,
                  size: 35,
                ),
              ),
              // SizedBox(width: MyPadding.normal),
              // _cardWidget(
              //   name: "${tr(LocaleKeys.lbldiscount)}",
              //   redirectForm: DiscountCRUDScreen(title: "${tr(LocaleKeys.lbldiscount)}"),
              //   widget: Icon(
              //     CupertinoIcons.percent,
              //     size: 35,
              //   ),
              // ),

            ],
          ),
          SizedBox(height: MyPadding.normal),
          Row(
            children: [
              _cardWidget(
                name: "${tr(LocaleKeys.lbldiscount)}",
                redirectForm: DiscountCRUDScreen(title: "${tr(LocaleKeys.lbldiscount)}"),
                widget: Icon(
                  CupertinoIcons.percent,
                  size: 35,
                ),
              ),
              SizedBox(width: MyPadding.normal),
              _cardWidget(
                name: "${tr(LocaleKeys.lblExpense)}",
                redirectForm: ExpenseCRUDScreen(title: "${tr(LocaleKeys.lblExpense)}"),
                widget: Icon(
                  CupertinoIcons.money_dollar_circle,
                  size: 35,
                ),
              ),
              SizedBox(width: 425),

            ],
          ),

        ],
      ),
    );
  }

  /// title categories card widget
  Widget _cardWidget({
    required String name,
    required Widget widget,
    required Widget redirectForm,
  }) {
    return Expanded(
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          redirectTo(
            context: context,
            form: redirectForm,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                child: widget,
              ),
              SizedBox(width: 15),
              Text(
                "${name}",
                style: TextStyle(fontSize: FontSize.semiBig),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
