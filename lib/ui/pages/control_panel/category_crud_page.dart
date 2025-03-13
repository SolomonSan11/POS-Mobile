import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/category_crud_cubit/category_crud_cubit.dart';
import 'package:golden_thailand/blocs/category_cubit/category_cubit.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/data/models/response_models/category_model.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/cancel_and_confirm_dialog_button.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/cancel_and_delete_dialog_button.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/common_crud_card.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/delete_warning_dialog.dart';
import 'package:golden_thailand/ui/widgets/internetCheckWidget.dart';

class CategoryCRUDScreen extends StatefulWidget {
  const CategoryCRUDScreen({super.key, required this.title});
  final String title;

  @override
  State<CategoryCRUDScreen> createState() => _CategoryCRUDScreenState();
}

class _CategoryCRUDScreenState extends State<CategoryCRUDScreen> {
  var categoryNameController = TextEditingController();
  var productPriceController = TextEditingController();

  @override
  void initState() {
    context.read<CategoriesCubit>().getAllCategories();
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
              return CategoryCRUDScreenDialog(
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
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoadingState) {
          return loadingWidget();
        } else if (state is CategoriesLoadedState) {
          return state.categoriesList.length > 0
              ? GridView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20, top: 7.5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: MyPadding.normal,
                    crossAxisSpacing: MyPadding.normal,
                    childAspectRatio: screenSize.width * 0.002,
                  ),
                  itemCount: state.categoriesList.length,
                  itemBuilder: (context, index) {
                    CategoryModel category = state.categoriesList[index];
                    return Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: commonCrudCard(
                        title: category.name.toString(),
                        description: category.description.toString(),
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CategoryCRUDScreenDialog(
                                screenSize: screenSize,
                                category: category,
                              );
                            },
                          );
                        },
                        onDelete: () {
                          _deleteWarningDialog(
                            context: context,
                            screenSize: screenSize,
                            categoryId: category.id.toString(),
                          );
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No Categories Here!",
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
      child: BlocBuilder<CategoryCrudCubit, CategoryCrudState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return loadingWidget();
          } else {
            return CancelAndDeleteDialogButton(
              onDelete: () async {
                await deleteCategoryData(context, categoryId);
              },
            );
          }
        },
      ),
    );
  }

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
class CategoryCRUDScreenDialog extends StatefulWidget {
  const CategoryCRUDScreenDialog({
    super.key,
    required this.screenSize,
    this.category,
  });

  final Size screenSize;

  final CategoryModel? category;

  @override
  State<CategoryCRUDScreenDialog> createState() =>
      _CategoryCRUDScreenDialogState();
}

class _CategoryCRUDScreenDialogState extends State<CategoryCRUDScreenDialog> {
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();

  @override
  void initState() {
    if (widget.category != null) {
      categoryNameController.text = widget.category!.name.toString();
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
                    "${tr(LocaleKeys.lblCategory)}",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    controller: categoryNameController,
                    validator: (value) {
                      if (value == "") {
                        return "Category Name can't be empty";
                      }
                      return null;
                    },
                    decoration: customTextDecoration2(
                      labelText: "Add Category",
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
                            if (widget.category != null) {
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
    );
  }

  ///crate category
  Future<void> createNewCategory(BuildContext context) async {
    await context
        .read<CategoryCrudCubit>()
        .createCategory(categoryName: categoryNameController.text)
        .then(
      (value) {
        if (value) {
          Navigator.pop(context);
          context.read<CategoriesCubit>().getAllCategories();
        }
      },
    );
  }

  ///update category data
  Future<void> updateCategory(BuildContext context) async {
    await context
        .read<CategoryCrudCubit>()
        .updateCategory(
            name: categoryNameController.text,
            description: "",
            id: widget.category!.id.toString())
        .then(
      (value) {
        if (value) {
          Navigator.pop(context);
          context.read<CategoriesCubit>().getAllCategories();
        }
      },
    );
  }
}
