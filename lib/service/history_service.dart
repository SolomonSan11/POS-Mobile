import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';
import 'package:golden_thailand/data/models/response_models/sale_history_detail.dart';
import 'package:golden_thailand/data/models/response_models/sale_history_model.dart';
import 'package:golden_thailand/data/models/response_models/sale_total_model.dart';

class HistoryService {
  BaseApi baseApi;

  HistoryService({required this.baseApi});

  LogService logger = LogService();

  ///to get the history by pagination
  Future<List<SaleHistoryModel>> getHistoriesByPagination({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      List<SaleHistoryModel> historyList = [];

      ResponseModel response = await baseApi.getRequest(apiUrl: url);

      var dataList = response.data as List;

      historyList = dataList.map((e) => SaleHistoryModel.fromMap(e)).toList();

      return historyList;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'HistoryService : getHistoriesByPagination',
      );
      throw Exception(e);
    }
  }

  ///search sales history
  Future<List<SaleHistoryModel>> searchSaleHistory({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      List<SaleHistoryModel> historyList = [];

      ResponseModel response = await baseApi.getRequest(
        apiUrl: url,
        //requestBody: requestBody,
      );

      List dataList = response.data as List;

      historyList = dataList.map((e) => SaleHistoryModel.fromMap(e)).toList();

      return historyList.isEmpty ? [] : historyList;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'HistoryService : searchSaleHistory',
      );
      throw Exception(e);
    }
  }

  Future<SaleHistoryDetail> getHistoryDetail({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      List<SaleHistoryDetail> historyList = [];

      ResponseModel response = await baseApi.getBodyRequest(
        apiUrl: url,
        requestBody: requestBody,
      );

      List dataList = response.data as List;

      historyList = dataList.map((e) => SaleHistoryDetail.fromMap(e)).toList();

      return historyList[0];
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'HistoryService : searchSaleHistory',
      );
      throw Exception(e);
    }
  }

  ///delete history
    Future<bool> deleteHistory({
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
        error: 'HistoryService : deleteHistory',
      );
      throw Exception(e);
    }
  }


  ///to total sales and total slip number
  Future<SaleTotalModel> getTotalSaleAndTotalSlip({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      ResponseModel response = await baseApi.getBodyRequest(
        apiUrl: url,
        requestBody: requestBody,
      );

      SaleTotalModel saleTotalModel =
          SaleTotalModel.fromMap(response.data as Map<String, dynamic>);

      return saleTotalModel;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'HistoryService : saleTotalModel',
      );
      throw Exception(e);
    }
  }
}
