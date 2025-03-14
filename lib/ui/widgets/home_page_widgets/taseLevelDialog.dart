// // ignore_for_file: must_be_immutable
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:golden_thailand/blocs/ahtone_level_crud_cubit/ahtone_level_crud_cubit.dart';
// import 'package:golden_thailand/blocs/ahtone_level_crud_cubit/ahtone_level_crud_state.dart';
// import 'package:golden_thailand/blocs/spicy_level_crud_cubit/spicy_level_cubit.dart';
// import 'package:golden_thailand/blocs/spicy_level_crud_cubit/spicy_level_state.dart';
// import 'package:golden_thailand/core/size_const.dart';
// import 'package:golden_thailand/ui/widgets/common_widget.dart';
// import 'package:golden_thailand/ui/widgets/custom_dialog.dart';

// class TasteChooseDialog extends StatefulWidget {
//   TasteChooseDialog({super.key});

//   @override
//   State<TasteChooseDialog> createState() => _TasteChooseDialogState();
// }

// class _TasteChooseDialogState extends State<TasteChooseDialog> {
//   String selectedSpicyLevel = "";
//   String selectedAthoneLevel = "";

//   List<SpicyLevelModel> spicyLevels = [];
//   List<AhtoneLevelModel> athoneLevels = [];

//   String errorText = "";

//   @override
//   Widget build(BuildContext context) {
//     var dialogWidth = MediaQuery.of(context).size.width / 3;
//     return CustomDialog(
//       width: dialogWidth,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ahtoneLevelColumn(width: dialogWidth / 2.5),
//                   spicyLevelColumn(width: dialogWidth / 2.5),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               "${errorText}",
//               style: TextStyle(color: Colors.red),
//             ),
//             SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 customizableOTButton(
//                   child: Text("ပယ်ဖျက်ရန်"),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 SizedBox(width: 10),
//                 custamizableElevated(
//                   child: Text("ထည့်ရန်"),
//                   onPressed: () {
//                     addTasteLevels();
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   ///ahtone level column
//   Column ahtoneLevelColumn({required double width}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "အထုံ Level",
//           style: TextStyle(
//             fontSize: FontSize.normal,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(height: 10),
//         BlocBuilder<AhtoneLevelCubit, AhtoneLevelCrudState>(
//           builder: (context, state) {
//             if (state is AhtoneLevelLoaded) {
//               athoneLevels = state.ahtone_level;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ...state.ahtone_level
//                       .map(
//                         (e) => _athoneLevelRadio(
//                           value: e,
//                           width: width,
//                         ),
//                       )
//                       .toList()
//                 ],
//               );
//             }
//             return Container();
//           },
//         ),
//       ],
//     );
//   }

//   ///spicy level column
//   Column spicyLevelColumn({required double width}) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "အစပ် Level",
//           style: TextStyle(
//             fontSize: FontSize.normal,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         SizedBox(height: 10),
//         BlocBuilder<SpicyLevelCubit, SpicyLevelCrudState>(
//           builder: (context, state) {
//             if (state is SpicyLevelLoaded) {
//               spicyLevels = state.spicy_level;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ...state.spicy_level
//                       .map((e) => _spicyLevelRadio(value: e, width: width))
//                       .toList()
//                 ],
//               );
//             }
//             return Container();
//           },
//         ),
//       ],
//     );
//   }

//   ///spicy level radio
//   Widget _spicyLevelRadio({
//     required SpicyLevelModel value,
//     required double width,
//   }) {
//     return Container(
//       width: width,
//       child: RadioListTile(
//         contentPadding: EdgeInsets.zero,
//         value: "${value.id}",
//         groupValue: selectedSpicyLevel,
//         title: Text("${value.name}"),
//         onChanged: (value) {
//           setState(() {
//             selectedSpicyLevel = value!;
//           });
//           print("athone : ${selectedSpicyLevel}");
//         },
//       ),
//     );
//   }

//   ///athone level radio
//   Widget _athoneLevelRadio({
//     required AhtoneLevelModel value,
//     required double width,
//   }) {
//     return Container(
//       width: width,
//       child: RadioListTile(
//         contentPadding: EdgeInsets.zero,
//         value: "${value.id}",
//         title: Text("${value.name}"),
//         groupValue: selectedAthoneLevel,
//         onChanged: (value) {
//           setState(() {
//             selectedAthoneLevel = value!;
//           });
//           print("athone : ${selectedAthoneLevel}");
//         },
//       ),
//     );
//   }

//   ///get selected ahtone level
//   AhtoneLevelModel getSelectedAhtoneLevel(List<AhtoneLevelModel> list) {
//     try {
//       return list.firstWhere(
//           (element) => element.id.toString() == selectedAthoneLevel);
//     } catch (e) {
//       throw Exception();
//     }
//   }

//   ///get selected ahtone level
//   SpicyLevelModel getSelectedSpicyLevel(List<SpicyLevelModel> list) {
//     try {
//       return list
//           .firstWhere((element) => element.id.toString() == selectedSpicyLevel);
//     } catch (e) {
//       throw Exception();
//     }
//   }

//   ///add taste
//   void addTasteLevels() {
//     if (selectedAthoneLevel == "" && selectedSpicyLevel != "") {
//       errorText = "အထုံ Level ရွေးရန် လိုအပ်ပါသည်";
//     } else if (selectedAthoneLevel != "" && selectedSpicyLevel == "") {
//       errorText = "အစပ် Level ရွေးရန် လိုအပ်ပါသည်";
//     } else if (selectedAthoneLevel == "" && selectedSpicyLevel == "") {
//       errorText = "အထုံ Level နှင့် အစပ် Level ရွေးရန် လိုအပ်ပါသည်";
//     } else {
//       errorText = "";
//       try {
//         Navigator.pop(context, {
//           'spicyLevel': getSelectedSpicyLevel(spicyLevels),
//           'athoneLevel': getSelectedAhtoneLevel(athoneLevels),
//         });
//       } catch (e) {
//         print("error : ${e}");
//       }
//     }

//     setState(() {});
//   }
// }
