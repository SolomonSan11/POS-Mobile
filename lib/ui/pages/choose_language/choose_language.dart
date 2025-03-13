import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/ui/pages/home.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';

class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({super.key});

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  // Initial language selection, default is English

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        pushAndRemoveUntil(form: HomeScreen(), context: context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 150,
          centerTitle: true,
          leading: appBarLeading(
            onTap: () {
              pushAndRemoveUntil(form: HomeScreen(), context: context);
            },
          ),
          title: Text("${tr(LocaleKeys.lblSetting)}"),
        ),
        body: _mainForm(context),
      ),
    );
  }

  /// Main form
  Container _mainForm(BuildContext context) {
    String selectedLanguage = context.locale.languageCode;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MyPadding.normal, vertical: 5),
      child: Column(
        children: [
          RadioListTile<String>(
            title: Text(
              'English',
              style: TextStyle(fontSize: FontSize.normal),
            ),
            value: 'en',
            groupValue: selectedLanguage,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
                context.setLocale(Locale('en'));// Set locale to English
                storeLocalizationKey('en');
              });
            },
          ),
          RadioListTile<String>(
            title: Text(
              'Myanmar',
              style: TextStyle(
                fontSize: FontSize.normal,
              ),
            ),
            value: 'my',
            groupValue: selectedLanguage,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
                context.setLocale(Locale('my')); // Set locale to Myanmar
                storeLocalizationKey('my');
              });
            },
          ),
          RadioListTile<String>(
            title: Text(
              'Thai',
              style: TextStyle(
                fontSize: FontSize.normal,
              ),
            ),
            value: 'th',
            groupValue: selectedLanguage,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
                context.setLocale(Locale('th')); // Set locale to Myanmar
                storeLocalizationKey('th');
              });
            },
          ),
        ],
      ),
    );
  }
}
