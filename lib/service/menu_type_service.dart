import 'package:golden_thailand/core/logger_singleton.dart';
import 'package:golden_thailand/data/api/base_api.dart';
import 'package:golden_thailand/data/models/menu_type_model.dart';
import 'package:golden_thailand/data/models/response_models/response_model.dart';

class MenuTypeService {
  BaseApi baseApi;

  MenuTypeService({required this.baseApi});

  LogService logger = LogService();

  ///get all MenuType list
  Future<List<MenuTypeModel>> getMenuTypeList({
    required String url,
  }) async {
    try {
      List<MenuTypeModel> MenuTypeList = [];

      ResponseModel response = await baseApi.getRequest(
        apiUrl: url,
      );

      var dataList = response.data as List;

      MenuTypeList = dataList.map((e) => MenuTypeModel.fromMap(e)).toList();

      return MenuTypeList;
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'MenuTypeList : getTableList',
      );
      throw Exception(e);
    }
  }


}
