// import 'package:golden_thailand/core/logger_singleton.dart';
// import 'package:golden_thailand/data/api/base_api.dart';
// import 'package:golden_thailand/data/models/remark_model.dart';
// import 'package:golden_thailand/data/models/response_models/response_model.dart';

// class RemarkService {
//   BaseApi baseApi;

//   RemarkService({required this.baseApi});

//   LogService logger = LogService();

//   ///create remork
//   Future<bool> addNewRemark({
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
//         error: 'RemarkService : addNewRemark',
//       );
//       throw Exception(e);
//     }
//   }

//   ///delete remark
//   Future<bool> deleteRemark({
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
//         error: 'RemarkService : deleteRemark',
//       );
//       throw Exception(e);
//     }
//   }

//   ///update remark
//   Future<bool> editRemark({
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
//         error: 'RemarkService : editRemark',
//       );
//       throw Exception(e);
//     }
//   }

//   ///get all remark list
//   Future<List<RemarkModel>> getRemarkList({
//     required String url,
//   }) async {
//     try {
//       List<RemarkModel> remarkList = [];

//       ResponseModel response = await baseApi.getRequest(
//         apiUrl: url,
//       );

//       var dataList = response.data as List;

//       remarkList = dataList.map((e) => RemarkModel.fromMap(e)).toList();

//       return remarkList;
//     } catch (e) {
//       logger.logWarning(
//         "Error log : ${e}",
//         error: 'RemarkService : getRemarkList',
//       );
//       throw Exception(e);
//     }
//   }


// }
