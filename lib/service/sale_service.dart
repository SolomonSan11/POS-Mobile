import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';

class SaleService {
  
  BaseApi baseApi;

  SaleService({required this.baseApi});

  LogService logger = LogService();

  ///make a sale request to the server
  Future<bool> makeSale({
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
        error: 'SaleService : makeSale',
      );
      throw Exception(e);
    }
  }
  // ///make a sale request to the server
  // Future<SaleResponseModel> makeSaleOld({
  //   required String url,
  //   required Map<String, dynamic> requestBody,
  // }) async {
  //   try {
  //     ResponseModel response = await baseApi.postRequest(
  //       apiUrl: url,
  //       requestBody: requestBody,
  //     );

  //     SaleResponseModel saleResponseModel = SaleResponseModel.fromMap(
  //       response.data,
  //     );

  //     return saleResponseModel;
  //   } catch (e) {
  //     logger.logWarning(
  //       "Error log : ${e}",
  //       error: 'SaleService : makeSale',
  //     );
  //     throw Exception(e);
  //   }
  // }
}
