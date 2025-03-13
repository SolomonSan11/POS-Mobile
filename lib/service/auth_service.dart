import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/data/models/request_models/shop_login_request_model.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';
import 'package:golden_thailand/data/models/response_models/shop_model.dart';

class AuthService {

  BaseApi baseApi;

  AuthService({required this.baseApi});
  
  static LogService logger = LogService();

  ///check login status
  Future<ShopModel?> checkLoginStatus({
    required String url,
  }) async {
    try {
      ResponseModel response = await baseApi.getRequest(
        apiUrl: url,
      
      );

      ShopModel shopData = ShopModel.fromMap(response.data);

      return shopData;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'AuthService : checkLoginStatus',
      );
      throw Exception(e);
    }
  }

  ///logged in with shop data
  Future<ShopModel> loginWithShop({
    required String url,
    required ShopLoginRequest shopLoginRequest,
  }) async {
    try {
      ResponseModel response = await baseApi.postRequest(
        apiUrl: url,
        requestBody: shopLoginRequest.toMap(),
      );

      ShopModel shopData = ShopModel.fromMap(response.data);

      return shopData;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'AuthService : login',
      );
      throw Exception(e);
    }
  }
  ///logged in with shop data
  Future<ShopModel> register({
    required String url,
    required ShopLoginRequest shopLoginRequest,
  }) async {
    try {
      ResponseModel response = await baseApi.postRequest(
        apiUrl: url,
        requestBody: shopLoginRequest.toMap(),
      );

      ShopModel shopData = ShopModel.fromMap(response.data);

      return shopData;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'AuthService : register',
      );
      throw Exception(e);
    }
  }

  ///logged in with shop data
  Future<ResponseModel> logout({
    required String url,
  }) async {
    try {
      ResponseModel response = await baseApi.postRequest(
        apiUrl: url,
        requestBody: {},
      );

      return response;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'AuthService : logout',
      );
      throw Exception(e);
    }
  }
}
