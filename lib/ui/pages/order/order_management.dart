import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/pending_order_cubit/pending_order_cubit.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/order_pending_model.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
import 'package:golden_thailand/ui/pages/order/ordder_confirm_or_edit.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/cancel_and_delete_dialog_button.dart';
import 'package:golden_thailand/ui/widgets/custom_dialog.dart';
import 'package:golden_thailand/ui/widgets/internetCheckWidget.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrderManageScreen extends StatefulWidget {
  const OrderManageScreen({super.key});

  @override
  State<OrderManageScreen> createState() => _pendingOrderState();
}

class _pendingOrderState extends State<OrderManageScreen> {
  TextEditingController searchController = TextEditingController();

  RefreshController refresherController = RefreshController();

  int currentPage = 1;

  int currentpendingOrderID = 1;

  bool visible = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  bool alreadyPrint = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 200,
        leading: appBarLeading(
          onTap: () {
            Navigator.pop(context);
          },
        ),
      //  title: Text("Test"),
        title: Text("${tr(LocaleKeys.lblOrderManage)}"),
      ),
      body: InternetCheckWidget(
        child: _pendingOrderForm(screenSize),
        onRefresh: () {},
      ),
    );
  }

  ///historm form
  Container _pendingOrderForm(Size screenSize) {
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      padding: EdgeInsets.only(
        left: MyPadding.normal,
        right: MyPadding.normal,
        top: MyPadding.normal - 5,
        bottom: MyPadding.normal,
      ),
      child: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   height: 45,
          //   child: TextField(
          //     controller: searchController,
          //     decoration: customTextDecoration(
          //       prefixIcon: Icon(Icons.search),
          //       labelText: "အရောင်းမှတ်တမ်းရှာဖွေရန်",
          //     ),
          //     onChanged: (value) {},
          //   ),
          // ),
          // SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(MyPadding.semiBig),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _titleRow(),
                  SizedBox(height: 25),
                  BlocBuilder<PendingOrderCubit, PendingOrderState>(
                    builder: (context, state) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: state.pendingOrderList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {},
                              child: _pendingOrderRow(
                                pendingOrder: state.pendingOrderList[index],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<int> _calculateGrandTotal(PendingOrder pendingOrder) async {
    int totalAmount =
        pendingOrder.items.fold(0, (sum, e) => sum + e.totalPrice);
    int discountedTotal = await calculateDiscount(context, totalAmount);
    return discountedTotal + get7percentage(discountedTotal);
  }

  ////pendingOrder row widget
  Widget _pendingOrderRow({
    required PendingOrder pendingOrder,
  }) {
    // int grand_total = 0;
    // pendingOrder.items.forEach((e) {
    //   grand_total += e.totalPrice;
    // });
    // grand_total += get7percentage(grand_total);
    return FutureBuilder<int>(
      future: _calculateGrandTotal(pendingOrder),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return InkWell(
          onTap: () {
            redirectTo(
              context: context,
              form: OrderConfirmOrEdit(
                pendingOrder: pendingOrder,
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: checkBuffet(list: pendingOrder.items)
                      ? Row(
                          children: [
                            Text(
                              "${pendingOrder.tableNumber}",
                              style: TextStyle(
                                fontSize: FontSize.normal + 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: SScolor.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Buffet",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.white),
                              ),
                            )
                          ],
                        )
                      : Text(
                          "${pendingOrder.tableNumber}",
                          style: TextStyle(
                            fontSize: FontSize.normal + 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${pendingOrder.orderUniqueId}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${timeago.format(pendingOrder.time)}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),
                ),
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     children: [
                //       ...pendingOrder.items.map((e)=>Text("${e.name} / ${e.qty}")).toList()
                //     ],
                //   )
                // ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${formatNumber(snapshot.data ?? 0)} THB ",
                    textAlign: TextAlign.right,
                    //"${formatNumber(num.parse(pendingOrder.grand_total ?? "0"))} THB",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          _showdeleteDialog(pendingOrder);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _showdeleteDialog(PendingOrder pendingOrder) {
    return showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure!!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: SScolor.primaryColor),
              ),
              SizedBox(height: 20),
              CancelAndDeleteDialogButton(
                onDelete: () async {
                  context
                      .read<PendingOrderCubit>()
                      .removePendingOrder(pendingOrder: pendingOrder);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  ///title row widget
  Row _titleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "Table No.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.normal,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              "Order ID",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: FontSize.normal,
              ),
            ),
          ),
        ),
        // Expanded(
        //   flex: 1,
        //   child: Text(
        //     "Products",
        //     textAlign: TextAlign.right,
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //       fontSize: FontSize.normal,
        //     ),
        //   ),
        // ),
        Expanded(
          flex: 1,
          child: Text(
            "Time",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.normal,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Grand Total",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.normal,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: FontSize.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Add the payment method logic here:
String getPaymentMethod({required int paidCash, required int paidOnline}) {
  if (paidCash > 0 && paidOnline == 0) {
    return "";
  } else if (paidOnline > 0 && paidCash == 0) {
    return "Prompt";
  } else if (paidCash > 0 && paidOnline > 0) {
    return "cash/Prompt";
  } else {
    return "unknown"; // In case neither condition is met
  }
}

bool checkBuffet({
  required List<CartItem> list,
}) {
  return list.any(
    (e) => e.name.toLowerCase().contains("buffet") || e.is_buffet == 1,
  );
}
