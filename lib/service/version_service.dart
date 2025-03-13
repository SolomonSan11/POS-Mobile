import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';
import 'package:golden_thailand/data/models/response_models/version_model.dart';

class VersionService {
  BaseApi baseApi;

  VersionService({required this.baseApi});

  LogService logger = LogService();

  ///check the lastest version that exist in the server
  Future<AppVersionModel> checkVersion({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      ResponseModel response = await baseApi.getRequest(
        apiUrl: url,
      );

      AppVersionModel appVersionModel = AppVersionModel.fromMap(
        response.data,
      );

      return appVersionModel;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'VersionService : checkVersion',
      );
      throw Exception(e);
    }
  }
}
