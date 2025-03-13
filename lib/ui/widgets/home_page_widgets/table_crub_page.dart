import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/menu_type_cubit/menu_type_cubit.dart';

// import 'package:golden_thailand/blocs/table_crud_cubit/table_crud_cubit.dart';
import 'package:golden_thailand/blocs/table_cubit/table_cubit.dart';
import 'package:golden_thailand/blocs/table_cubit/table_state.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';

// import 'package:golden_thailand/data/models/response_models/table_model.dart';
import 'package:golden_thailand/data/models/table_model.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/cancel_and_confirm_dialog_button.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/cancel_and_delete_dialog_button.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/common_crud_card.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/delete_warning_dialog.dart';
import 'package:golden_thailand/ui/widgets/internetCheckWidget.dart';

class TableCRUDScreen extends StatefulWidget {
  const TableCRUDScreen({super.key, required this.title});

  final String title;

  @override
  State<TableCRUDScreen> createState() => _TableCRUDScreenState();
}

class _TableCRUDScreenState extends State<TableCRUDScreen> {
  var tableNameController = TextEditingController();
  var productPriceController = TextEditingController();

  @override
  void initState() {
    context.read<TableCubit>().getAllLevels();
    context.read<MenuTypeCubit>().getMenuTypeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        centerTitle: true,
        leading: appBarLeading(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("${widget.title}"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: SScolor.primaryColor,
        label: Text("${tr(LocaleKeys.lblNewAdd)}"),
        icon: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return TableCRUDScreenDialog(
                screenSize: screenSize,
              );
            },
          );
        },
      ),
      body: InternetCheckWidget(
        onRefresh: () {
          context.read<TableCubit>().getAllLevels();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: MyPadding.normal,
          ),
          child: _productListTest(screenSize),
        ),
      ),
    );
  }

  Widget _productListTest(Size screenSize) {
    return BlocBuilder<TableCubit, TableState>(
      builder: (context, state) {
        if (state is TableLoading) {
          return loadingWidget();
        } else if (state is TableLoaded) {
          return state.TableList.length > 0
              ? GridView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20, top: 7.5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: MyPadding.normal,
                    crossAxisSpacing: MyPadding.normal,
                    childAspectRatio: screenSize.width * 0.002,
                  ),
                  itemCount: state.TableList.length,
                  itemBuilder: (context, index) {
                    TableModel table = state.TableList[index];
                    return Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: commonCrudCard(
                        title: "Table ${table.number.toString()}",
                        description: table.menu_type,
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return TableCRUDScreenDialog(
                                screenSize: screenSize,
                                table: table,
                              );
                            },
                          );
                        },
                        onDelete: () {
                          _deleteWarningDialog(
                            context: context,
                            screenSize: screenSize,
                            tableId: table.id.toString(),
                          );
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No Table Here!",
                    style: TextStyle(
                      fontSize: FontSize.big,
                    ),
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }

  ///delete table warning dialog box
  Future<dynamic> _deleteWarningDialog({
    required BuildContext context,
    required Size screenSize,
    required String tableId,
  }) {
    return deleteWarningDialog(
      context: context,
      screenSize: screenSize,
      child: BlocBuilder<TableCubit, TableState>(
        builder: (context, state) {
          if (state is TableLoading) {
            return loadingWidget();
          } else {
            return CancelAndDeleteDialogButton(
              onDelete: () async {
                await deletetableData(context, tableId);
              },
            );
          }
        },
      ),
    );
  }

  ///delete table
  Future<void> deletetableData(
    BuildContext context,
    String tableId,
  ) async {
    await context.read<TableCubit>().deleteTable(id: tableId).then(
      (value) {
        if (value) {
          Navigator.pop(context);
          context.read<TableCubit>().getAllLevels();
        }
      },
    );
  }
}

////table crud dialob box
class TableCRUDScreenDialog extends StatefulWidget {
  const TableCRUDScreenDialog({
    super.key,
    required this.screenSize,
    this.table,
  });

  final Size screenSize;

  final TableModel? table;

  @override
  State<TableCRUDScreenDialog> createState() => _TableCRUDScreenDialogState();
}

class _TableCRUDScreenDialogState extends State<TableCRUDScreenDialog> {
  final TextEditingController tableNameController = TextEditingController();
  int? menu_type_id;

  @override
  void initState() {
    context.read<MenuTypeCubit>().getMenuTypeData();
    if (widget.table != null) {
      tableNameController.text = widget.table!.number.toString();
    }
    // setState(() {});
    super.initState();
  }

  bool isGram = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(MyPadding.big - 10),
        width: widget.screenSize.width / 3.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              padding: EdgeInsets.all(MyPadding.normal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///table name
                  Text(
                    "${tr(LocaleKeys.lblAddTable)}",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    controller: tableNameController,
                    validator: (value) {
                      if (value == "") {
                        return "table Name can't be empty";
                      }
                      return null;
                    },
                    decoration: customTextDecoration2(
                      labelText: "${tr(LocaleKeys.lblEnterAddTable)}",
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${tr(LocaleKeys.lblChooseMenuType)}",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),

                  SizedBox(height: 10),
                  BlocBuilder<MenuTypeCubit,MenuTypeState>(
                      builder: (context,state){
                        if(state is MenuTypeLoading){
                          return loadingWidget();
                        }else if(state is MenuTypeLoaded){
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButtonFormField(
                              value: menu_type_id,
                              hint: Text("${tr(LocaleKeys.lblChooseMenuType)}"),
                              onChanged: (int? newValue) {
                                setState(() {
                                  menu_type_id = newValue;
                                });
                              },
                              items: state.menuTypeList.map((value) {
                                return DropdownMenuItem(
                                  value: value.id,
                                  child: Text("${value.menu}"),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                border:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 0.5,
                                    color: SScolor.greyColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }else{
                          return Container();
                        }
                      }
                  ),

                  SizedBox(height: 15),

                  BlocConsumer<TableCubit, TableState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is TableLoading) {
                        return loadingWidget();
                      } else {
                        return CancelAndConfirmDialogButton(
                          onConfirm: () async {
                            if (widget.table != null) {
                              await updatetable(context);
                            } else {
                              await createNewtable(context);
                            }
                          },
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///crate table
  Future<void> createNewtable(BuildContext context) async {
    await context
        .read<TableCubit>()
        .addNewTable(levelName: tableNameController.text,menuTypeId: menu_type_id??0)
        .then(
      (value) {
        if (value) {
          Navigator.pop(context);
          context.read<TableCubit>().getAllLevels();
        }
      },
    );
  }

  // /update table data
  Future<void> updatetable(BuildContext context) async {
    await context
        .read<TableCubit>()
        .editTable(
            name: tableNameController.text,
            description: "",
            id: widget.table!.id.toString())
        .then(
      (value) {
        if (value) {
          Navigator.pop(context);
          context.read<TableCubit>().getAllLevels();
        }
      },
    );
  }
}
