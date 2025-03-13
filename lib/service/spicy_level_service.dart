// import 'package:golden_thailand/core/logger_singleton.dart';
// import 'package:golden_thailand/data/api/base_api.dart';
// import 'package:golden_thailand/data/models/response_models/response_model.dart';
// import 'package:golden_thailand/data/models/spicy_level.dart';

// class SpicyLevelService {
//   BaseApi baseApi;

//   SpicyLevelService({required this.baseApi});

//   LogService logger = LogService();

//   ///create ahtone
//   Future<bool> addSpicyLevel({
//     required String url,
//     required Map<String, dynamic> requestBody,
//   }) async {
//     try {
//       ResponseModel response = await baseApi.postRequest(
//         apiUrl: url,
//         requestBody: requestBody,
//       );

//       return response.status;
//     } catch (e) {
//       logger.logWarning(
//         "Error log : ${e}",
//         error: 'SpicyLevelService : addSpicyLevel',
//       );
//       throw Exception(e);
//     }
//   }

//   ///delete ahtone
//   Future<bool> deleteSpicyLevel({
//     required String url,
//     required Map<String, dynamic> requestBody,
//   }) async {
//     try {
//       ResponseModel response = await baseApi.deleteRequest(
//         apiUrl: url,
//         requestBody: requestBody,
//       );

//       return response.status;
//     } catch (e) {
//       logger.logWarning(
//         "Error log : ${e}",
//         error: 'SpicyLevelService : deleteSpicyLevel',
//       );
//       throw Exception(e);
//     }
//   }

//   ///update ahtone
//   Future<bool> editSpicyLevel({
//     required String url,
//     required Map<String, dynamic> requestBody,
//   }) async {
//     try {
//       ResponseModel response = await baseApi.postRequest(
//         apiUrl: url,
//         requestBody: requestBody,
//       );

//       return response.status;
//     } catch (e) {
//       logger.logWarning(
//         "Error log : ${e}",
//         error: 'SpicyLevelService : editSpicyLevel',
//       );
//       throw Exception(e);
//     }
//   }

//   ///get all AthoneLevels list
//   Future<List<SpicyLevelModel>> getSpicyLevels({
//     required String url,
//   }) async {
//     try {
//       List<SpicyLevelModel> productList = [];

//       ResponseModel response = await baseApi.getRequest(
//         apiUrl: url,
//       );

//       var dataList = response.data as List;

//       productList = dataList.map((e) => SpicyLevelModel.fromMap(e)).toList();

//       return productList;
//     } catch (e) {
//       logger.logWarning(
//         "Error log : ${e}",
//         error: 'SpicyLevelService : getSpicyLevels',
//       );
//       throw Exception(e);
//     }
//   }


// }
