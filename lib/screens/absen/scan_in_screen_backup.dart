// import 'package:flutter/material.dart';
// import 'package:fluttericon/font_awesome5_icons.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:jpj_hrm_mobile/configs/index.dart';
// import 'package:jpj_hrm_mobile/controllers/index.dart';
// import 'package:jpj_hrm_mobile/screens/index.dart';
// import 'package:jpj_hrm_mobile/utils/index.dart';
// import 'package:jpj_hrm_mobile/widgets/index.dart';

// class ScanInScreen extends StatelessWidget {
//   ScanInScreen({Key? key}) : super(key: key);

//   final AbsensiController absensiController = Get.put(AbsensiController());
//   final HomeController homeController = Get.put(HomeController());

//   @override
//   Widget build(BuildContext context) {
//     GlobalSize().init(context);
//     return WillPopScope(
//       onWillPop: () {
//         AllNavigation.popNav(context, false, null);
//         throw true;
//       },
//       child: Scaffold(
//         backgroundColor: GlobalColor.blue,
//         body: Stack(
//           clipBehavior: Clip.antiAlias,
//           alignment: Alignment.center,
//           children: [
//             Column(
//               children: [
//                 Header(
//                   color1: GlobalColor.grey,
//                   color2: GlobalColor.light,
//                   color3: GlobalColor.light,
//                   width: GlobalSize.blockSizeHorizontal!,
//                   height: GlobalSize.blockSizeVertical!,
//                   onPressedMenu: () {
//                     homeController.handleMenuBar();
//                   },
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(
//                       top: GlobalSize.blockSizeVertical! * 2,
//                       left: GlobalSize.blockSizeHorizontal! * 7,
//                       right: GlobalSize.blockSizeHorizontal! * 7,
//                     ),
//                     width: GlobalSize.blockSizeHorizontal! * 100,
//                     decoration: BoxDecoration(
//                       color: GlobalColor.light.withOpacity(0.95),
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(
//                             GlobalSize.blockSizeVertical! * 4.5),
//                         topRight: Radius.circular(
//                             GlobalSize.blockSizeVertical! * 4.5),
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             AllNavigation.popNav(context, false, null);
//                           },
//                           child: Container(
//                             color: Colors.transparent,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   FontAwesome5.arrow_left,
//                                   color: GlobalColor.blue,
//                                   size: GlobalSize.safeBlockVertical! * 2.5,
//                                 ),
//                                 Text(
//                                   '  CHECK IN/OUT',
//                                   style: TextStyle(
//                                     fontSize: GlobalSize.blockSizeVertical! * 3,
//                                     color: GlobalColor.blue,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: GlobalSize.blockSizeVertical! * 1,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(
//                             top: GlobalSize.blockSizeVertical! * 7,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Obx(() => Text(
//                                     absensiController.timerString!.value,
//                                     style: TextStyle(
//                                       fontSize:
//                                           GlobalSize.blockSizeVertical! * 4,
//                                       color: GlobalColor.blue,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   )),
//                               Obx(() => Text(
//                                     absensiController.dateString!.value,
//                                     style: TextStyle(
//                                       fontSize:
//                                           GlobalSize.blockSizeVertical! * 2.4,
//                                       color: GlobalColor.blue,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   )),
//                               SizedBox(
//                                 height: GlobalSize.blockSizeVertical! * 10,
//                               ),
//                               Obx(
//                                 () => CustomDropdownMenu(
//                                   value: absensiController.valWork!.value,
//                                   hinText: 'Work',
//                                   isExpanded: true,
//                                   items: ["WFH", "WFO"]
//                                       .map<DropdownMenuItem<String>>(
//                                           (dynamic value) {
//                                     return DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value,
//                                           style: GoogleFonts.poppins(
//                                               fontSize: GlobalSize
//                                                       .blockSizeVertical! *
//                                                   1.8)),
//                                     );
//                                   }).toList(),
//                                   hp: 5.5,
//                                   wp: 27,
//                                   margin: EdgeInsets.only(
//                                       top: GlobalSize.blockSizeVertical! * 1),
//                                   onChanged: (value) {},
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: GlobalSize.blockSizeVertical! * 4,
//                               ),
//                               GlobalButtonElevated(
//                                 onPressed: () {},
//                                 tittle: 'SCAN BARCODE',
//                                 fontSize: GlobalSize.blockSizeVertical! * 2.1,
//                                 color: GlobalColor.light,
//                                 colorPrim: GlobalColor.blue,
//                                 colorOnPrim: Colors.white.withOpacity(0.9),
//                                 colorShadowPrim: Colors.white,
//                                 borderRadius:
//                                     GlobalSize.blockSizeVertical! * 1.5,
//                                 sizeH: GlobalSize.safeBlockVertical! * 5.5,
//                                 sizeW: GlobalSize.safeBlockHorizontal! * 18,
//                               ),
//                               SizedBox(
//                                 height: GlobalSize.blockSizeVertical! * 4,
//                               ),
//                               GlobalButtonElevated(
//                                 onPressed: () {},
//                                 tittle: 'TAKE FOTO',
//                                 fontSize: GlobalSize.blockSizeVertical! * 2.1,
//                                 color: GlobalColor.light,
//                                 colorPrim: GlobalColor.blue,
//                                 colorOnPrim: Colors.white.withOpacity(0.9),
//                                 colorShadowPrim: Colors.white,
//                                 borderRadius:
//                                     GlobalSize.blockSizeVertical! * 1.5,
//                                 sizeH: GlobalSize.safeBlockVertical! * 5.5,
//                                 sizeW: GlobalSize.safeBlockHorizontal! * 18,
//                               ),
//                               SizedBox(
//                                 height: GlobalSize.blockSizeVertical! * 15,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.arrow_circle_up,
//                                         size: GlobalSize.safeBlockVertical! * 3,
//                                         color: GlobalColor.blue,
//                                       ),
//                                       Text(
//                                         '09:20',
//                                         style: TextStyle(
//                                           fontSize:
//                                               GlobalSize.blockSizeVertical! *
//                                                   2.4,
//                                           color: GlobalColor.blue,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         'Check In',
//                                         style: TextStyle(
//                                           fontSize:
//                                               GlobalSize.blockSizeVertical! *
//                                                   1.4,
//                                           color: GlobalColor.blue,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.arrow_circle_down,
//                                         size: GlobalSize.safeBlockVertical! * 3,
//                                         color: GlobalColor.blue,
//                                       ),
//                                       Text(
//                                         '18:00',
//                                         style: TextStyle(
//                                           fontSize:
//                                               GlobalSize.blockSizeVertical! *
//                                                   2.4,
//                                           color: GlobalColor.blue,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         'Check Out',
//                                         style: TextStyle(
//                                           fontSize:
//                                               GlobalSize.blockSizeVertical! *
//                                                   1.4,
//                                           color: GlobalColor.blue,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.timer,
//                                         size: GlobalSize.safeBlockVertical! * 3,
//                                         color: GlobalColor.blue,
//                                       ),
//                                       Text(
//                                         '09h 20m',
//                                         style: TextStyle(
//                                           fontSize:
//                                               GlobalSize.blockSizeVertical! *
//                                                   2.4,
//                                           color: GlobalColor.blue,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         'Working Hr\'s',
//                                         style: TextStyle(
//                                           fontSize:
//                                               GlobalSize.blockSizeVertical! *
//                                                   1.4,
//                                           color: GlobalColor.blue,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       )
//                                     ],
//                                   )
//                                 ],
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Obx(
//               () {
//                 if (homeController.isMenuBar!.value) {
//                   return BoxMenuBar(
//                     safeBlockHorizontal: GlobalSize.blockSizeHorizontal,
//                     safeBlockVertical: GlobalSize.blockSizeVertical,
//                     blockSizeHorizontal: GlobalSize.blockSizeHorizontal,
//                     blockSizeVertical: GlobalSize.blockSizeVertical,
//                     color1: GlobalColor.blue,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             homeController.setIsMenuBar(false);
//                             AllNavigation.pushNav(
//                                 context, FormChangePassword(), (_) => {});
//                           },
//                           child: Text(
//                             'Change Password',
//                             style: TextStyle(
//                               fontSize: GlobalSize.blockSizeVertical! * 1.9,
//                               decoration: TextDecoration.underline,
//                               color: GlobalColor.light,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: GlobalSize.blockSizeVertical! * 1.5,
//                         ),
//                         Text(
//                           'Log Out',
//                           style: TextStyle(
//                             fontSize: GlobalSize.blockSizeVertical! * 1.9,
//                             decoration: TextDecoration.underline,
//                             color: GlobalColor.light,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//                 return Container();
//               },
//             ),
//             Obx(() {
//               if (homeController.isMenuBar!.value) {
//                 return CloseBar(
//                   safeBlockHorizontal: GlobalSize.safeBlockHorizontal,
//                   safeBlockVertical: GlobalSize.safeBlockVertical,
//                   blockSizeVertical: GlobalSize.blockSizeVertical,
//                   color1: GlobalColor.light,
//                   onTap: () {
//                     homeController.handleMenuBar();
//                   },
//                 );
//               }
//               return Container();
//             })
//           ],
//         ),
//       ),
//     );
//   }
// }
