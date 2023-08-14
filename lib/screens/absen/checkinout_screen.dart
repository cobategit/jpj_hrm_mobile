import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:jpj_hrm_mobile/widgets/index.dart';
import 'package:get/get.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';

class CheckInOutScreen extends StatelessWidget {
  CheckInOutScreen({Key? key}) : super(key: key);

  final GpsController gpsController = Get.put(GpsController());
  final AbsensiController absensiController = Get.put(AbsensiController());

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return Scaffold(
      backgroundColor: GlobalColor.grey.withOpacity(0.02),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalSize.blockSizeVertical! * 5.5),
        child: Obx(() => CustomAppBar(
              textJudul: 'IN/OUT',
              textUsername:
                  '${absensiController.dataProfile!['name']?.split(' ')[0]}',
              checkNetwork: absensiController.checkNetwork!.value,
              onPressedSearch: () {},
            )),
      ),
      body: Stack(
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        children: [
          RefreshIndicator(
            key: absensiController.refreshKey,
            onRefresh: () {
              absensiController.handleRefresh();
              return Future.delayed(const Duration(seconds: 0));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: GlobalSize.safeBlockVertical! * 3,
                  left: GlobalSize.safeBlockHorizontal! * 2,
                  right: GlobalSize.safeBlockHorizontal! * 2,
                ),
                child: Column(
                  children: [
                    Obx(() => Text(
                          absensiController.timerString!.value,
                          style: TextStyle(
                              fontSize: GlobalSize.blockSizeVertical! * 5,
                              color: GlobalColor.blue,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IconGlobal'),
                        )),
                    Obx(() => Text(
                          absensiController.dateString!.value,
                          style: TextStyle(
                              fontSize: GlobalSize.blockSizeVertical! * 2.4,
                              color: GlobalColor.blue,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IconGlobal'),
                        )),
                    SizedBox(
                      height: GlobalSize.blockSizeVertical! * 1,
                    ),
                    Obx(() {
                      if ((absensiController.dataAbsen!['check_in'] == false &&
                                  absensiController.dataAbsen!['check_out'] ==
                                      false ||
                              absensiController.dataAbsen!.isEmpty) ||
                          (absensiController.dataAbsen!['check_in'] ==
                                      'Not Yet' &&
                                  absensiController.dataAbsen!['check_out'] ==
                                      'Not Yet' ||
                              absensiController.dataAbsen!.isEmpty)) {
                        // CHECK IN
                        return InkWell(
                          onTap: () async {
                            if (!kIsWeb) {
                              final serviceGps =
                                  await gpsController.handleCheckServiceGps(
                                      context, GlobalSize.blockSizeVertical);
                              await absensiController.handleFakeGps();

                              if (!serviceGps) {
                                gpsController.handleCheckGps(
                                    context, GlobalSize.blockSizeVertical);
                              } else {
                                if (absensiController
                                        .dataProfile!['department'] ==
                                    'SP Operational') {
                                  absensiController.handleCheckInStockfile(
                                    context,
                                    GlobalSize.safeBlockHorizontal,
                                    GlobalSize.safeBlockVertical,
                                  );
                                } else {
                                  absensiController.handleCheckInOffice(
                                    context,
                                    GlobalSize.safeBlockHorizontal,
                                    GlobalSize.safeBlockVertical,
                                  );
                                }
                              }
                            } else {
                              absensiController.handleWebCheckinOffice(
                                context,
                                GlobalSize.safeBlockHorizontal,
                                GlobalSize.safeBlockVertical,
                              );
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              top: GlobalSize.safeBlockVertical! * 3,
                            ),
                            width: GlobalSize.safeBlockHorizontal! * 50,
                            height: GlobalSize.safeBlockVertical! * 30,
                            decoration: BoxDecoration(
                              color: GlobalColor.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconGlobal.icontouch,
                                  size: GlobalSize.safeBlockVertical! * 13,
                                  color: GlobalColor.light,
                                ),
                                SizedBox(
                                  height: GlobalSize.blockSizeVertical! * 1,
                                ),
                                Text(
                                  'IN',
                                  style: TextStyle(
                                    fontSize:
                                        GlobalSize.blockSizeVertical! * 2.4,
                                    color: GlobalColor.light,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if ((absensiController.dataAbsen?['check_in'] !=
                                  false &&
                              (absensiController.dataAbsen?['check_out'] == false ||
                                  absensiController.dataAbsen?['check_out'] ==
                                      null)) ||
                          (absensiController.dataAbsen?['check_in'] !=
                                  'Not Yet' &&
                              absensiController.dataAbsen?['check_out'] ==
                                  'Not Yet' &&
                              absensiController.dataProfile!['department'] ==
                                  'SP Operational')) {
                        // CHECK OUT
                        return InkWell(
                          onTap: () {
                            if (!kIsWeb) {
                              absensiController.handleCheckOut(
                                  context,
                                  GlobalSize.safeBlockVertical!,
                                  GlobalSize.safeBlockHorizontal!);
                            } else {
                              absensiController.handleWebCheckoutOffice(
                                  context,
                                  GlobalSize.safeBlockVertical!,
                                  GlobalSize.safeBlockHorizontal!);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              top: GlobalSize.safeBlockVertical! * 5,
                            ),
                            width: GlobalSize.safeBlockHorizontal! * 50,
                            height: GlobalSize.safeBlockVertical! * 30,
                            decoration: BoxDecoration(
                              color: GlobalColor.red.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconGlobal.icontouch,
                                  size: GlobalSize.safeBlockVertical! * 13,
                                  color: GlobalColor.light,
                                ),
                                SizedBox(
                                  height: GlobalSize.blockSizeVertical! * 1,
                                ),
                                Text(
                                  'OUT',
                                  style: TextStyle(
                                    fontSize:
                                        GlobalSize.blockSizeVertical! * 2.4,
                                    color: GlobalColor.light,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (absensiController.dataProfile!['department'] ==
                          'SP Operational') {
                        // CHECK IN
                        return InkWell(
                          onTap: () async {
                            if (absensiController.dataProfile!['department'] ==
                                'SP Operational') {
                              final serviceGps =
                                  await gpsController.handleCheckServiceGps(
                                      context, GlobalSize.blockSizeVertical);
                              await absensiController.handleFakeGps();
                              if (!serviceGps) {
                                gpsController.handleCheckGps(
                                    context, GlobalSize.blockSizeVertical);
                              } else {
                                absensiController.handleCheckInStockfile(
                                  context,
                                  GlobalSize.safeBlockHorizontal,
                                  GlobalSize.safeBlockVertical,
                                );
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              top: GlobalSize.safeBlockVertical! * 3,
                            ),
                            width: GlobalSize.safeBlockHorizontal! * 50,
                            height: GlobalSize.safeBlockVertical! * 30,
                            decoration: BoxDecoration(
                              color: GlobalColor.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconGlobal.icontouch,
                                  size: GlobalSize.safeBlockVertical! * 13,
                                  color: GlobalColor.light,
                                ),
                                SizedBox(
                                  height: GlobalSize.blockSizeVertical! * 1,
                                ),
                                Text(
                                  'CHECK IN',
                                  style: TextStyle(
                                    fontSize:
                                        GlobalSize.blockSizeVertical! * 2.4,
                                    color: GlobalColor.light,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.only(
                            top: GlobalSize.safeBlockVertical! * 3,
                          ),
                          width: GlobalSize.safeBlockHorizontal! * 50,
                          height: GlobalSize.safeBlockVertical! * 30,
                          decoration: BoxDecoration(
                            color: GlobalColor.dark,
                            shape: BoxShape.circle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bedtime,
                                size: GlobalSize.safeBlockVertical! * 13,
                                color: GlobalColor.light,
                              ),
                              SizedBox(
                                height: GlobalSize.blockSizeVertical! * 1,
                              ),
                              Text(
                                'ISTIRAHAT',
                                style: TextStyle(
                                  fontSize: GlobalSize.blockSizeVertical! * 2.4,
                                  color: GlobalColor.light,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                    SizedBox(
                      height: GlobalSize.blockSizeVertical! * 2, // 17
                    ),
                    Obx(() {
                      if (absensiController.location?.value != '') {
                        return Text(
                          'Location: ${absensiController.location?.value}',
                          style: TextStyle(
                            fontSize: GlobalSize.blockSizeVertical! * 2.6,
                            color: GlobalColor.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      } else {
                        return const Text('');
                      }
                    }),
                    SizedBox(
                      height: GlobalSize.blockSizeVertical! * 3, // 17
                    ),
                    Obx(() {
                      if ((absensiController.dataAbsen!.isNotEmpty &&
                              absensiController.dataAbsen!['behavior'] !=
                                  null &&
                              absensiController.dataProfile!['department'] !=
                                  'SP Operational') ||
                          (absensiController.dataAbsen!.isNotEmpty &&
                              absensiController.dataAbsen!['behavior'] !=
                                  'Not Yet' &&
                              absensiController.dataProfile!['department'] ==
                                  'SP Operational')) {
                        return Text(
                          'Keterangan: ${absensiController.dataAbsen?['behavior']}',
                          style: TextStyle(
                            fontSize: GlobalSize.blockSizeVertical! * 2.2,
                            color: GlobalColor.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      } else {
                        return const Text('');
                      }
                    }),
                    SizedBox(
                      height: GlobalSize.blockSizeVertical! * 8, // 17
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              IconGlobal.iconcheckin,
                              size: GlobalSize.safeBlockVertical! * 3,
                              color: GlobalColor.blue,
                            ),
                            SizedBox(
                              height: GlobalSize.blockSizeVertical! * 0.5, // 17
                            ),
                            Obx(() {
                              if (((absensiController.dataAbsen!['check_in'] !=
                                              false &&
                                          absensiController
                                                  .dataProfile!['department'] !=
                                              'SP Operational') ||
                                      (absensiController
                                                  .dataAbsen!['check_in'] !=
                                              'Not Yet' &&
                                          absensiController
                                                  .dataProfile!['department'] ==
                                              'SP Operational')) &&
                                  absensiController.dataAbsen!.isNotEmpty) {
                                return Text(
                                  '${absensiController.dataAbsen?['check_in']}',
                                  style: TextStyle(
                                    fontSize: GlobalSize.blockSizeVertical! * 2,
                                    color: GlobalColor.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else {
                                return Text(
                                  '--:--',
                                  style: TextStyle(
                                    fontSize: GlobalSize.blockSizeVertical! * 2,
                                    color: GlobalColor.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            }),
                            Text(
                              'Check In',
                              style: TextStyle(
                                fontSize: GlobalSize.blockSizeVertical! * 1.4,
                                color: GlobalColor.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              IconGlobal.iconcheckout,
                              size: GlobalSize.safeBlockVertical! * 3,
                              color: GlobalColor.blue,
                            ),
                            SizedBox(
                              height: GlobalSize.blockSizeVertical! * 0.5, // 17
                            ),
                            Obx(() {
                              if (((absensiController.dataAbsen!['check_out'] !=
                                              false &&
                                          absensiController
                                                  .dataAbsen!['check_out'] !=
                                              null &&
                                          absensiController
                                                  .dataProfile!['department'] !=
                                              'SP Operational') ||
                                      (absensiController
                                                  .dataAbsen!['check_out'] !=
                                              'Not Yet' &&
                                          absensiController
                                                  .dataProfile!['department'] ==
                                              'SP Operational')) &&
                                  absensiController.dataAbsen!.isNotEmpty) {
                                return Text(
                                  '${absensiController.dataAbsen?['check_out']}',
                                  style: TextStyle(
                                    fontSize: GlobalSize.blockSizeVertical! * 2,
                                    color: GlobalColor.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else {
                                return Text(
                                  '--:--',
                                  style: TextStyle(
                                    fontSize: GlobalSize.blockSizeVertical! * 2,
                                    color: GlobalColor.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            }),
                            Text(
                              'Check Out',
                              style: TextStyle(
                                fontSize: GlobalSize.blockSizeVertical! * 1.4,
                                color: GlobalColor.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              IconGlobal.iconworkinghrs,
                              size: GlobalSize.safeBlockVertical! * 3,
                              color: GlobalColor.blue,
                            ),
                            SizedBox(
                              height: GlobalSize.blockSizeVertical! * 0.5, // 17
                            ),
                            Obx(() {
                              if (absensiController.workingHrs?.value != '') {
                                return Text(
                                  '${absensiController.workingHrs?.value}',
                                  style: TextStyle(
                                    fontSize: GlobalSize.blockSizeVertical! * 2,
                                    color: GlobalColor.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else {
                                return Text(
                                  '--:--',
                                  style: TextStyle(
                                    fontSize: GlobalSize.blockSizeVertical! * 2,
                                    color: GlobalColor.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            }),
                            Text(
                              'Working Hr\'s',
                              style: TextStyle(
                                fontSize: GlobalSize.blockSizeVertical! * 1.4,
                                color: GlobalColor.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            if (absensiController.isLoading!.value) {
              return const ProgressBar();
            } else {
              return Container();
            }
          })
        ],
      ),
    );
  }
}
