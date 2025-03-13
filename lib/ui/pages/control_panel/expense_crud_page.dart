import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/category_crud_cubit/category_crud_cubit.dart';
import 'package:golden_thailand/blocs/category_cubit/category_cubit.dart';
import 'package:golden_thailand/blocs/expense/expense_cubit.dart';
import 'package:golden_thailand/blocs/expense_crud_cubit/expense_crud_cubit.dart';
import 'package:golden_thailand/blocs/sale_record_cubit/sale_record_cubit.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/data/models/response_models/expense_model.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/cancel_and_confirm_dialog_button.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/cancel_and_delete_dialog_button.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/common_crud_card.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/delete_warning_dialog.dart';
import 'package:golden_thailand/ui/widgets/internetCheckWidget.dart';

class ExpenseCRUDScreen extends StatefulWidget {
  const ExpenseCRUDScreen({super.key, required this.title});
  final String title;

  @override
  State<ExpenseCRUDScreen> createState() => _CategoryCRUDScreenState();
}

class _CategoryCRUDScreenState extends State<ExpenseCRUDScreen> {
  var categoryNameController = TextEditingController();
  var priceController = TextEditingController();

  @override
  void initState() {
    context.read<ExpenseCubit>().getAllExpense();
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
              return ExpenseCRUDScreenDialog(
                screenSize: screenSize,
              );
            },
          );
        },
      ),
      body: InternetCheckWidget(
        onRefresh: () {
          context.read<CategoriesCubit>().getAllCategories();
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
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoadingState) {
          return loadingWidget();
        } else if (state is ExpenseLoadedState) {
          return state.ExpenseList.length > 0
              ? GridView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20, top: 7.5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: MyPadding.normal,
                    crossAxisSpacing: MyPadding.normal,
                    childAspectRatio: screenSize.width * 0.002,
                  ),
                  itemCount: state.ExpenseList.length,
                  itemBuilder: (context, index) {
                    ExpenseModel expense = state.ExpenseList[index];
                    return Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: commonCrudCard(
                        title: expense.name.toString(),
                        description: expense.price.toString(),
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ExpenseCRUDScreenDialog(
                                screenSize: screenSize,
                                expense: expense,
                              );
                            },
                          );
                        },
                        onDelete: () {
                          _deleteWarningDialog(
                            context: context,
                            screenSize: screenSize,
                            categoryId: expense.id.toString(),
                          );
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No Expense Here!",
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

  ///delete category warning dialog box
  Future<dynamic> _deleteWarningDialog({
    required BuildContext context,
    required Size screenSize,
    required String categoryId,
  }) {
    return deleteWarningDialog(
      context: context,
      screenSize: screenSize,
      child: BlocBuilder<ExpenseCrudCubit, ExpenseCrudState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return loadingWidget();
          } else {
            return CancelAndDeleteDialogButton(
              onDelete: () async {
                await deleteExpenseData(context, categoryId);
              },
            );
          }
        },
      ),
    );
  }

  ///delete category
  Future<void> deleteExpenseData(
    BuildContext context,
    String categoryId,
  ) async {
    await context.read<ExpenseCrudCubit>().deleteExpense(id: categoryId).then(
      (value) {
        if (value) {
          Navigator.pop(context);
          context.read<ExpenseCubit>().getAllExpense();
        }
      },
    );
  }
}
enum Type{dailyExpense,monthlyExpense}
////category crud dialob box
class ExpenseCRUDScreenDialog extends StatefulWidget {
  const ExpenseCRUDScreenDialog({
    super.key,
    required this.screenSize,
    this.expense,
  });

  final Size screenSize;

  final ExpenseModel? expense;

  @override
  State<ExpenseCRUDScreenDialog> createState() =>
      _ExpenseCRUDScreenDialogState();
}



class _ExpenseCRUDScreenDialogState extends State<ExpenseCRUDScreenDialog> {
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  int selectedRadio = 1;
  int? selectedValue;


  @override
  void initState() {
    if (widget.expense != null) {
      categoryNameController.text = widget.expense!.name.toString();
      priceController.text = widget.expense!.price.toString();
      selectedRadio = widget.expense!.type!;
    }
    setState(() {});
    super.initState();
    context.read<SaleRecordCubit>().getSaleRecordList();
  }

  // bool isGram = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MyPadding.big - 10),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:  widget.screenSize.width / 3.8
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: selectedRadio,
                          groupValue: 1,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = 1;
                            });
                          },
                        ),
                        const Text('Daily Expense'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: selectedRadio,
                          groupValue: 2,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = 2;
                            });
                          },
                        ),
                        const Text('Monthly Expense'),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.all(MyPadding.normal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // choose type for creating expense
                      BlocBuilder<SaleRecordCubit,SaleRecordState>(
                          builder: (context,state){
                            if(state is SaleRecordLoaded && selectedRadio == 2){
                              return DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: 'Select a month',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                value: selectedValue,
                                items: state.saleRecordModel.map((item) {
                                  return DropdownMenuItem(
                                    value: item.id,
                                    child: Text("${item.monthYear}"),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                              );
                            }else if(state is SaleRecordLoading && selectedRadio ==2){
                              return loadingWidget();
                            }else{
                              return SizedBox();
                            }
                          }
                      ),
                      SizedBox(height: 10),
                      ///category name
                      Text(
                        "${tr(LocaleKeys.lblExpense)}",
                        style: TextStyle(
                          fontSize: FontSize.normal,
                        ),
                      ),

                      SizedBox(height: 10),
                      TextFormField(
                        controller: categoryNameController,
                        validator: (value) {
                          if (value == "") {
                            return "Expense  can't be empty";
                          }
                          return null;
                        },
                        decoration: customTextDecoration2(
                          labelText: "Add Expense",
                        ),
                      ),

                      SizedBox(height: 15),
                      Text(
                        "${tr(LocaleKeys.lblPrice)}",
                        style: TextStyle(
                          fontSize: FontSize.normal,
                        ),
                      ),

                      SizedBox(height: 10),
                      TextFormField(
                        controller: priceController,
                        validator: (value) {
                          if (value == "") {
                            return "Price  can't be empty";
                          }
                          return null;
                        },
                        decoration: customTextDecoration2(
                          labelText: "Add Price",
                        ),
                      ),
                      SizedBox(height: 15),
                      BlocConsumer<CategoryCrudCubit, CategoryCrudState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is CategoryLoading) {
                            return loadingWidget();
                          } else {
                            return CancelAndConfirmDialogButton(
                              onConfirm: () async {
                                if (widget.expense != null) {
                                  await updateCategory(context);
                                } else {
                                  await createNewCategory(context);
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
        ),
      ),
    );
  }

  ///crate category
  Future<void> createNewCategory(BuildContext context) async {
    await context
        .read<ExpenseCrudCubit>()
        .createExpense(ExpenseName: categoryNameController.text,price:int.parse(priceController.text,),sale_record_id: selectedValue!,type: selectedRadio )
        .then(
      (value) {
        if (value) {
          Navigator.pop(context);
          context.read<ExpenseCubit>().getAllExpense();
        }
      },
    );
  }

  ///update category data
  Future<void> updateCategory(BuildContext context) async {
    await context
        .read<ExpenseCrudCubit>()
        .updateExpense(
            name: categoryNameController.text,
            price: int.parse(priceController.text),
            id: widget.expense!.id.toString(),
            type: selectedRadio,
            sale_record_id: selectedValue!
    )
        .then(
      (value) {
        if (value) {
          Navigator.pop(context);
          context.read<ExpenseCubit>().getAllExpense();
        }
      },
    );
  }
}
