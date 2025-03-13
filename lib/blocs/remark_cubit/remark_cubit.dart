// import 'package:bloc/bloc.dart';
// import 'package:golden_thailand/blocs/remark_cubit/remark_state.dart';
// import 'package:golden_thailand/data/models/remark_model.dart';
// import 'package:golden_thailand/service/remark_service.dart';

// class RemarkCubit extends Cubit<RemarkState> {
//   final RemarkService remarkService;

//   RemarkCubit({required this.remarkService}) : super(RemarkCrudInitial());

//   ///addNewRemark
//   Future<bool> addNewRemark(
//       {required String levelName, required String description}) async {
//     emit(RemarkLoading());
//     try {
//       bool status = await remarkService.addNewRemark(
//         url: "remark/store",
//         requestBody: {"name": levelName, "description": description},
//       );
//       if (status) {
//         emit(RemarkCreated());
//         return true;
//       } else {
//         emit(RemarkError());
//         return false;
//       }
//     } catch (e) {
//       emit(RemarkError());
//       return false;
//     }
//   }

//   ///delete category
//   Future<bool> deleteRemark({required String id}) async {
//     emit(RemarkLoading());
//     try {
//       bool status = await remarkService.deleteRemark(
//         url: "remark/delete/${id}",
//         requestBody: {},
//       );
//       if (status) {
//         emit(RemarkDeleted());
//         return true;
//       } else {
//         emit(RemarkError());
//         return false;
//       }
//     } catch (e) {
//       emit(RemarkError());
//       return false;
//     }
//   }

//   ///update category
//   Future<bool> editRemark({
//     required String id,
//     required String name,
//     required String description,
//   }) async {
//     emit(RemarkLoading());
//     try {
//       bool status = await remarkService.editRemark(
//         url: "remark/edit/${id}",
//         requestBody: {"name": "${name}", "description": "${description}"},
//       );
//       if (status) {
//         emit(RemarkUpdated());
//         return true;
//       } else {
//         emit(RemarkError());
//         return false;
//       }
//     } catch (e) {
//       emit(RemarkError());
//       return false;
//     }
//   }

//   ///get all products by pagination
//   getAllLevels() async {
//     emit(RemarkLoading());
//     try {
//       List<RemarkModel> levels = await remarkService.getRemarkList(
//         url: "remark",
//       );

//       emit(RemarkLoaded(remarkList: levels));
//     } catch (e) {
//       emit(RemarkError());
//     }
//   }
// }
