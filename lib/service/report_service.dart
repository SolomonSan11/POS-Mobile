import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';
import 'package:golden_thailand/data/models/sale_report_model.dart';

class ReportService {
  BaseApi baseApi;

  ReportService({required this.baseApi});

  static LogService logger = LogService();

  ///the the current VAT
  Future<SaleReportModel> getDailySail({
    required String url,
  }) async {
    try {
      ResponseModel response = await baseApi.getRequest(apiUrl: url);

      SaleReportModel VAT = SaleReportModel.fromMap(response.data);

      return VAT;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'ReportService : getVAT',
      );
      throw Exception(e);
    }
  }

  ///the report
  Future<SaleReportModel> getMontylySale({
    required String url,
  }) async {
    try {
      SaleReportModel? saleReport;
      ResponseModel response = await baseApi.getRequest(apiUrl: url);

      if (response.data is List) {
        return SaleReportModel(
          total_paid_cash: 0,
          total_paid_online: 0,
          total_sales: 0,
        );
      } else {
        saleReport = SaleReportModel.fromMap(response.data);
      }

      return saleReport;
    } catch (e) {
      logger.logWarning(
        "Error log: ${e.toString()}",
        error: 'ReportService: getReport by: $url',
      );
      rethrow;
    }
  }
}
