import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/category_cubit/category_cubit.dart';
import 'package:golden_thailand/blocs/product_crud_cubit/product_crud_cubit.dart';
import 'package:golden_thailand/blocs/products_cubit/products_cubit.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/response_models/product_model.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';
import 'package:golden_thailand/ui/widgets/control_panel_widgets/cancel_and_confirm_dialog_button.dart';

////products crud dialob box
class ProductCRUDDialog extends StatefulWidget {
  const ProductCRUDDialog({
    super.key,
    required this.screenSize,
    this.product,
  });

  final Size screenSize;

  final ProductModel? product;

  @override
  State<ProductCRUDDialog> createState() => _ProductCRUDDialogState();
}

class _ProductCRUDDialogState extends State<ProductCRUDDialog> {
  final TextEditingController productnameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productNumberController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(text: "1");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.product != null) {
      productnameController.text = widget.product!.name.toString();
      productPriceController.text = widget.product!.price.toString();
      productNumberController.text = widget.product!.product_number.toString();
      selectedCategoryId = widget.product!.category_id;
      category = widget.product!.category ?? "";
      isGram = widget.product!.is_gram;
      isBuffet = widget.product!.is_buffet == 1 ? true : false;
      is_default = widget.product!.is_default ?? false;
      quantityController.text = widget.product!.qty.toString();

      print("selected category id : ${selectedCategoryId}");
    }
    setState(() {});
    super.initState();
  }

  bool isGram = false;
  bool isBuffet = false;
  int? selectedCategoryId;
  bool is_default = false;
  String category = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(MyPadding.big - 10),
          width: widget.screenSize.width / 3.8,
          child: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              padding: EdgeInsets.all(MyPadding.normal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///product name
                  Text(
                    "${tr(LocaleKeys.lblProductName)}",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),

                  SizedBox(height: 5),
                  TextFormField(
                    controller: productnameController,
                    validator: (value) {
                      if (value == "") {
                        return "Product Name can't be empty";
                      }
                      return null;
                    },
                    decoration: customTextDecoration2(
                      labelText: "Enter new product name",
                    ),
                  ),
                  SizedBox(height: 15),

                  ///product price
                  Text(
                    "${tr(LocaleKeys.lblPrice)}",
                    //"Price",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),

                  SizedBox(height: 5),
                  TextFormField(
                    controller: productPriceController,
                    validator: (value) {
                      if (value == "") {
                        return "Product Price can't be empty";
                      }
                      return null;
                    },
                    decoration: customTextDecoration2(
                      labelText: "Enter price",
                    ),
                  ),

                  SizedBox(height: 15),

                  ///product number
                  Text(
                    "${tr(LocaleKeys.lblProductNumber)}",
                    //"Price",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),

                  SizedBox(height: 5),
                  TextFormField(
                    controller: productNumberController,
                    // validator: (value) {
                    //   if (value == "") {
                    //     return "Product Number can't be empty";
                    //   }
                    //   return null;
                    // },
                    decoration: customTextDecoration2(
                      labelText: "${tr(LocaleKeys.lblProductNumber)}",
                    ),
                  ),

                  SizedBox(height: 15),
                  Text(
                    "${tr(LocaleKeys.lblCategory)}",
                    //"Category",
                    style: TextStyle(
                      fontSize: FontSize.normal,
                    ),
                  ),
                  SizedBox(height: 5),
                  BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, state) {
                      if (state is CategoriesLoadedState) {
                        return DropdownButtonFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusColor: SScolor.greyColor,
                            hintText: "${category}",
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 0.5,
                                color: SScolor.greyColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 0.5,
                                color: SScolor.greyColor,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 1,
                                color: SScolor.primaryColor,
                              ),
                            ),
                          ),
                          value: selectedCategoryId,
                          items: state.categoriesList
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text("${e.name}"),
                                  value: e.id,
                                ),
                              )
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoryId = newValue;
                              print(
                                  "selected category id : ${selectedCategoryId}");
                            });
                          },
                          validator: (value) {
                            if (selectedCategoryId == null) {
                              return 'Please select category';
                            }
                            return null;
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),

                  ///is gran field
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isGram = !isGram;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          isGram
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isGram ? SScolor.primaryColor : Colors.grey,
                        ),
                        SizedBox(width: 10),
                        Text("${tr(LocaleKeys.lblIsGram)}")
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isBuffet = !isBuffet;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          isBuffet
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isBuffet ? SScolor.primaryColor : Colors.grey,
                        ),
                        SizedBox(width: 10),
                        Text("${tr(LocaleKeys.lblIsBuffet)}")
                      ],
                    ),
                  ),

                  ///is default field
                  SizedBox(height: 15),

                  BlocBuilder<ProductCrudCubit, ProductCrudState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return loadingWidget();
                      } else {
                        return CancelAndConfirmDialogButton(
                          onConfirm: () async {
                            if (_formKey.currentState!.validate()) {
                              if (widget.product != null) {
                                editProduct(
                                    product_id: widget.product!.id.toString());
                              } else {
                                createNewProduct();
                              }
                            }
                          },
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///create new product
  void createNewProduct() async {
    String code = await getLocalizationKey();
    await context
        .read<ProductCrudCubit>()
        .addNewProduct(
          product: ProductModel(
              category_id: selectedCategoryId ?? 000,
              is_gram: isGram,
              is_buffet: isBuffet ? 1 : 0,
              name: productnameController.text,
              price: int.parse(
                productPriceController.text,
              ),
              qty: 1,
              is_default: is_default,
              language: code,
              product_number: productNumberController.text),
        )
        .then(
      (value) {
        if (value) {
          context.read<ProductsCubit>().getAllProducts();
          Navigator.pop(context);
        }
      },
    );
  }

  ///edit product
  void editProduct({required String product_id}) async {
    String code = await getLocalizationKey();
    await context
        .read<ProductCrudCubit>()
        .updateProduct(
          product: ProductModel(
              category_id: selectedCategoryId ?? 000,
              is_gram: isGram,
              is_buffet: isBuffet ? 1 : 0,
              name: productnameController.text,
              is_default: is_default,
              price: int.parse(
                productPriceController.text,
              ),
              qty: int.parse(
                quantityController.text,
              ),
              language: code,
              product_number: productNumberController.text),
          id: product_id,
        )
        .then(
      (value) {
        if (value) {
          context.read<ProductsCubit>().getAllProducts();
          Navigator.pop(context);
        }
      },
    );
  }
}
