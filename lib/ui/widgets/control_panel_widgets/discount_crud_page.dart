import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/category_crud_cubit/category_crud_cubit.dart';
import 'package:golden_thailand/blocs/category_cubit/category_cubit.dart';
import 'package:golden_thailand/blocs/discount_cubit/discount_cubit.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/cancel_and_confirm_dialog_button.dart';
import 'package:golden_thailand/ui/widgets/internetCheckWidget.dart';

class DiscountCRUDScreen extends StatefulWidget {
  const DiscountCRUDScreen({super.key, required this.title});
  final String title;

  @override
  State<DiscountCRUDScreen> createState() => _DiscountCRUDScreenState();
}

class _DiscountCRUDScreenState extends State<DiscountCRUDScreen> {
  var numberTextController = TextEditingController();
  // var productPriceController = TextEditingController();
  int? value;
  @override
  void initState() {
    context.read<DiscountCubit>().getNumbers();
    super.initState();
  }
  void getValueForCheckingNumber()async{
    value = int.parse(await context.read<DiscountCubit>().getValue());
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
      floatingActionButton: BlocBuilder<DiscountCubit,DiscountState>(
        builder: (context,state){
          if(state.numbers ==0){
            return FloatingActionButton.extended(
              backgroundColor: SScolor.primaryColor,
              label: Text("${tr(LocaleKeys.lblNewAdd)}"),
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DiscountCRUDScreenDialog(
                      screenSize: screenSize,
                    );
                  },
                );
              },
            );
          }else{
            return Container();
          }
        },
      ),
      body: InternetCheckWidget(
        onRefresh: () {
          context.read<DiscountCubit>().getNumbers();
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
    return BlocBuilder<DiscountCubit, DiscountState>(
      builder: (context, state) {
        if (state.numbers !=0 ) {
          return Container(
            padding: EdgeInsets.only(
              top: MyPadding.normal - 3,
              bottom: MyPadding.normal - 3,
              left: MyPadding.big,
            ),
            width: 300,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${tr(LocaleKeys.lbldiscount)} \n\n ${state.numbers}%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: FontSize.normal,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                Spacer(),
                // InkWell(
                //   onTap: (){
                //
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(16),
                //     child: Icon(
                //       Icons.edit,
                //       size: 20,
                //       color: Colors.blue,
                //     ),
                //   ),
                // ),
                InkWell(
                  onTap: () {
                   context.read<DiscountCubit>().deleteNumbers();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      CupertinoIcons.delete,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          );
        } else {
          return Center(
            child: Text("No Discount"),
          );
        }
      },
    );
  }

  ///delete category warning dialog box
  // Future<dynamic> _deleteWarningDialog({
  //   required BuildContext context,
  //   required Size screenSize,
  //   required String categoryId,
  // }) {
  //   return deleteWarningDialog(
  //     context: context,
  //     screenSize: screenSize,
  //     child: BlocBuilder<CategoryCrudCubit, CategoryCrudState>(
  //       builder: (context, state) {
  //         if (state is CategoryLoading) {
  //           return loadingWidget();
  //         } else {
  //           return CancelAndDeleteDialogButton(
  //             onDelete: () async {
  //               await deleteCategoryData(context, categoryId);
  //             },
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }

  ///delete category
  Future<void> deleteCategoryData(
      BuildContext context,
      String categoryId,
      ) async {
    await context.read<CategoryCrudCubit>().deleteCategory(id: categoryId).then(
          (value) {
        if (value) {
          Navigator.pop(context);
          context.read<CategoriesCubit>().getAllCategories();
        }
      },
    );
  }
}

////category crud dialob box
class DiscountCRUDScreenDialog extends StatefulWidget {
  const DiscountCRUDScreenDialog({
    super.key,
    required this.screenSize,
    this.number
  });

  final Size screenSize;

  final int? number;

  @override
  State<DiscountCRUDScreenDialog> createState() =>
      _DiscountCRUDScreenDialogState();
}

class _DiscountCRUDScreenDialogState extends State<DiscountCRUDScreenDialog> {
  final TextEditingController numberTextController = TextEditingController();


  @override
  void initState() {
    if (widget.number != null) {
      numberTextController.text = widget.number.toString();
    }
    setState(() {});
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
                  ///category name
                  Text(
                    "${tr(LocaleKeys.lbldiscount)}",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    controller: numberTextController,
                    validator: (value) {
                      if (value == "") {
                        return "Number is Empty";
                      }
                      return null;
                    },
                    decoration: customTextDecoration2(
                      labelText: "Add Discount",
                    ),
                  ),

                  SizedBox(height: 15),

                  BlocConsumer<DiscountCubit, DiscountState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                        return CancelAndConfirmDialogButton(
                          onConfirm: () async {
                            if (widget.number != null) {
                              // await updateCategory(context);
                            } else {
                              print("numbertext:${numberTextController.text}");
                              await createNewCategory(context,int.parse(numberTextController.text));
                            }
                          },
                        );
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

  ///crate category
  Future<void> createNewCategory(BuildContext context,int discount) async {
    await context
        .read<DiscountCubit>()
        .createNumber(discount);
    Navigator.pop(context);
    context.read<DiscountCubit>().getNumbers();
  }

  ///update category data
  // Future<void> updateCategory(BuildContext context) async {
  //   await context
  //       .read<CategoryCrudCubit>()
  //       .updateCategory(
  //       name: categoryNameController.text,
  //       description: "",
  //       id: widget.category!.id.toString())
  //       .then(
  //         (value) {
  //       if (value) {
  //         Navigator.pop(context);
  //         context.read<CategoriesCubit>().getAllCategories();
  //       }
  //     },
  //   );
  // }
}
