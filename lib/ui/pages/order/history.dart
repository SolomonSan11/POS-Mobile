import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/discount_cubit/discount_cubit.dart';
import 'package:golden_thailand/blocs/sales_history_cubit/sales_history_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
import 'package:golden_thailand/data/models/response_models/sale_history_model.dart';
import 'package:golden_thailand/ui/update_sale_ui/edit_sale_home.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/cancel_and_delete_dialog_button.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/delete_warning_dialog.dart';
import 'package:golden_thailand/ui/widgets/internetCheckWidget.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:golden_thailand/ui/widgets/voucher_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  TextEditingController searchController = TextEditingController();

  RefreshController refresherController = RefreshController();

  int currentPage = 1;

  int currentHistoryID = 1;

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

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  bool alreadyPrint = false;

  @override
  void initState() {
    context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);

    ///initialize sunmi printer
    _initializePrinter();

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
        title: Text("${tr(LocaleKeys.lblHistory)}"),
      ),
      body: InternetCheckWidget(
        child: _historyForm(screenSize),
        onRefresh: () {
          context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
        },
      ),
    );
  }

  ///historm form
  Container _historyForm(Size screenSize) {
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
          Container(
            width: double.infinity,
            height: 45,
            child: TextField(
              controller: searchController,
              decoration: customTextDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: "${tr(LocaleKeys.lblsearchHistory)}",
              ),
              onChanged: (value) {
                searchHistory(value: value);
              },
            ),
          ),
          SizedBox(height: 20),
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
                  BlocBuilder<SalesHistoryCubit, SalesHistoryState>(
                    builder: (context, state) {
                      if (state is SalesHistoryLoadingState) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: 15,
                            itemBuilder: (context, index) {
                              return _historyShimmer();
                            },
                          ),
                        );
                      } else if (state is SalesHistoryLoadedState) {
                        List<SaleHistoryModel> saleHistories = state.history;

                        print("sale history length : ${saleHistories.length}");

                        return Expanded(
                          child: SmartRefresher(
                            controller: refresherController,
                            physics: BouncingScrollPhysics(),
                            onRefresh: () async {
                              await context
                                  .read<SalesHistoryCubit>()
                                  .getHistoryByPagination(page: 1);

                              refresherController.refreshCompleted();

                              currentPage = 1;
                              print("current page : ${currentPage}");
                            },
                            onLoading: () async {
                              currentPage += 1;

                              if (mounted) {
                                print("loading page : ${currentPage}");

                                if (searchController.text == "" ||
                                    searchController.text.isEmpty) {
                                  context
                                      .read<SalesHistoryCubit>()
                                      .loadMoreHistory(
                                          page: currentPage, requestBody: {});
                                } else {}

                                refresherController.loadComplete();
                              }
                            },
                            enablePullDown: true,
                            enablePullUp: true,
                            child: ListView.builder(
                              itemCount: state.history.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {},
                                  child: _historyRowWidget(
                                    screenSize: screenSize,
                                    history: state.history[index],
                                    index: index + 1,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else if (state is SalesHistoryErrorState) {
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("History Not Found"),
                                SizedBox(height: 5),
                                IconButton(
                                  onPressed: () {
                                    currentPage = 1;
                                    context
                                        .read<SalesHistoryCubit>()
                                        .getHistoryByPagination(page: 1);
                                    setState(() {
                                      searchController.clear();
                                    });
                                  },
                                  icon: Icon(Icons.refresh, size: 35),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text("Someting is wrong"),
                        );
                      }
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

  ///get the payment type
  String getPaymentType(SaleHistoryModel sale) {
    int paidOnline = sale.paidOnline;
    int paidCash = sale.paidCash;
    if (paidCash > 0 && paidOnline == 0) {
      return "Cash";
    } else if (paidCash == 0 && paidOnline >= 0) {
      return "Prompt";
    } else {
      return "Cash / Prompt";
    }
  }

  ///shimmer loading effect for history list
  Shimmer _historyShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade300,
      child: Container(
        height: 30,
        margin: EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(color: Colors.grey),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "category shimer",
              style: TextStyle(
                color: Colors.transparent,
                fontSize: FontSize.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////history row widget
  Widget _historyRowWidget({
    required SaleHistoryModel history,
    required int index,
    required Size screenSize,
  }) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                padding: EdgeInsets.symmetric(horizontal: MyPadding.big),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 15),
                              child: Icon(Icons.clear),
                            ),
                          ),
                        ],
                      ),
                      VoucherWidget(
                        isCashPayment: history.paidCash > 0,
                        isBuffet: checkBuffet2(list: history.products),
                        paidAmount: history.grandTotal,
                        paymentType: getPaymentType(history),
                        subTotal: history.subTotal,
                        grandTotal: history.grandTotal,
                        date: history.created_at,
                        orderNumber: history.orderNo,
                        discount: history.discount.toString(),
                        cartItems: history.products
                            .map(
                              (e) => CartItem(
                                id: e.productId,
                                name: e.name,
                                name_th: e.name,
                                price: e.price,
                                is_buffet: e.is_buffet,
                                qty: e.qty,
                                totalPrice: e.totalPrice,
                                is_gram: false,
                              ),
                            )
                            .toList(),
                        dine_in_or_percel: history.dine_in_or_percel,
                        remark: history.remark,
                        table_number: int.parse(history.tableNumber),
                        showEditButton: true,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "${history.orderNo}",
                style: TextStyle(
                  fontSize: FontSize.normal,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "${history.tableNumber}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: FontSize.normal,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "${formatNumber(history.grandTotal)}  THB ",
                textAlign: TextAlign.right,
                //"${formatNumber(num.parse(history.grand_total ?? "0"))} THB",
                style: TextStyle(
                  fontSize: FontSize.normal,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 50),
              width: 90,
            ),
            Expanded(
              flex: 1,
              child: Text(
                "${history.created_at}",
                //  "${formatDate(history.created_at)}  ",
                //  DateFormat('EEEE, MMM d, y', 'En US').format(history.createdAt),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: FontSize.normal,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              width: 10,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      await printReceipt(
                          isBuffet: checkBuffet2(list: history.products),
                          discount:
                              int.parse(await context.read<DiscountCubit>().getValue()),
                          tableNumber: int.parse(history.tableNumber),
                          orderNumber: history.orderNo,
                          date: history.created_at.toString(),
                          time: 0,
                          products: history.products
                              .map((e) => CartItem(
                                    id: e.productId,
                                    name: e.name,
                                    name_th: e.name,
                                    is_buffet: e.is_buffet,
                                    price: e.price,
                                    qty: e.qty,
                                    totalPrice: e.totalPrice,
                                    is_gram: e.isGram,
                                  ))
                              .toList(),
                          discountAmount: history.discount,
                          subTotal: history.subTotal,
                          grandTotal: history.grandTotal,
                          cashAmount: history.paidCash,
                          remark: history.remark,
                          VATAmount: history.VAT,
                          dine_in_or_percel: history.dine_in_or_percel,
                          paymentType: getPaymentType(history),
                          PromptAmount: history.paidOnline,
                          refund: 0);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.print,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      redirectTo(
                        context: context,
                        form: EditSaleScreen(
                          saleHistory: history,
                          orderNo: history.orderNo,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                 _deleteWarningDialog(
                            context: context,
                            screenSize: screenSize,
                            id:history.id.toString()
                          );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///title row widget
  Row _titleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15),
          width: 15,
        ),
        Expanded(
          flex: 2,
          child: Text(
            "${tr(LocaleKeys.lblOrderId)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.normal,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40),
          width: 5,
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              "${tr(LocaleKeys.lblTableId)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: FontSize.normal,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "${tr(LocaleKeys.lblTotal)}",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.normal,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 80),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "${tr(LocaleKeys.lbldate)}",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.normal,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              " ",
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

  ///search history
  void searchHistory({required String value}) async {
    if (value.isEmpty || value == "") {
      context.read<SalesHistoryCubit>().getHistoryByPagination(
            page: 1,
          );
    } else {
      context.read<SalesHistoryCubit>().searchHistory(
            query: "${searchController.text}",
          );
    }
  }
    Future<void> _deleteHistoryData(
    BuildContext context,
    String id,
  ) async {
    await context
        .read<SalesHistoryCubit>()
        .deleteHistory(id: id)
        .then(
      (value) {
        if (value) {
          Navigator.pop(context);
          context.read<SalesHistoryCubit>().getHistoryByPagination(page: 1);
        }
      },
    );
  }
// delete history
    Future<dynamic> _deleteWarningDialog({
    required BuildContext context,
    required Size screenSize,
    required String id,
  }) {
    return deleteWarningDialog(
      context: context,
      screenSize: screenSize,
      child: BlocBuilder<SalesHistoryCubit, SalesHistoryState>(
        builder: (context, state) {
          if (state is SalesHistoryLoadingState) {
            return loadingWidget();
          } else {
            return CancelAndDeleteDialogButton(
              onDelete: () async {
                await _deleteHistoryData(context, id);
              },
            );
          }
        },
      ),
    );
  }

  void _initializePrinter() {
    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });
    });
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
