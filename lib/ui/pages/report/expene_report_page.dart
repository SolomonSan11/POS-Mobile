import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/expense_report_cubit/expense_report_cubit.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/internetCheckWidget.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class ExpeneReportPage extends StatefulWidget {
  const ExpeneReportPage({super.key});

  @override
  State<ExpeneReportPage> createState() => _ExpeneReportPageState();
}

class _ExpeneReportPageState extends State<ExpeneReportPage> {
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
    super.initState();

    context.read<ExpenseReportCubit>().getDailyReport();

    ///initialize sunmi printer
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

      setState(() {
        printBinded = isBind!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${tr(LocaleKeys.lblExpenseReport)}"),
          leadingWidth: 100,
          centerTitle: true,
          leading: appBarLeading(
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButton: _floatingActionButton(),
        body: InternetCheckWidget(
          child: _mainForm(context),
          onRefresh: () {},
        ),
      ),
    );
  }

  ///floating action button to printout reports
  BlocBuilder<ExpenseReportCubit, ExpenseReportState> _floatingActionButton() {
    return BlocBuilder<ExpenseReportCubit, ExpenseReportState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          backgroundColor: SScolor.primaryColor,
          onPressed: () {
            if (state is ExpenseReportDaily) {
              print("todal : ${state.expenseReport.daily_date}");
              _printReceipt(
                profit: state.expenseReport.profit ?? 0,
                income: state.expenseReport.income ?? 0,
                expense: state.expenseReport.expense ?? 0,
                report: "${state.expenseReport.daily_date}",
              );
            } else if (state is ExpenseReportWeekly) {
              print("start of week : ${state.expenseReport.start_of_week}");
              print("end of week : ${state.expenseReport.end_of_week}");
              _printReceipt(
                profit: state.expenseReport.profit ?? 0,
                income: state.expenseReport.income ?? 0,
                expense: state.expenseReport.expense ?? 0,
                report:
                    "${state.expenseReport.start_of_week} to ${state.expenseReport.end_of_week}",
              );
            } else if (state is ExpenseReportMonthly) {
              print("current month : ${state.currentMonthSale.current_month}");
              _printReceipt(
                profit: state.currentMonthSale.profit ?? 0,
                income: state.currentMonthSale.income ?? 0,
                expense: state.currentMonthSale.expense ?? 0,
                report:
                    "${state.currentMonthSale.current_month}",
              );
              // _printMontylyReport(
              //   lastMonthDate: state.lastMonthSale.past_month ?? "",
              //   currentMonthDate: state.currentMonthSale.current_month ?? "",
              //   lastMonthcashAmount: state.lastMonthSale.total_paid_cash ?? 0,
              //   lastMonthPromptAmount: state.lastMonthSale.total_paid_online ?? 0,
              //   lastMonthtotalAmount: state.lastMonthSale.total_Grands ?? 0,
              //   currentMonthcashAmount:
              //       state.currentMonthSale.total_paid_cash ?? 0,
              //   currentMonthPromptAmount:
              //       state.currentMonthSale.total_paid_online ?? 0,
              //   currentMonthtotalAmount:
              //       state.currentMonthSale.total_Grands ?? 0,
              // );
            }
          },
          label: Text("${tr(LocaleKeys.lblPrintExpenseReport)}"),
          icon: Icon(CupertinoIcons.printer),
        );
      },
    );
  }

  ///main form of the page
  Column _mainForm(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: MyPadding.normal),
          child: TabBar(
            onTap: (value) {
              print("current value : ${value}");
              if (value == 0) {
                context.read<ExpenseReportCubit>().getDailyReport();
              } else if (value == 1) {
                context.read<ExpenseReportCubit>().getWeeklyReport();
              } else if (value == 2) {
                context.read<ExpenseReportCubit>().getMontylyReport();
              }
            },
            tabs: [
              Tab(text: '${tr(LocaleKeys.lbltoday)}'),
              Tab(text: '${tr(LocaleKeys.lblweekly)}'),
              Tab(text: '${tr(LocaleKeys.lblmonthly)}'),
            ],
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: TabBarView(
            children: [
              BlocBuilder<ExpenseReportCubit, ExpenseReportState>(
                builder: (context, state) {
                  if (state is ExpenseReportDaily) {
                    return _reportWidget(
                      name: "Today",
                      profit: state.expenseReport.profit ?? 0,
                      income: state.expenseReport.income ?? 0,
                      expense: state.expenseReport.expense ?? 0,
                    );
                  } else if (state is ExpenseReportLoading) {
                    return loadingWidget();
                  } else {
                    return _reportWidget(
                      name: "${tr(LocaleKeys.lbltoday)}",
                      profit: 0,
                      income: 0,
                      expense: 0,
                    );
                  }
                },
              ),
              BlocBuilder<ExpenseReportCubit, ExpenseReportState>(
                builder: (context, state) {
                  if (state is ExpenseReportWeekly) {
                    return _reportWidget(
                      name: "Current Week",
                      profit: state.expenseReport.profit ?? 0,
                      income: state.expenseReport.income ?? 0,
                      expense: state.expenseReport.expense ?? 0,
                    );
                  } else if (state is ExpenseReportLoading) {
                    return loadingWidget();
                  } else {
                    return _reportWidget(
                      name: "Current Week",
                      profit: 0,
                      income: 0,
                      expense: 0,
                    );
                  }
                },
              ),
              BlocBuilder<ExpenseReportCubit, ExpenseReportState>(
                builder: (context, state) {
                  if (state is ExpenseReportMonthly) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   padding: EdgeInsets.only(left: 20, bottom: 20),
                        //   child: Text(
                        //     "${tr(LocaleKeys.lblPreviousMonth)}",
                        //     style: TextStyle(
                        //       fontSize: FontSize.semiBig - 2,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        // ),
                        // _reportWidget(
                        //   name:   "${tr(LocaleKeys.lblPreviousMonth)}",
                        //   profit:
                        //       state.lastMonthSale.profit ?? 0,
                        //   income: state.lastMonthSale.income ?? 0,
                        //   expense: state.lastMonthSale.expense ?? 0,
                        // ),
                        // Container(
                        //   padding: EdgeInsets.only(left: 20, bottom: 20),
                        //   child: Text(
                        //     "${tr(LocaleKeys.lblThisMonth)}",
                        //     style: TextStyle(
                        //       fontSize: FontSize.semiBig - 2,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        // ),
                        _reportWidget(
                          name: "Current Month",
                          profit:
                              state.currentMonthSale.profit ?? 0,
                          income:
                              state.currentMonthSale.income ?? 0,
                          expense: state.currentMonthSale.expense ?? 0,
                        )
                      ],
                    );
                  } else if (state is ExpenseReportLoading) {
                    return loadingWidget();
                  } else {
                    return Center(
                      child: Text(
                        "No Monthly Report",
                        style: TextStyle(
                          fontSize: FontSize.big - 5,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///sale report widget
  Widget _reportWidget({
    required int profit,
    required int income,
    required int expense,
    required name,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MyPadding.normal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _reportCardWidget(
                  amount: "${profit}",
                  title: "${tr(LocaleKeys.lblProfit)}",
                  icon: Icon(
                    CupertinoIcons.arrow_up_circle,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _reportCardWidget(
                  amount: "${income}",
                  title: "${tr(LocaleKeys.lblIncome)}",
                  icon: Icon(
                    CupertinoIcons.money_dollar,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _reportCardWidget(
                  amount: "${expense}",
                  title: "${tr(LocaleKeys.lblExpense)}",
                  isTotalSales: true,
                  icon: Icon(
                    CupertinoIcons.minus_circle,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 35),
        ],
      ),
    );
  }

  ///report cart widget to show the detail of the report with title
  Container _reportCardWidget({
    required String title,
    required String amount,
    required Widget icon,
    bool isTotalSales = false,
  }) {
    return Container(
      padding: EdgeInsets.all(MyPadding.big),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey.shade100,
                child: icon,
              ),
              SizedBox(width: 20),
              Text(
                "${title}",
                style: TextStyle(
                  fontSize: FontSize.normal + 3,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          Text(
            isTotalSales
                ? "${amount}"
                : "${formatNumber(num.parse(amount))} THB",
            style: TextStyle(
              fontSize: FontSize.big,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  ///print out
  Future<bool> _printReceipt({
    required int profit,
    required int income,
    required int expense,
    required String report,
  }) async {
    try {
      await SunmiPrinter.initPrinter();

      await SunmiPrinter.startTransactionPrint(true);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

     
      await SunmiPrinter.printText("");

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Report',
          width: 17,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: ':',
          width: 2,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: '${report}',
          width: 25,
          align: SunmiPrintAlign.LEFT,
        ),
      ]);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: '${tr(LocaleKeys.lblProfit)}',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(profit)} THB',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      await SunmiPrinter.printRow(
        cols: [
          ColumnMaker(
            text: '${tr(LocaleKeys.lblIncome)}',
            width: 20,
            align: SunmiPrintAlign.LEFT,
          ),
          ColumnMaker(
            text: '${formatNumber(income)} THB',
            width: 26,
            align: SunmiPrintAlign.RIGHT,
          ),
        ],
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: '${tr(LocaleKeys.lblExpense)}',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(expense)} THB',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printText("");
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.cut();
      await SunmiPrinter.exitTransactionPrint(true);

      return true;
    } catch (e) {
      return false;
    }
  }

}
