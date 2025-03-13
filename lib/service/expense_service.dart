import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/data/models/response_models/expense_model.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';

class ExpenseService {
  BaseApi baseApi;

  ExpenseService({required this.baseApi});

  LogService logger = LogService();

  ///create category
  Future<bool> createExpense({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      ResponseModel response = await baseApi.postRequest(
        apiUrl: url,
        requestBody: requestBody,
      );

      return response.status;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'ExpenseService : createExpense',
      );
      throw Exception(e);
    }
  }

  ///delete category
  Future<bool> deleteExpense({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      ResponseModel response = await baseApi.deleteRequest(
        apiUrl: url,
        requestBody: requestBody,
      );

      return response.status;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'CategoryService : deleteCategory',
      );
      throw Exception(e);
    }
  }

  ///update category
  Future<bool> updateExpense({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      ResponseModel response = await baseApi.postRequest(
        apiUrl: url,
        requestBody: requestBody,
      );

      return response.status;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'ExpenseService : ExpenseList',
      );
      throw Exception(e);
    }
  }

  ///get all categories list
  Future<List<ExpenseModel>> getAllExpenses({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      List<ExpenseModel> productList = [];

      ResponseModel response = await baseApi.getRequest(
        apiUrl: url,
      );

      var dataList = response.data as List;

      productList = dataList.map((e) => ExpenseModel.fromJson(e)).toList();

      return productList;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'ExpenseService : getAllExpenses',
      );
      throw Exception(e);
    }
  }
}
