import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/data/models/response_models/category_model.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';

class CategoryService {
  BaseApi baseApi;

  CategoryService({required this.baseApi});

  LogService logger = LogService();

  ///create category
  Future<bool> createCategory({
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
        error: 'CategoryService : createCategory',
      );
      throw Exception(e);
    }
  }

  ///delete category
  Future<bool> deleteCategory({
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
  Future<bool> updateCategory({
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
        error: 'CategoryService : updateCategory',
      );
      throw Exception(e);
    }
  }

  ///get all categories list
  Future<List<CategoryModel>> getAllCategories({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      List<CategoryModel> productList = [];

      ResponseModel response = await baseApi.getRequest(
        apiUrl: url,
      );

      var dataList = response.data as List;

      productList = dataList.map((e) => CategoryModel.fromJson(e)).toList();

      return productList;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'CategoryService : getAllCategories',
      );
      throw Exception(e);
    }
  }
}
