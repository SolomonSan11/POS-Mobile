import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/discount_cubit/discount_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';

///widget that shows total and VAT
// Widget totalAndVATHomeWidget({required CartCubit cartCubit,}) {
//   num grandTotal =
//       get7percentage(cartCubit.getTotalAmount()) + cartCubit.getTotalAmount();
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: MyPadding.normal),
//     child: Column(
//       children: [
//         Container(
//           margin: EdgeInsets.only(bottom: 15, top: 5),
//           child: Divider(
//             height: 1,
//             thickness: 0.5,
//             color: SScolor.greyColor,
//           ),
//         ),
//
//         SizedBox(height: 5),
//
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 "${tr(LocaleKeys.lblSubtotal)}",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: FontSize.normal,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   "${NumberFormat('#,##0').format(cartCubit.getTotalAmount())} THB",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: FontSize.normal,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//
//         // Discount
//
//         SizedBox(height: 5),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 "${tr(LocaleKeys.lbldiscount)}",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: FontSize.normal,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   "${NumberFormat('#,##0').format(cartCubit.getTotalAmount())} %",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: FontSize.normal,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//
//         ///VAT
//         SizedBox(height: 5),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 "${tr(LocaleKeys.lblVAT)}(7%)",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: FontSize.normal,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   "${formatNumber(get7percentage(cartCubit.getTotalAmount()))}THB",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: FontSize.normal,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//
//         ///grand total
//         SizedBox(height: 5),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 "${tr(LocaleKeys.lblGrandTotal)}",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: FontSize.normal,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   "${NumberFormat('#,##0').format(grandTotal)} THB",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: FontSize.normal,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
Widget totalAndVATHomeWidget({
  required BuildContext context,
  required CartCubit cartCubit,
  required int? discount,
}) {
  int totalAmount = cartCubit.getTotalAmount();

  return FutureBuilder<int>(
    future: calculateDiscount(context, totalAmount),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
  
      int discountedTotall = snapshot.data!;
      int vatAmount = get7percentage(discountedTotall);
      int grandTotal = vatAmount + discountedTotall;
      print("d error lrrr:${discountedTotall}");
      print("vat total:${vatAmount}");
      print("grandTotal:${grandTotal}");
      return Container(
        padding: EdgeInsets.symmetric(horizontal: MyPadding.normal),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 15, top: 5),
              child: Divider(
                height: 1,
                thickness: 0.5,
                color: SScolor.greyColor,
              ),
            ),
            SizedBox(height: 5),

            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${tr(LocaleKeys.lblSubtotal)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.normal,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${NumberFormat('#,##0').format(totalAmount)} THB",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Discount
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${tr(LocaleKeys.lbldiscount)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.normal,
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<DiscountCubit, DiscountState>(
                    builder: (context, state) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${state.numbers} %",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // // VAT
            // SizedBox(height: 5),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       child: Text(
            //         "${tr(LocaleKeys.lblVAT)}(7%)",
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: FontSize.normal,
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: Align(
            //         alignment: Alignment.centerRight,
            //         child: Text(
            //           "${NumberFormat('#,##0').format(vatAmount)} THB",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: FontSize.normal,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            // Grand Total
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${tr(LocaleKeys.lblGrandTotal)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.normal,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${NumberFormat('#,##0').format(grandTotal)} THB",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
