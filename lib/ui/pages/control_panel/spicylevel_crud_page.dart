// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:golden_thailand/blocs/spicy_level_crud_cubit/spicy_level_cubit.dart';
// import 'package:golden_thailand/blocs/spicy_level_crud_cubit/spicy_level_state.dart';
// import 'package:golden_thailand/core/app_theme_const.dart';
// import 'package:golden_thailand/core/size_const.dart';
// import 'package:golden_thailand/data/models/spicy_level.dart';
// import 'package:golden_thailand/ui/widgets/common_widget.dart';
// import 'package:golden_thailand/ui/widgets/control_panel_widgets/common_crud_card.dart';
// import 'package:golden_thailand/ui/widgets/control_panel_widgets/delete_warning_dialog.dart';
// import 'package:golden_thailand/ui/widgets/control_panel_widgets/spicy_level_crud_dialog.dart';

// class SpicyLevelScreen extends StatefulWidget {
//   const SpicyLevelScreen({super.key});

//   @override
//   State<SpicyLevelScreen> createState() => _SpicyLevelScreenState();
// }

// class _SpicyLevelScreenState extends State<SpicyLevelScreen> {
//   var spicyLevelController = TextEditingController();
//   var descriptionController = TextEditingController();

//   @override
//   void initState() {
//     context.read<SpicyLevelCubit>().getAllLevels();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: 200,
//         centerTitle: true,
//         leading: appBarLeading(
//           onTap: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text("အစပ် Level"),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: SScolor.primaryColor,
//         label: Text("အစပ်Levelအသစ်ထည့်ရန်"),
//         icon: Icon(Icons.add),
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return SpicyLevelCRUDDialog(screenSize: screenSize);
//             },
//           );
//         },
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: MyPadding.normal,
//         ),
//         child: mainForm(screenSize),
//       ),
//     );
//   }

//   ///main form widget of spicy level
//   Widget mainForm(Size screenSize) {
//     return BlocBuilder<SpicyLevelCubit, SpicyLevelCrudState>(
//       builder: (context, state) {
//         if (state is SpicyLevelLoading) {
//           return loadingWidget();
//         } else if (state is SpicyLevelLoaded) {
//           return GridView.builder(
//             physics: BouncingScrollPhysics(),
//             padding: EdgeInsets.only(bottom: 20, top: 7.5),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4,
//               mainAxisSpacing: MyPadding.normal,
//               crossAxisSpacing: MyPadding.normal,
//               childAspectRatio: screenSize.width * 0.002,
//             ),
//             itemCount: state.spicy_level.length,
//             itemBuilder: (context, index) {
//               SpicyLevelModel spicyLevel = state.spicy_level[index];
//               return Material(
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: commonCrudCard(
//                   title: spicyLevel.name ?? "",
//                   description: spicyLevel.description ?? "",
//                   onEdit: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return SpicyLevelCRUDDialog(
//                           screenSize: screenSize,
//                           SpicyLevel: spicyLevel,
//                         );
//                       },
//                     );
//                   },
//                   onDelete: () {
//                     _deleteWarningDialog(
//                       context: context,
//                       screenSize: screenSize,
//                       spicy_level_id: spicyLevel.id.toString(),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         } else {
//           return Container();
//         }
//       },
//     );
//   }

//   ///delete  warning dialog box
//   Future<dynamic> _deleteWarningDialog({
//     required BuildContext context,
//     required Size screenSize,
//     required String spicy_level_id,
//   }) {
//     return deleteWarningDialog(
//       context: context,
//       screenSize: screenSize,
//       child: BlocBuilder<SpicyLevelCubit, SpicyLevelCrudState>(
//         builder: (context, state) {
//           if (state is SpicyLevelLoading) {
//             return loadingWidget();
//           } else {
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 customizableOTButton(
//                   elevation: 0,
//                   child: Text("ပယ်ဖျက်ရန်"),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 SizedBox(width: 10),
//                 custamizableElevated(
//                   bgColor: Colors.red,
//                   child: Text("ဖျက်မည်"),
//                   onPressed: () async {
//                     await deleteSpicyLevelData(context, spicy_level_id);
//                   },
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }

//   ///delete spicy level data
//   Future<void> deleteSpicyLevelData(
//     BuildContext context,
//     String spicy_level_id,
//   ) async {
//     await context
//         .read<SpicyLevelCubit>()
//         .deleteSpicyLevel(
//           id: spicy_level_id,
//         )
//         .then(
//       (value) {
//         if (value) {
//           Navigator.pop(context);
//           context.read<SpicyLevelCubit>().getAllLevels();
//         }
//       },
//     );
//   }
// }
