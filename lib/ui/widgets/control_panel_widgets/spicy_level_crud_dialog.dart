// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:golden_thailand/blocs/spicy_level_crud_cubit/spicy_level_cubit.dart';
// import 'package:golden_thailand/blocs/spicy_level_crud_cubit/spicy_level_state.dart';
// import 'package:golden_thailand/core/size_const.dart';
// import 'package:golden_thailand/data/models/spicy_level.dart';
// import 'package:golden_thailand/ui/widgets/common_widget.dart';
// import 'package:golden_thailand/ui/widgets/custom_dialog.dart';

// ////spicy levvel crud dialob box
// class SpicyLevelCRUDDialog extends StatefulWidget {
//   const SpicyLevelCRUDDialog({
//     super.key,
//     required this.screenSize,
//     this.SpicyLevel,
//   });

//   final Size screenSize;

//   final SpicyLevelModel? SpicyLevel;

//   @override
//   State<SpicyLevelCRUDDialog> createState() => _SpicyLevelCRUDDialogState();
// }

// class _SpicyLevelCRUDDialogState extends State<SpicyLevelCRUDDialog> {
//   final TextEditingController spicyLevelController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController positionController = TextEditingController();

//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     if (widget.SpicyLevel != null) {
//       spicyLevelController.text = widget.SpicyLevel!.name.toString();
//       descriptionController.text = widget.SpicyLevel!.description.toString();
//       positionController.text = widget.SpicyLevel!.position.toString();
//     }
//     setState(() {});
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomDialog(
//       paddingInVertical: false,
//       child: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(height: 20),
//               Text(
//                 "အစပ် Level",
//                 style: TextStyle(
//                   fontSize: FontSize.normal,
//                 ),
//               ),

//               SizedBox(height: 10),
//               TextFormField(
//                 controller: spicyLevelController,
//                 validator: (value) {
//                   if (value == "") {
//                     return "Spicy Level can't be empty";
//                   }
//                   return null;
//                 },
//                 decoration: customTextDecoration2(
//                   labelText: "အစပ် Level ကိုထည့်ရန်",
//                 ),
//               ),

//               ///position
//               SizedBox(height: 15),
//               Text(
//                 "နေရာ",
//                 style: TextStyle(
//                   fontSize: FontSize.normal,
//                 ),
//               ),
//               SizedBox(height: 10),
//               BlocBuilder<SpicyLevelCubit, SpicyLevelCrudState>(
//                 builder: (context, state) {
//                   if (state is SpicyLevelLoaded) {
//                     List<int> spicyLevels = [];
//                     state.spicy_level.forEach((e) {
//                       spicyLevels.add(e.position ?? 0);
//                     });
//                     return TextFormField(
//                       controller: positionController,
//                       validator: (value) {
//                         if (value == null || value == "") {
//                           return "လိုအပ်သည်!";
//                         } else if (spicyLevels.contains(
//                               int.parse(value),
//                             ) &&
//                             widget.SpicyLevel == null) {
//                           return "နေရာနံပါတ် ရှိပြီးသားပါ။";
//                         } else {
//                           return null;
//                         }
//                       },
//                       decoration: customTextDecoration2(
//                         labelText: "",
//                       ),
//                     );
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//               SizedBox(height: 15),

//               ///description

//               Text(
//                 "ဖော်ပြချက်",
//                 style: TextStyle(
//                   fontSize: FontSize.normal,
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: descriptionController,
//                 decoration: customTextDecoration2(
//                   labelText: "",
//                 ),
//               ),
//               SizedBox(height: 15),

//               BlocConsumer<SpicyLevelCubit, SpicyLevelCrudState>(
//                 listener: (context, state) {},
//                 builder: (context, state) {
//                   if (state is SpicyLevelLoading) {
//                     return loadingWidget();
//                   } else {
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         customizableOTButton(
//                           elevation: 0,
//                           child: Text("ပယ်ဖျက်ရန်"),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                         SizedBox(width: 10),
//                         custamizableElevated(
//                           child: Text("အတည်ပြုရန်"),
//                           onPressed: () async {
//                             if (_formKey.currentState!.validate()) {
//                               if (widget.SpicyLevel != null) {
//                                 await editSpicLevelData(context);
//                               } else {
//                                 await addNewSpicyLevel(context);
//                               }
//                             }
//                           },
//                         ),
//                       ],
//                     );
//                   }
//                 },
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   ///add new spicy level data
//   Future<void> addNewSpicyLevel(BuildContext context) async {
//     await context
//         .read<SpicyLevelCubit>()
//         .addNewSpicy(
//             levelName: spicyLevelController.text,
//             description: descriptionController.text,
//             position: int.parse(positionController.text))
//         .then(
//       (value) {
//         if (value) {
//           Navigator.pop(context);
//           context.read<SpicyLevelCubit>().getAllLevels();
//         }
//       },
//     );
//   }

//   ///edit spicy level data
//   Future<void> editSpicLevelData(BuildContext context) async {
//     await context
//         .read<SpicyLevelCubit>()
//         .editSpicyLevel(
//             name: spicyLevelController.text,
//             description: descriptionController.text,
//             id: widget.SpicyLevel!.id.toString(),
//             position: int.parse(positionController.text))
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
