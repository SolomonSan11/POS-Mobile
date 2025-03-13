import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/pending_order_cubit/pending_order_cubit.dart';
import 'package:golden_thailand/blocs/table_cubit/table_cubit.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/blocs/table_cubit/table_state.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/order_pending_model.dart';
import 'package:golden_thailand/data/models/table_model.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/internetCheckWidget.dart';

class TableNumberDialog extends StatefulWidget {
  final TextEditingController tableController;
  final bool isBuffet;

  const TableNumberDialog(
      {Key? key, required this.tableController, required this.isBuffet})
      : super(key: key);

  @override
  State<TableNumberDialog> createState() => _TableNumberDialogState();
}

class _TableNumberDialogState extends State<TableNumberDialog> {
  List<TableModel> standartType = [];
  List<TableModel> buffetType = [];
  @override
  void initState() {
    super.initState();
    context.read<TableCubit>().getAllLevels();
  }

  void _filterTableData(List<TableModel> tableList) {
    standartType = tableList.where((e) => e.menu_type_id == 2).toList();
    buffetType = tableList.where((e) => e.menu_type_id == 1).toList();
  }

  @override
  Widget build(BuildContext context) {
    CartCubit cartCubit = BlocProvider.of<CartCubit>(context);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.8, // Set width to 80% of screen
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensure height adapts to content
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Choose Table Number",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      // widget.isBuffet
                      //     ? Text(
                      //         "(Buffet)",
                      //         style:
                      //             Theme.of(context).textTheme.headlineSmall,
                      //       )
                      //     : Container()
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.clear),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              InternetCheckWidget(
                  child: BlocBuilder<TableCubit, TableState>(
                    builder: (context, tableState) {
                      if (tableState is TableLoading) {
                        return loadingWidget();
                      } else if (tableState is TableLoaded) {
                        // Filter tables into separate lists
                        _filterTableData(tableState.TableList);

                        return BlocBuilder<PendingOrderCubit, PendingOrderState>(
                          builder: (context, pending) {
                            return Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Buffet Section
                                  if (standartType.isNotEmpty) ...[
                                    Text(
                                      "Standard Tables",
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 100,
                                          crossAxisCount: 5,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20,
                                        ),
                                        itemCount: standartType.length,
                                        itemBuilder: (context, index) {
                                          final table = standartType[index];
                                          final isExisted = checkTable(
                                            tableId: table.id ?? 0,
                                            tableNumber: int.parse(table.number!),
                                            list: pending.pendingOrderList,
                                          );
                                          return _tableGridCard(
                                            isExisted,
                                            cartCubit,
                                            table,
                                            context,
                                          );
                                        },
                                      ),
                                    ),
                                    Divider(color: Colors.grey, thickness: 1),
                                  ],

                                  // Standard Section
                                  if (buffetType.isNotEmpty) ...[
                                    Text(
                                      "Buffet Tables",
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 100,
                                          crossAxisCount: 5,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20,
                                        ),
                                        itemCount: buffetType.length,
                                        itemBuilder: (context, index) {
                                          final table = buffetType[index];
                                          final isExisted = checkTable(
                                            tableId: table.id ?? 0,
                                            tableNumber: int.parse(table.number!),
                                            list: pending.pendingOrderList,
                                          );
                                          return _tableGridCard(
                                            isExisted,
                                            cartCubit,
                                            table,
                                            context,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        );
                      } else if (tableState is TableError) {
                        return Text("Error: ${tableState.error}");
                      } else {
                        return Container();
                      }
                    },
                  ),
                  onRefresh: () {})
            ],
          ),
        ),
      ),
    );
  }

  ///TABLE GRID CARD
  Widget _tableGridCard(
    bool isExisted,
    CartCubit cartCubit,
    // int index,
    TableModel table,
    BuildContext context,
  ) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isExisted ? SScolor.primaryColor : Colors.grey.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        if (isExisted) {
          showSnackBar(text: "This table is not available!", context: context);
        } else {
          // Navigator.pop(context);
          cartCubit.addTableNumber(
            tableNumber: int.parse(table.number.toString()),
            tableId: table.id ?? 0,
            menu_type_id: table.menu_type_id ?? 0
          );

          if (cartCubit.state.tableNumber != 0) {
            Navigator.pop(context);
          } else {
            print("table number : ${cartCubit.state.tableNumber}");
          }
        }
      },
      child: isExisted
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Table ${table.number}",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Not Available!",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Table ${table.number}",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 10),
                Text(
                  "${table.menu_type}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
    );
  }

  bool checkTable({
    required int tableId,
    required int tableNumber,
    required List<PendingOrder> list,
  }) {
    return list.any(
      (e) => tableId == e.tableId && tableNumber == e.tableNumber,
    );
  }
}
