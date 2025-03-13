import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/data/models/expense_report_model.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';
import 'package:golden_thailand/data/models/response_models/sale_record_model.dart';

class ExpenseReportService {
  BaseApi baseApi;

  ExpenseReportService({required this.baseApi});

  static LogService logger = LogService();

  ///the the current VAT
  Future<ExpenseReportModel> getDailySail({
    required String url,
  }) async {
    try {
      ResponseModel response = await baseApi.getRequest(apiUrl: url);

      ExpenseReportModel VAT = ExpenseReportModel.fromMap(response.data);

      return VAT;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'ExpenseReportService : getVAT',
      );
      throw Exception(e);
    }
  }

  ///the report
  Future<ExpenseReportModel> getMontylySale({
    required String url,
  }) async {
    try {
      //ExpenseReportModel? saleReport;
      ResponseModel response = await baseApi.getRequest(apiUrl: url);
      ExpenseReportModel saleReport = ExpenseReportModel.fromMap(response.data);
      return saleReport;
      // if (response.data is List) {
      //   return ExpenseReportModel(
      //     total_paid_cash: 0,
      //     total_paid_online: 0,
      //     total_sales: 0,
      //   );
      // } else {
      //   saleReport = ExpenseReportModel.fromMap(response.data);
      // }

      // return saleReport;
    } catch (e) {
      logger.logWarning(
        "Error log: ${e.toString()}",
        error: 'ExpenseReportService: getReport by: $url',
      );
      rethrow;
    }
  }

  ///the the current VAT
  Future<List<SaleRecordModel>> getSaleRecordWithDate({
    required String url,
  }) async {
    try {
      ResponseModel response = await baseApi.getRequest(apiUrl: url);
      print("check sale record data is ${response.data}");
      var dataList = response.data as List;


      List<SaleRecordModel> VAT =  dataList.map((e) => SaleRecordModel.fromMap(e)).toList();
      return VAT;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'SaleRecordModel : not found data',
      );
      throw Exception(e);
    }
  }
}
