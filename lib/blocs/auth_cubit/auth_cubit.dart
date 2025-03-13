import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:golden_thailand/core/share_prefs.dart';
import 'package:golden_thailand/core/utils.dart';
import 'package:golden_thailand/data/models/request_models/shop_login_request_model.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';
import 'package:golden_thailand/data/models/response_models/shop_model.dart';
import 'package:golden_thailand/service/auth_service.dart';
import 'package:golden_thailand/ui/pages/auth/login.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  final SharedPref sharedPref;

  AuthCubit({required this.authService, required this.sharedPref})
      : super(AuthInitial());

  ///check login status
  checkLoginStatus() async {
    try {
      String authToken = await sharedPref.getData(
        key: sharedPref.shop_token,
      );

      if (authToken.isEmpty || authToken == "") {
        emit(ShopLogoutState());
      } else {
        ShopModel? shop = await authService.checkLoginStatus(
          url: "checkLogin",
        );
        // {{localhost}}/api/checkLogin

        if (shop != null && shop.id != null && shop.username != null) {
          emit(ShopLoggedInState(shop: shop));
        } else {
          emit(ShopLogoutState());
        }
      }
    } catch (e) {
      emit(ShopLogoutState());
    }
  }

  //login with shop id
  login({required ShopLoginRequest shopLoginRequest}) async {
    emit(ShopLoadingState());
    try {
      ShopModel shop = await authService.loginWithShop(
        url: "login",
        shopLoginRequest: shopLoginRequest,
      );

      sharedPref.setData(
        value: shop.access_token.toString(),
        key: sharedPref.shop_token,
      );

      emit(ShopLoggedInState(shop: shop));
    } catch (e) {
      emit(ShopFailedState(error: '${e}'));
    }
  }

  ///logout shop account
  Future<bool> logout({required BuildContext context}) async {
    try {
      ResponseModel? response = await authService.logout(
        url: "logout",
      );

      if (response.status) {
        sharedPref.setData(key: sharedPref.shop_token, value: "");
        pushAndRemoveUntil(context: context, form: Login());
        emit(ShopLogoutState());
      }

      return response.status;
    } catch (e) {
      emit(ShopLogoutState());

      return false;
    }
  }
}
