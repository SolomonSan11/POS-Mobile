// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:golden_thailand/blocs/category_crud_cubit/expense_crud_cubit.dart';
// import 'package:golden_thailand/blocs/remark_cubit/remark_cubit.dart';
// import 'package:golden_thailand/blocs/remark_cubit/remark_state.dart';
// import 'package:golden_thailand/core/app_theme_const.dart';
// import 'package:golden_thailand/core/size_const.dart';
// import 'package:golden_thailand/data/models/remark_model.dart';
// import 'package:golden_thailand/ui/widgets/common_widget.dart';

// class RemarkCURDPage extends StatefulWidget {
//   const RemarkCURDPage({super.key});

//   @override
//   State<RemarkCURDPage> createState() => _RemarkCURDPageState();
// }

// class _RemarkCURDPageState extends State<RemarkCURDPage> {
//   var remarkController = TextEditingController();
//   var descriptionController = TextEditingController();

//   @override
//   void initState() {
//     context.read<RemarkCubit>().getAllLevels();
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
//         title: Text("Remark"),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: SScolor.primaryColor,
//         label: Text("Add Remark"),
//         icon: Icon(Icons.add),
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return RemarkCURDPageDialog(
//                 screenSize: screenSize,
//               );
//             },
//           );
//         },
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: MyPadding.normal,
//         ),
//         child: _productListTest(
//           screenSize,
//         ),
//       ),
//     );
//   }

//   Widget _productListTest(Size screenSize) {
//     return BlocBuilder<RemarkCubit, RemarkState>(
//       builder: (context, state) {
//         if (state is RemarkLoading) {
//           return loadingWidget();
//         } else if (state is RemarkLoaded) {
//           return GridView.builder(
//             //controller: scrollController,
//             physics: BouncingScrollPhysics(),
//             padding: EdgeInsets.only(bottom: 20, top: 7.5),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4,
//               mainAxisSpacing: MyPadding.normal,
//               crossAxisSpacing: MyPadding.normal,
//               childAspectRatio: screenSize.width * 0.002,
//             ),
//             itemCount: state.remarkList.length,
//             itemBuilder: (context, index) {
//               RemarkModel remark = state.remarkList[index];
//               return Material(
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: remarkCardWidget(
//                   remark: remark,
//                   onEdit: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return RemarkCURDPageDialog(
//                           screenSize: screenSize,
//                           remark: remark,
//                         );
//                       },
//                     );
//                   },
//                   onDelete: () {
//                     _deleteWarningDialog(
//                       context: context,
//                       screenSize: screenSize,
//                       remark_id: remark.id.toString(),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         } else {
//           return Container();
//           // return ElevatedButton(onPressed: () {}, child: Text("Error"));
//         }
//       },
//     );
//   }

//   ///delete category warning dialog box
//   Future<dynamic> _deleteWarningDialog({
//     required BuildContext context,
//     required Size screenSize,
//     required String remark_id,
//   }) {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           backgroundColor: Colors.white,
//           child: Container(
//             padding: EdgeInsets.all(MyPadding.big - 10),
//             width: screenSize.width / 3.8,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(height: 15),
//                 Text(
//                   "ဖျက်ရန် သေချာလား",
//                   style: TextStyle(fontSize: FontSize.normal),
//                 ),
//                 SizedBox(height: 15),
//                 BlocBuilder<CategoryCrudCubit, CategoryCrudState>(
//                   builder: (context, state) {
//                     if (state is CategoryLoading) {
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
//                             bgColor: Colors.red,
//                             child: Text("ဖျက်မည်"),
//                             onPressed: () async {
//                               await context
//                                   .read<RemarkCubit>()
//                                   .deleteRemark(
//                                     id: remark_id,
//                                     //categoryName: remarkController.text,
//                                   )
//                                   .then(
//                                 (value) {
//                                   if (value) {
//                                     Navigator.pop(context);
//                                     context.read<RemarkCubit>().getAllLevels();
//                                   }
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       );
//                     }
//                   },
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// Widget remarkCardWidget({
//   required RemarkModel remark,
//   required Function() onEdit,
//   required Function() onDelete,
// }) {
//   return Container(
//     padding: EdgeInsets.only(
//       top: MyPadding.normal - 3,
//       bottom: MyPadding.normal - 3,
//       left: MyPadding.big,
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   remark.name!.length > 20
//                       ? "${remark.name}..".substring(0, 20)
//                       : "${remark.name}",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: FontSize.normal,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   "${remark.description}",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: FontSize.normal - 2,
//                     color: Colors.black.withOpacity(0.8),
//                   ),
//                 ),
//               ],
//             ),
//             Spacer(),
//             InkWell(
//               onTap: onEdit,
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 child: Icon(
//                   Icons.edit,
//                   size: 20,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: onDelete,
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 child: Icon(
//                   CupertinoIcons.delete,
//                   size: 20,
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//             SizedBox(width: 10),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// ////category crud dialob box
// class RemarkCURDPageDialog extends StatefulWidget {
//   const RemarkCURDPageDialog({
//     super.key,
//     required this.screenSize,
//     this.remark,
//   });

//   final Size screenSize;

//   final RemarkModel? remark;

//   @override
//   State<RemarkCURDPageDialog> createState() => _RemarkCURDPageDialogState();
// }

// class _RemarkCURDPageDialogState extends State<RemarkCURDPageDialog> {
//   final TextEditingController remarkController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();

//   @override
//   void initState() {
//     if (widget.remark != null) {
//       remarkController.text = widget.remark!.name.toString();
//       descriptionController.text = widget.remark!.description.toString();
//     }
//     setState(() {});
//     super.initState();
//   }

//   bool isGram = false;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       backgroundColor: Colors.white,
//       child: Container(
//         padding: EdgeInsets.all(MyPadding.big - 10),
//         width: widget.screenSize.width / 3.8,
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.25,
//           padding: EdgeInsets.all(MyPadding.normal),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Remark",
//                   style: TextStyle(
//                     fontSize: FontSize.normal,
//                   ),
//                 ),

//                 SizedBox(height: 10),
//                 TextFormField(
//                   controller: remarkController,
//                   maxLines: 4,
//                   keyboardType: TextInputType.text,
//                   validator: (value) {
//                     if (value == "") {
//                       return "Remark can't be empty";
//                     }
//                     return null;
//                   },
//                   decoration: customTextDecoration2(
//                     labelText: "Enter new Remark",
//                     verticalPadding: 10,
//                   ),
//                 ),

//                 ///description
//                 SizedBox(height: 20),
//                 Text(
//                   "Description",
//                   style: TextStyle(
//                     fontSize: FontSize.normal,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   controller: descriptionController,
//                   decoration: customTextDecoration2(
//                     labelText: "Enter description",
//                   ),
//                 ),

//                 SizedBox(height: 15),

//                 BlocConsumer<CategoryCrudCubit, CategoryCrudState>(
//                   listener: (context, state) {},
//                   builder: (context, state) {
//                     if (state is CategoryLoading) {
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
//                               if (widget.remark != null) {
//                                 await context
//                                     .read<RemarkCubit>()
//                                     .editRemark(
//                                         name: remarkController.text,
//                                         description: descriptionController.text,
//                                         id: widget.remark!.id.toString())
//                                     .then(
//                                   (value) {
//                                     if (value) {
//                                       Navigator.pop(context);
//                                       context
//                                           .read<RemarkCubit>()
//                                           .getAllLevels();
//                                     }
//                                   },
//                                 );
//                               } else {
//                                 await context
//                                     .read<RemarkCubit>()
//                                     .addNewRemark(
//                                         levelName: remarkController.text,
//                                         description: descriptionController.text)
//                                     .then(
//                                   (value) {
//                                     if (value) {
//                                       Navigator.pop(context);
//                                       context
//                                           .read<RemarkCubit>()
//                                           .getAllLevels();
//                                     }
//                                   },
//                                 );
//                               }
//                             },
//                           ),
//                         ],
//                       );
//                     }
//                   },
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
