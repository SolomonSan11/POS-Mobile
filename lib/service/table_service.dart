import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';
import 'package:golden_thailand/data/models/table_model.dart';

class TableService {
  BaseApi baseApi;

  TableService({required this.baseApi});

  LogService logger = LogService();

  ///create remork
  Future<bool> addNewTable({
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
        error: 'TableService : addNewTable',
      );
      throw Exception(e);
    }
  }

  ///delete Table
  Future<bool> deleteTable({
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
        error: 'TableService : deleteTable',
      );
      throw Exception(e);
    }
  }

  ///update Table
  Future<bool> editTable({
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
        error: 'TableService : editTable',
      );
      throw Exception(e);
    }
  }

  ///get all Table list
  Future<List<TableModel>> getTableList({
    required String url,
  }) async {
    try {
      List<TableModel> TableList = [];

      ResponseModel response = await baseApi.getRequest(
        apiUrl: url,
      );

      var dataList = response.data as List;

      TableList = dataList.map((e) => TableModel.fromMap(e)).toList();

      return TableList;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'TableService : getTableList',
      );
      throw Exception(e);
    }
  }


}
