import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/data/models/response_models/payment_model.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';

class PaymentApiService {
  
  BaseApi baseApi;

  PaymentApiService({required this.baseApi});

  LogService logger = LogService();

  ///make a sale request to the server
  Future<List<PaymentModel>> getPaymentData({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      List<PaymentModel> dataList = [];

      ResponseModel response = await baseApi.getRequest(
        apiUrl: url,
      );

      var data = response.data as List;

      dataList = data.map((e) => PaymentModel.fromMap(e)).toList();

      return dataList;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'PaymentApiService : getPaymentData',
      );
      throw Exception(e);
    }
  }
}
