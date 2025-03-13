import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_thailand/blocs/discount_cubit/discount_cubit.dart';
import 'package:golden_thailand/core/api_const.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/share_prefs.dart';
import 'package:golden_thailand/data/models/response_models/cart_item_model.dart';
import 'package:golden_thailand/data/models/response_models/sale_history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

///to navigate to other page
Future<dynamic> redirectTo({
  required BuildContext context,
  bool replacement = false,
  required Widget form,
}) async {
  if (replacement) {
    return await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => form));
  } else {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => form));
  }
}

///to remove all the previous page and navigate to new page
pushAndRemoveUntil({required Widget form, required BuildContext context}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => form),
    (route) => false,
  );
}

///show snack bar at the bottom of the page
void showSnackBar({required String text, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: SScolor.primaryColor,
      content: Text(
        "${text}",
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 1),
    ),
  );
}

bool checkBuffet({
  required List<CartItem> list,
}) {
  return list.any(
    (e) => e.name.toLowerCase().contains("buffet") || e.is_buffet == 1,
  );
}

bool checkBuffet2({
  required List<SaleProduct> list,
}) {
  return list.any(
    (e) => e.name.toLowerCase().contains("buffet") || e.is_buffet == 1,
  );
}

///to get the current language of the app
String getCurrentLanguageCode(BuildContext context) {
  Locale _selectedLocale = Localizations.localeOf(context);
  return _selectedLocale.languageCode;
}

bool isThaiLanguage(BuildContext context) {
  return getCurrentLanguageCode(context) == "th";
}

///calculate the percentage of a number
num calculatePercentage(num totalAmount, num percentage) {
  return (totalAmount * percentage) / 100;
}

Future<int> calculateDiscount(BuildContext context, int totalAmount) async {
  int? discountAmount =
      int.parse(await context.read<DiscountCubit>().getValue());
  print("0 pyit lrr kyi sannnn hyg :${discountAmount}");
  int num = (totalAmount * (1 - discountAmount / 100)).toInt();
  return num;
}

int get7percentage(int totalAmount) {
  return (totalAmount * 0) ~/ 100;
  // return (totalAmount * (1 + 7 / 100)).toInt();
}

///show custom snackbar
void showCustomSnackbar({
  required BuildContext context,
  required String message,
}) {
  IconSnackBar.show(
    backgroundColor: SScolor.primaryColor,
    //snackBarStyle: SnackBarStyle(),
    context,
    snackBarType: SnackBarType.fail,
    label: '${message}',
    behavior: SnackBarBehavior.floating,
  );
}

void storeLocalizationKey(String key) async {
  SharedPreferences _sharePref = await SharedPreferences.getInstance();
  String? code = await _sharePref.getString(ApiConst.LOCAL_LANGUAGE_KEY);

  if (code != null) {
    await _sharePref.remove(ApiConst.LOCAL_LANGUAGE_KEY);
    await _sharePref.setString(ApiConst.LOCAL_LANGUAGE_KEY, key);
  } else {
    await _sharePref.setString(ApiConst.LOCAL_LANGUAGE_KEY, key);
  }

  print(
      "check is save or not::${await _sharePref.getString(ApiConst.LOCAL_LANGUAGE_KEY)}");
}

Future<String> getLocalizationKey() async {
  //SharedPreferences _sharePref = await SharedPreferences.getInstance();
  //String? code = await _sharePref.getString(ApiConst.LOCAL_LANGUAGE_KEY);
  SharedPref sharedPref = GetIt.instance<SharedPref>();
  String? code = await sharedPref.getData(key: ApiConst.LOCAL_LANGUAGE_KEY);
  if (code != "") {
    return code ?? 'en';
  }
  return code ?? 'en';
}

/// generate random id
String generateRandomId(int length) {
  final Random random = Random();
  const int maxDigit = 9;

  String generateDigit() => random.nextInt(maxDigit + 1).toString();

  return List.generate(length, (_) => generateDigit()).join();
}

String formatDate(String? dateString) {
  print("Debug: dateString = $dateString"); // Debug log for testing

  if (dateString == null || dateString.isEmpty) {
    return "No Date Available"; // Null or empty string
  }

  try {
    DateTime parsedDate =
        DateTime.parse(dateString); // Convert string to DateTime
    return DateFormat('dd MMM yyyy').format(parsedDate); // Format the DateTime
  } catch (e) {
    print("Error parsing date: $e"); // Log parsing error
    return "Invalid Date Format";
  }
}

///to format number with , and remove .0
String formatNumber(num number) {
  String formatted = NumberFormat('#,##0.#').format(number);

  if (formatted.contains('.')) {
    formatted = formatted.replaceAll(RegExp(r'(?<=\d)0*$'), '');
  }

  return formatted;
}

int getPriceByGrama({required int weight, required int priceGap}) {
  int range = (weight / 100).ceil();

  int price = range * priceGap;

  return price;
}

int getPriceByGram({required int weight, required int priceGap}) {
  return ((weight / 100) * priceGap).ceil();
}

///print out
Future<bool> printReceipt({
  required int tableNumber,
  required String orderNumber,
  required String date,
  required List<CartItem> products,
  required int discountAmount,
  required int subTotal,
  required int grandTotal,
  required int cashAmount,
  required int PromptAmount,
  required String remark,
  required int VATAmount,
  required int dine_in_or_percel,
  required String paymentType,
  Uint8List? image,
  required int refund,
  required time,
  required int discount,
  required bool isBuffet,
}) async {
  try {
    String text = "";
    Uint8List encodedText = Uint8List.fromList(utf8.encode(text));
    Uint8List noWrapCommand = Uint8List.fromList([0x1B, 0x33, 0x00]);
    await SunmiPrinter.printRawData(noWrapCommand);
    await SunmiPrinter.printRawData(encodedText);

    print("date : date -> ${date}");
    print("voucher : VAT amount -> ${VATAmount}");
    print("voucher : Sub total -> ${subTotal}");
    print("voucher : Grand total -> ${grandTotal}");
    print("voucher : Cash amount -> ${cashAmount}");
    print("voucher : Prompt amount -> ${PromptAmount}");
    print("voucher : table -> ${tableNumber}");
    print("voucher : imagge -> ${image}");
    print("refund : refund -> ${refund}");
    print("D mr kyi sann pr 0 pyit lrr : discount -> ${discountAmount}");
    print("time : time -> ${time}");
    print("isBufffet : isBufffet -> ${isBuffet}");

    //final converter = ZawGyiConverter();

    await SunmiPrinter.initPrinter();

    await SunmiPrinter.startTransactionPrint(true);

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    await SunmiPrinter.printText(
      'Golden Thailand',
      style:
          SunmiStyle(align: SunmiPrintAlign.CENTER, fontSize: SunmiFontSize.LG),
    );

    await SunmiPrinter.setCustomFontSize(23);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'Order Number',
        width: 17,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: ':',
        width: 2,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: '${orderNumber}',
        width: 25,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'Table Number',
        width: 17,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: ':',
        width: 2,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: '${tableNumber}',
        width: 25,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'Date',
        width: 17,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: ':',
        width: 2,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: '${date}',
        width: 25,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'Duration Time',
        width: 17,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: ':',
        width: 2,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: '${time}',
        width: 25,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);

    await SunmiPrinter.printText("");

    await SunmiPrinter.setCustomFontSize(23);

    await SunmiPrinter.printRow(cols: [
      dine_in_or_percel == 0
          ? ColumnMaker(
              text: isBuffet ? "Take Away (Buffet)" : "Take Away",
              width: 35,
              align: SunmiPrintAlign.LEFT,
            )
          : ColumnMaker(
              text: isBuffet ? "Dine In (Buffet)" : "Dine In",
              width: 35,
              align: SunmiPrintAlign.LEFT,
            ),
    ]);

    await SunmiPrinter.printText("Remark : ${remark}");
    await SunmiPrinter.lineWrap(1);

    //await SunmiPrinter.printText("");
    await SunmiPrinter.printText(
      "----------------------------------------------",
    );

    await SunmiPrinter.setCustomFontSize(22);

    await SunmiPrinter.printRow(
      cols: [
        ColumnMaker(
          text: "Product",
          width: 25,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "Qty",
          width: 10,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: 'Price',
          width: 6,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: "Amount",
          width: 9,
          align: SunmiPrintAlign.RIGHT,
        ),
      ],
    );

    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.setCustomFontSize(22);

    products.forEach((e) async {
      ///type 3
      SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: utf8.decode(e.name.runes.toList()),
          width: 25,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: e.is_gram ? '${e.qty}g' : '${e.qty}',
          width: 10,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: "${e.price}",
          width: 6,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: "${formatNumber(e.totalPrice)}",
          width: 9,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
    });
//     void mockSunmiPrintRow(List<ColumnMaker> cols) {
//   print("🖨️ Mock Sunmi Printer Output:");
//   for (var col in cols) {
//     print("${col.text}".padRight(col.width)); // Print Column Text
//   }
// }

//   void printReceiptPreview(String text) {
//   print('🖨️ Printing Receipt Preview:');
//   print(utf8.decode(text.runes.toList())); // UTF-8 Convert
// }

    await SunmiPrinter.setFontSize(SunmiFontSize.SM);
    await SunmiPrinter.setCustomFontSize(23);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText(
      "----------------------------------------------",
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
      ),
    );

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: '${tr(LocaleKeys.lblSubtotal)}',
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: '${formatNumber(subTotal)} THB',
        width: 26,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: '${tr(LocaleKeys.lblDiscountAmt)}',
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: '${formatNumber(discountAmount)} THB',
        width: 26,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);

    // await SunmiPrinter.printRow(cols: [
    //   ColumnMaker(
    //     text: '${tr(LocaleKeys.lbldiscount)}',
    //     width: 20,
    //     align: SunmiPrintAlign.LEFT,
    //   ),
    //   ColumnMaker(
    //     text: '${discount} %',
    //     width: 26,
    //     align: SunmiPrintAlign.RIGHT,
    //   ),
    // ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: '${tr(LocaleKeys.lblGrandTotal)}',
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: '${formatNumber(grandTotal)} THB',
        width: 26,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);

    refund > 0
        ? await SunmiPrinter.printRow(cols: [
            ColumnMaker(
              text: '${tr(LocaleKeys.lblRefund)}',
              width: 20,
              align: SunmiPrintAlign.LEFT,
            ),
            ColumnMaker(
              text: '${formatNumber(refund)} THB',
              width: 26,
              align: SunmiPrintAlign.RIGHT,
            ),
          ])
        : await SunmiPrinter.printRow(cols: []);

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.lineWrap(1);

    cashAmount > PromptAmount
        ? await SunmiPrinter.printRow(cols: [
            ColumnMaker(
              text: 'Cash ',
              width: 25,
              align: SunmiPrintAlign.LEFT,
            ),
            ColumnMaker(
              text: '${cashAmount} THB',
              width: 20,
              align: SunmiPrintAlign.RIGHT,
            ),
          ])
        : await SunmiPrinter.printRow(
            cols: [
              ColumnMaker(
                text: 'Prompt Pay ',
                width: 25,
                align: SunmiPrintAlign.LEFT,
              ),
              ColumnMaker(
                text: '${PromptAmount} THB',
                width: 20,
                align: SunmiPrintAlign.RIGHT,
              ),
            ],
          );

    await SunmiPrinter.printText("");

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    await SunmiPrinter.printText("");
    await SunmiPrinter.printText(
      "----------THANK YOU----------",
      style: SunmiStyle(
        align: SunmiPrintAlign.CENTER,
        fontSize: SunmiFontSize.MD,
      ),
    );

    if (image != null) {
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printImage(
        image,
      );
    }

    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

    await SunmiPrinter.cut();
    await SunmiPrinter.exitTransactionPrint(true);

    return true;
  } catch (e) {
    return false;
  }
}
