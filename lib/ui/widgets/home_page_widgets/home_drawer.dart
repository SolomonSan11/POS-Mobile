import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/ui/pages/choose_language/choose_language.dart';
import 'package:golden_thailand/ui/pages/home.dart';
import 'package:golden_thailand/ui/pages/report/expene_report_page.dart';
import 'package:iconly/iconly.dart';
import 'package:golden_thailand/blocs/auth_cubit/auth_cubit.dart';
import 'package:golden_thailand/blocs/cart_cubit/cart_cubit.dart';
import 'package:golden_thailand/blocs/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/ui/pages/control_panel/control_panel.dart';
import 'package:golden_thailand/ui/pages/order/history.dart';
import 'package:golden_thailand/ui/pages/report/report_page.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, required this.onNavigate});

  final Function() onNavigate;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 400,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear),
                )
              ],
            ),

            Container(height: 160),

            ///control panel
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                redirectTo(context: context, form: ControlPanel());

                onNavigate();
              },
              leading: CircleAvatar(child: Icon(CupertinoIcons.settings)),
              title: Text("${tr(LocaleKeys.lblControlPanel)}"),
            ),
            SizedBox(height: 10),

            ///report
            ListTile(
              onTap: () {
                Navigator.pop(context);
                redirectTo(context: context, form: ReportPage());
                onNavigate();
              },
              leading: CircleAvatar(child: Icon(CupertinoIcons.square_stack)),
              title: Text("${tr(LocaleKeys.lblReport)}"),
            ),
            SizedBox(height: 10),
            ///report
            ListTile(
              onTap: () {
                Navigator.pop(context);
                redirectTo(context: context, form: ExpeneReportPage());
                onNavigate();
              },
              leading: CircleAvatar(child: Icon(CupertinoIcons.square_stack)),
              title: Text("${tr(LocaleKeys.lblExpenseReport)}"),
            ),
            SizedBox(height: 10),

            ///history
            ListTile(
              onTap: () {
                Navigator.pop(context);
                redirectTo(
                  context: context,
                  form: History(),
                );
              },
              leading: CircleAvatar(child: Icon(CupertinoIcons.doc)),
              title: Text("${tr(LocaleKeys.lblHistory)}"),
            ),

            SizedBox(height: 10),

            // // language change process
            ListTile(
              onTap: () async {
                redirectTo(context: context, form: ChooseLanguage());
                // showDialog(
                //   context: context,
                //   builder: (context) {
                //     return _languageDialogBox(context);
                //   },
                // );
              },
              leading: CircleAvatar(
                child: Icon(CupertinoIcons.globe),
              ),
              title: Text("${tr(LocaleKeys.lblChooseLanguage)}"),
            ),

            SizedBox(height: 10),

            ///logout
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return _logoutDialogBox(context);
                  },
                );
              },
              leading: CircleAvatar(
                child: Icon(IconlyLight.logout),
              ),
              title: Text("${tr(LocaleKeys.lblLogout)}"),
            ),
          ],
        ),
      ),
    );
  }

  ///logout dialog box
  Dialog _logoutDialogBox(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.85,
        padding: EdgeInsets.only(
          left: MyPadding.normal,
          right: MyPadding.normal,
          bottom: MyPadding.normal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(bottom: 25, top: 15),
              child: Text(
                "${tr(LocaleKeys.lblLogoutPrompt)}",
                style: TextStyle(
                  color: SScolor.primaryColor,
                  fontSize: FontSize.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: customizableOTButton(
                    bgColor: Colors.white,
                    elevation: 0,
                    height: 60,
                    child: Text("${tr(LocaleKeys.lblCancel)}"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: custamizableElevated(
                    bgColor: SScolor.primaryColor,
                    elevation: 0,
                    height: 60,
                    child: Text("${tr(LocaleKeys.lblLogout)}"),
                    onPressed: () async {
                      logout(context);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///logout process
  void logout(BuildContext context) async {
    bool logoutStatus =
        await context.read<AuthCubit>().logout(context: context);
    if (logoutStatus) {
      context.read<CartCubit>().clearOrderr();
      context.read<EditSaleCartCubit>().clearOrderr();
    }
  }

  // language process
  // ignore: unused_element
  Dialog _languageDialogBox(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.85,
        padding: EdgeInsets.only(
          left: MyPadding.normal,
          right: MyPadding.normal,
          bottom: MyPadding.normal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 25, top: 15),
                  child: Text(
                    "Change Langauge",
                    style: TextStyle(
                      color: SScolor.primaryColor,
                      fontSize: FontSize.normal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            customizableOTButton(
              bgColor: SScolor.primaryColor,
              fgColor: Colors.white,
              elevation: 0,
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Text("English"),
              onPressed: () async {
                await localizationConfig('en', context);
                // Call a method to notify the homepage to rebuild

                Navigator.pop(context);
                context
                    .findAncestorStateOfType<HomeScreenState>()
                    ?.updateLanguage();
              },
            ),
            SizedBox(height: 10),
            customizableOTButton(
              bgColor: SScolor.primaryColor,
              fgColor: Colors.white,
              elevation: 0,
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Text("Myanmar"),
              onPressed: () async {
                await localizationConfig('my', context);

                Navigator.pop(context);
                context
                    .findAncestorStateOfType<HomeScreenState>()
                    ?.updateLanguage();
              },
            ),
            SizedBox(height: 10),
            customizableOTButton(
              bgColor: SScolor.primaryColor,
              fgColor: Colors.white,
              elevation: 0,
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Text("Thailand"),
              onPressed: () async {
                await localizationConfig('en', context);
                context
                    .findAncestorStateOfType<HomeScreenState>()
                    ?.updateLanguage();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future localizationConfig(String code, BuildContext context) async {
  await context.setLocale(Locale(code, ''));
  return code;
}
// Future localizationConfig(String code, BuildContext context) async {
//   SharedPreferences _sharePreference = await SharedPreferences.getInstance();
//   // Save an String value to 'action' key.
//   // Try reading data from the 'action' key. If it doesn't exist, returns null.
//   final String? action =
//       _sharePreference.getString(ApiConst.LOCAL_LANGUAGE_KEY);
//   await context.setLocale(Locale(code, ''));
//   print("check locale key file ::$action");
//   if (action == null || action.isEmpty) {
//     await _sharePreference.setString(ApiConst.LOCAL_LANGUAGE_KEY, code);
//   } else {
//     // Remove data for the 'counter' key.
//     await _sharePreference.remove(ApiConst.LOCAL_LANGUAGE_KEY);
//     await _sharePreference.setString(ApiConst.LOCAL_LANGUAGE_KEY, code);
//   }

//   print("localization config code ; ${code}");

//   return code;
// }
