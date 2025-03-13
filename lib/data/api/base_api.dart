import 'dart:convert';
import 'package:golden_thailand/core/api_const.dart';
import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/core/share_prefs.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:http/http.dart' as http;

class BaseApi {
  final SharedPref sharedPref;

  BaseApi({required this.sharedPref});

  ///logger http middle ware
  final HttpWithMiddleware _httpClient = HttpWithMiddleware.build(
    middlewares: [
      HttpLogger(
        logLevel: LogLevel.BODY,
      ),
    ],
  );

  LogService logservice = LogService();

  ///get request
  Future<ResponseModel> getRequest({
    required String apiUrl,
  }) async {
    try {
      var responseData;

      String url = "${ApiConst.baseUrl}/${apiUrl}";

      ///get auth token key
      String? token = await sharedPref.getData(key: sharedPref.shop_token);

      final http.Response response = await _httpClient.get(
        Uri.parse("${url}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        responseData = jsonDecode(response.body);

        return ResponseModel(
          status: true,
          msg: responseData["message"],
          data: responseData["data"],
        );
      } else {
        return ResponseModel(
          status: false,
          msg: responseData["message"],
          data: responseData["data"],
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///get body request
  Future<ResponseModel> getBodyRequest({
    required String apiUrl,
    required Map<String, dynamic> requestBody,
  }) async {
    var responseData;

    final Uri uri = Uri.parse("${ApiConst.baseUrl}/${apiUrl}")
        .replace(queryParameters: requestBody);

    try {
      ///get auth token key
      String? token = await sharedPref.getData(key: sharedPref.shop_token);

      final http.Response response = await _httpClient.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        responseData = jsonDecode(response.body);

        return ResponseModel(
          status: true,
          msg: responseData["message"],
          data: responseData["data"],
        );
      } else {
        return ResponseModel(
          status: false,
          msg: responseData["message"],
          data: responseData["data"],
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///post request
  Future<ResponseModel> postRequest({
    required String apiUrl,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      var responseData;

      ///get auth token key
      String? token = await sharedPref.getData(key: sharedPref.shop_token);

      final http.Response response = await _httpClient.post(
        Uri.parse("${ApiConst.baseUrl}/${apiUrl}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        responseData = jsonDecode(response.body);

        return ResponseModel(
          status: true,
          msg: responseData["message"] ?? "",
          data: responseData["data"] ?? null,
        );
      } else {
        return ResponseModel(
          status: false,
          msg: responseData["message"],
          data: responseData["data"] ?? null,
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///delete request
  Future<ResponseModel> deleteRequest({
    required String apiUrl,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      var responseData;

      ///get auth token key
      String? token = await sharedPref.getData(key: sharedPref.shop_token);

      final http.Response response = await _httpClient.delete(
        Uri.parse("${ApiConst.baseUrl}/${apiUrl}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        responseData = jsonDecode(response.body);

        return ResponseModel(
          status: true,
          msg: responseData["message"] ?? "",
          data: responseData["data"] ?? null,
        );
      } else {
        return ResponseModel(
          status: false,
          msg: responseData["message"],
          data: responseData["data"] ?? null,
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
