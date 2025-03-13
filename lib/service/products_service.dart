import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/data/models/response_models/product_model.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';

class ProductService {
  BaseApi baseApi;

  ProductService({required this.baseApi});

  LogService logger = LogService();

  ///add new product
  Future<bool> addNewProduct({
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
        error: 'ProductService : addNewProduct',
      );

      throw Exception(e);
    }
  }

  ///update product
  Future<bool> updateProduct({
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
        error: 'ProductService : updateProduct',
      );

      throw Exception(e);
    }
  }

  ///delete product
  Future<bool> deleteProduct({
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
        error: 'ProductService : deleteProduct',
      );

      throw Exception(e);
    }
  }

  ///get products by category(GET)
  Future<List<ProductModel>> getProductsByCategory({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      List<ProductModel> productList = [];

      ResponseModel response =
          await baseApi.postRequest(apiUrl: url, requestBody: requestBody);

      var dataList = response.data as List;

      productList = dataList.map((e) => ProductModel.fromMap(e)).toList();

      return productList;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'ProductService : hehe',
      );

      throw Exception(e);
    }
  }

  ///get all products by pagination(POST)
  Future<List<ProductModel>> getPrdoductsByPagination({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      List<ProductModel> productList = [];

      ResponseModel response = await baseApi.postRequest(
        apiUrl: url,
        requestBody: requestBody,
      );

      var dataList = response.data != null ? response.data as List : [];

      productList = dataList.map((e) => ProductModel.fromMap(e)).toList();

      return productList;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'ProductService : getPrdoductsByPagination',
      );

      throw Exception(e);
    }
  }

  ///get all products (GET)
  Future<List<ProductModel>> getAllProducts({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      List<ProductModel> productList = [];

      ResponseModel response =
          await baseApi.getRequest(apiUrl: url);

      var dataList = response.data as List;

      productList = dataList.map((e) => ProductModel.fromMap(e)).toList();

      return productList;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'ProductService : getAllProducts',
      );

      throw Exception(e);
    }
  }

  ///get product by barcode
  Future<ProductModel> getProductByBarcode({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      ResponseModel response =
          await baseApi.getRequest(apiUrl: url);

      ProductModel product = ProductModel.fromMap(response.data);

      return product;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'ProductService : getProductByBarcode',
      );

      throw Exception(e);
    }
  }





}
