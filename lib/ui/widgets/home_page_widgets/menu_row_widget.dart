// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
// import 'package:golden_thailand/blocs/products_cubit/products_cubit.dart';
// import 'package:golden_thailand/core/app_theme_const.dart';
// import 'package:golden_thailand/core/size_const.dart';
// import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
// import 'package:golden_thailand/data/models/response_models/menu_model.dart';
// import 'package:golden_thailand/data/models/response_models/product_model.dart';
// import 'package:golden_thailand/ui/widgets/home_page_widgets/taseLevelDialog.dart';

// ///menu row widget
// Widget menuRowWidget({
//   required MenuModel menu,
//   required BuildContext context,
//   required CartItem? defaultItem,
// }) {
//   return BlocBuilder<ProductsCubit, ProductsState>(
//     builder: (context, state) {
//       return Container(
//         margin: EdgeInsets.only(bottom: 100),
//         child: InkWell(
//           highlightColor: SScolor.primaryColor.withOpacity(0.3),
//           onTap: () async {
//             if (menu.is_fish == true) {
//               context.read<CartCubit>().addMenu(menu: menu);
        
//               context.read<CartCubit>().addSpicy(
//                     athoneLevel: null,
//                     spicyLevel: null,
//                   );
//             } else {
//               await showDialog(
//                 context: context,
//                 builder: (context) {
//                   return TasteChooseDialog();
//                 },
//               ).then(
//                 (value) {
//                   if (value != null) {
//                     context.read<CartCubit>().addMenu(menu: menu);
//                     context.read<CartCubit>().addSpicy(
//                           athoneLevel: value["athoneLevel"],
//                           spicyLevel: value["spicyLevel"],
//                         );
        
//                     print("${value["athoneLevel"].id}");
//                     print("${value["athoneLevel"].id}");
        
                    
//                     if (state is ProductsLoadedState) {
//                       checkDefaultProduct(products: state.products,context: context);
//                     }
//                   }
//                 },
//               );
//             }
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: MyPadding.normal),
//             height: 50,
//             width: double.infinity,
//             margin: EdgeInsets.only(bottom: 30),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "${menu.name}",
//                   style: TextStyle(
//                     fontSize: FontSize.normal,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

// ///to check the default product (eg. hinyi/anit)
// CartItem? checkDefaultProduct(
//     {required List<ProductModel> products, required BuildContext context}) {
//   try {
//     ProductModel? defaultProduct =
//         products.where((element) => element.is_default == true).first;
//     print("default product : ${defaultProduct}");
//     CartItem? defaultItem;

//     // ignore: unnecessary_null_comparison
//     if (defaultProduct != null) {
//       defaultItem = CartItem(
//         id: defaultProduct.id!,
//         name: defaultProduct.name.toString(),
//         price: defaultProduct.price ?? 0,
//         qty: 1,
//         totalPrice: defaultProduct.price ?? 0,
//         is_gram: defaultProduct.is_gram ?? false,
//       );

//       context
//           .read<CartCubit>()
//           .addToCartByQuantity(item: defaultItem, quantity: 1);
//     }

//     return defaultItem;
//   } catch (e) {
//     print("error : ${e}");
//     return null;
//   }
// }
