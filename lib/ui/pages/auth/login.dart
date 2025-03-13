import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_thailand/blocs/auth_cubit/auth_cubit.dart';
import 'package:golden_thailand/core/locale_keys.g.dart';
import 'package:golden_thailand/core/share_prefs.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/core/app_theme_const.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:golden_thailand/data/models/request_models/shop_login_request_model.dart';
import 'package:golden_thailand/ui/pages/home.dart';
import 'package:golden_thailand/ui/widgets/common_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController _nameController = TextEditingController(text: "");
  TextEditingController _passwordController = TextEditingController(text: "");

  bool obscure = true;

  bool showButtons = true;

  @override
  void initState() {
    super.initState();

    ///to check login status
    context.read<AuthCubit>().checkLoginStatus();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width / 12,
                ),
                color: Colors.white,
                child: _loginForm(
                  screenSize: screenSize,
                  isLogin: true,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(170),
                  height: screenSize.height,
                  color: SScolor.primaryColor,
                  child: Image.asset(
                    "assets/images/transparent_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///login form
  Widget _loginForm({required Size screenSize, required bool isLogin}) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Welcome To",
                style: TextStyle(fontSize: FontSize.semiBig),
              ),
            ),
            Center(
              child: Text(
                "Golden Thailand",
                style: TextStyle(
                  fontSize: FontSize.big + 25,
                  fontWeight: FontWeight.bold,
                  color: SScolor.primaryColor,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 25, top: 25),
              child: Center(
                child: Text(
                  "${tr(LocaleKeys.lblLoginPrompt)}",
                  style: TextStyle(
                    fontSize: FontSize.semiBig - 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            ///shop id
            Text(
              "${tr(LocaleKeys.lblShopId)}",
              style: TextStyle(
                fontSize: FontSize.normal,
              ),
            ),
            SizedBox(height: 5),

            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value == "") {
                  return "Shop ID id required!";
                }
                return null;
              },
              decoration: customTextDecoration(
                labelText: "${tr(LocaleKeys.lblEnterShopId)}",
                prefixIcon: Icon(
                  CupertinoIcons.person_fill,
                  color: SScolor.primaryColor,
                ),
              ),
            ),

            ///password
            SizedBox(height: 20),
            Text(
              "${tr(LocaleKeys.lblPassword)}",
              style: TextStyle(
                fontSize: FontSize.normal,
              ),
            ),
            SizedBox(height: 5),
            TextFormField(
              controller: _passwordController,
              obscureText: obscure,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == "") {
                  return "Password required!";
                }
                return null;
              },
              decoration: customTextDecoration(
                labelText: "${tr(LocaleKeys.lblEnterPassword)}",
                suffixIcon: IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: obscure
                      ? Icon(
                          Icons.visibility,
                          color: SScolor.primaryColor,
                        )
                      : Icon(
                          Icons.visibility_off,
                          color: SScolor.primaryColor,
                        ),
                ),
                prefixIcon: IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.lock_fill,
                    color: SScolor.primaryColor,
                  ),
                ),
              ),
            ),

            SizedBox(height: 25),

            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) async {
                if (state is ShopLoggedInState) {
                  final SharedPref sharedPref = SharedPref();
                  print("Logged in worked");
                  var tokenKey =
                      await sharedPref.getData(key: sharedPref.shop_token);
                  if (tokenKey != "" && state.shop.id != null) {
                    redirectTo(
                      context: context,
                      form: HomeScreen(),
                      replacement: true,
                    );
                  }
                } else if (state is ShopFailedState) {
                  showSnackBar(
                    text: "Username or password was wrong : ${state.error}",
                    context: context,
                  );
                }
              },
              builder: (BuildContext context, AuthState state) {
                if (state is ShopLoadingState) {
                  return loadingWidget();
                } else {
                  return custamizableElevated(
                    width: double.infinity,
                    elevation: 0,
                    height: 63,
                    child: Text("${tr(LocaleKeys.lblLogin)}"),
                    radius: 15,
                    onPressed: () {
                      // redirectTo(context: context, form: HomeScreen());

                      if (_formKey.currentState!.validate()) {
                        if (isLogin) {
                          context.read<AuthCubit>().login(
                                shopLoginRequest: ShopLoginRequest(
                                  username: _nameController.text,
                                  password: _passwordController.text,
                                ),
                              );
                        } else {}
                      }
                    },
                  );
                }
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
