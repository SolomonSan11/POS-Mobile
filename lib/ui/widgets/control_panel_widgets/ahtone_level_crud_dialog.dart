// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:golden_thailand/blocs/ahtone_level_crud_cubit/ahtone_level_crud_cubit.dart';
// import 'package:golden_thailand/blocs/ahtone_level_crud_cubit/ahtone_level_crud_state.dart';
// import 'package:golden_thailand/core/size_const.dart';
// import 'package:golden_thailand/data/models/ahtone_level_model.dart';
// import 'package:golden_thailand/ui/widgets/common_widget.dart';
// import 'package:golden_thailand/ui/widgets/custom_dialog.dart';

// ////category crud dialob box
// class AhtoneLevelCRUDDialog extends StatefulWidget {
//   const AhtoneLevelCRUDDialog({
//     super.key,
//     required this.screenSize,
//     this.ahtoneLevel,
//   });

//   final Size screenSize;

//   final AhtoneLevelModel? ahtoneLevel;

//   @override
//   State<AhtoneLevelCRUDDialog> createState() => _AhtoneLevelCRUDDialogState();
// }

// class _AhtoneLevelCRUDDialogState extends State<AhtoneLevelCRUDDialog> {
//   final TextEditingController ahtoneLevelController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController positionController = TextEditingController();

//   @override
//   void initState() {
//     if (widget.ahtoneLevel != null) {
//       ahtoneLevelController.text = widget.ahtoneLevel!.name.toString();
//       descriptionController.text = widget.ahtoneLevel!.description.toString();
//       positionController.text = widget.ahtoneLevel!.position.toString();
//     }

//     setState(() {});
//     super.initState();
//   }

//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return CustomDialog(
//       paddingInVertical: false,
//       child: Form(
//         key: _formKey,
//         child: Container(
//           padding: EdgeInsets.only(bottom: 0),
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(height: 20),

//                 ///ahtone name
//                 Text(
//                   "အထုံ Level",
//                   style: TextStyle(
//                     fontSize: FontSize.normal,
//                   ),
//                 ),

//                 SizedBox(height: 10),
//                 TextFormField(
//                   controller: ahtoneLevelController,
//                   validator: (value) {
//                     if (value == "") {
//                       return "အထုံ Level သည် ဗလာဖြစ်နေသည်";
//                     }
//                     return null;
//                   },
//                   decoration: customTextDecoration2(
//                     labelText: "အထုံ Level အသစ်ထည့်ရန်",
//                   ),
//                 ),

//                 ///position
//                 SizedBox(height: 20),
//                 Text(
//                   "နေရာ",
//                   style: TextStyle(
//                     fontSize: FontSize.normal,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 BlocBuilder<AhtoneLevelCubit, AhtoneLevelCrudState>(
//                   builder: (context, state) {
//                     if (state is AhtoneLevelLoaded) {
//                       List<int> ahtoneLevelPositions = [];
//                       state.ahtone_level.forEach((e) {
//                         ahtoneLevelPositions.add(e.position ?? 0);
//                       });
//                       return TextFormField(
//                         validator: (value) {
//                           if (value == null || value == "") {
//                             return "လိုအပ်သည်";
//                           } else if (ahtoneLevelPositions.contains(
//                                 int.parse(value),
//                               ) &&
//                               widget.ahtoneLevel == null) {
//                             return "နေရာနံပါတ် ရှိပြီးသားပါ။";
//                           } else {
//                             return null;
//                           }
//                         },
//                         controller: positionController,
//                         decoration: customTextDecoration2(
//                           labelText: "နေရာ",
//                         ),
//                       );
//                     } else {
//                       return Container();
//                     }
//                   },
//                 ),

//                 ///description
//                 SizedBox(height: 20),
//                 Text(
//                   "ဖော်ပြချက်",
//                   style: TextStyle(
//                     fontSize: FontSize.normal,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   controller: descriptionController,
//                   decoration: customTextDecoration2(
//                     labelText: "",
//                   ),
//                 ),

//                 SizedBox(height: 15),

//                 BlocConsumer<AhtoneLevelCubit, AhtoneLevelCrudState>(
//                   listener: (context, state) {},
//                   builder: (context, state) {
//                     if (state is AhtoneLevelLoading) {
//                       return loadingWidget();
//                     } else {
//                       return Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           customizableOTButton(
//                             elevation: 0,
//                             child: Text("ပယ်ဖျက်ရန်"),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                           SizedBox(width: 10),
//                           custamizableElevated(
//                             child: Text("အတည်ပြုရန်"),
//                             onPressed: () async {
//                               if (_formKey.currentState!.validate()) {
//                                 if (widget.ahtoneLevel != null) {
//                                   await editAhtoneLevel();
//                                 } else {
//                                   await createAhtoneLevel();
//                                 }
//                               }
//                             },
//                           ),
//                         ],
//                       );
//                     }
//                   },
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   ///edit ahtone level
//   Future editAhtoneLevel() async {
//     await context
//         .read<AhtoneLevelCubit>()
//         .editAhtoneLevel(
//           name: ahtoneLevelController.text,
//           description: descriptionController.text,
//           id: widget.ahtoneLevel!.id.toString(),
//           position: int.parse(positionController.text),
//         )
//         .then(
//       (value) {
//         if (value) {
//           Navigator.pop(context);
//           context.read<AhtoneLevelCubit>().getAllLevels();
//         }
//       },
//     );
//   }

//   ///create ahtone level
//   createAhtoneLevel() async {
//     await context
//         .read<AhtoneLevelCubit>()
//         .addNewAhtone(
//           levelName: ahtoneLevelController.text,
//           description: descriptionController.text,
//           position: int.parse(positionController.text),
//         )
//         .then(
//       (value) {
//         if (value) {
//           Navigator.pop(context);
//           context.read<AhtoneLevelCubit>().getAllLevels();
//         }
//       },
//     );
//   }
// }
