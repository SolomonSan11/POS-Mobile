// import 'package:bloc/bloc.dart';

// import 'package:golden_thailand/blocs/spicy_level_crud_cubit/spicy_level_state.dart';
// import 'package:golden_thailand/data/models/spicy_level.dart';
// import 'package:golden_thailand/service/spicy_level_service.dart';

// class SpicyLevelCubit extends Cubit<SpicyLevelCrudState> {
//   final SpicyLevelService spicyLevelService;

//   SpicyLevelCubit({required this.spicyLevelService})
//       : super(SpicyLevelCrudInitial());

//   ///create category
//   Future<bool> addNewSpicy({
//     required String levelName,
//     required String description,
//     required int position,
//   }) async {
//     emit(SpicyLevelLoading());
//     try {
//       bool status = await spicyLevelService.addSpicyLevel(
//         url: "spicy-level/store",
//         requestBody: {
//           "name": levelName,
//           "description": description,
//           "position": position
//         },
//       );
//       if (status) {
//         emit(SpicyLevelCreated());
//         return true;
//       } else {
//         emit(SpicyLevelError());
//         return false;
//       }
//     } catch (e) {
//       emit(SpicyLevelError());
//       return false;
//     }
//   }

//   ///delete category
//   Future<bool> deleteSpicyLevel({required String id}) async {
//     emit(SpicyLevelLoading());
//     try {
//       bool status = await spicyLevelService.deleteSpicyLevel(
//         url: "spicy-level/delete/${id}",
//         requestBody: {},
//       );
//       if (status) {
//         emit(SpicyLevelDeleted());
//         return true;
//       } else {
//         emit(SpicyLevelError());
//         return false;
//       }
//     } catch (e) {
//       emit(SpicyLevelError());
//       return false;
//     }
//   }

//   ///update category
//   Future<bool> editSpicyLevel({
//     required String id,
//     required String name,
//     required String description,
//     required int position,
//   }) async {
//     emit(SpicyLevelLoading());
//     try {
//       bool status = await spicyLevelService.editSpicyLevel(
//         url: "spicy-level/edit/${id}",
//         requestBody: {
//           "name": "${name}",
//           "description": "${description}",
//           "position": position,
//         },
//       );
//       if (status) {
//         emit(SpicyLevelUpdated());
//         return true;
//       } else {
//         emit(SpicyLevelError());
//         return false;
//       }
//     } catch (e) {
//       emit(SpicyLevelError());
//       return false;
//     }
//   }

//   ///get all products by pagination
//   getAllLevels() async {
//     emit(SpicyLevelLoading());
//     try {
//       List<SpicyLevelModel> levels = await spicyLevelService.getSpicyLevels(
//         url: "spicy-level",
//       );

//       emit(SpicyLevelLoaded(spicy_level: levels));
//     } catch (e) {
//       emit(SpicyLevelError());
//     }
//   }
// }
