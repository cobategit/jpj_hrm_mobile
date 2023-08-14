import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/screens/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:jpj_hrm_mobile/widgets/index.dart';
import 'package:badges/badges.dart' as badges;

class LeaveScreen extends StatelessWidget {
  LeaveScreen({super.key});

  final LeaveController _leaveController = Get.put(LeaveController());
  final AbsensiController _absensiController = Get.find<AbsensiController>();

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return Scaffold(
      backgroundColor: GlobalColor.grey.withOpacity(0.02),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalSize.blockSizeVertical! * 5.5),
        child: CustomAppBar(
          textJudul: "LEAVES",
          textUsername:
              '${_absensiController.dataProfile!['name'].split(' ')[0]}',
          checkNetwork: _absensiController.checkNetwork!.value,
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => InkWell(
                        onTap: () {
                          _leaveController.paramsHistoryMangkir!({
                            'role': _absensiController.dataProfile!['role'],
                          });
                          if (_absensiController.dataProfile!['role'] ==
                              'Manager') {
                            _leaveController.paramsHistoryMangkir!['id'] =
                                _absensiController
                                    .dataProfile!['id_parent_department'];
                          }
                          if (_absensiController.dataProfile!['role'] ==
                              'Employee') {
                            _leaveController.paramsHistoryMangkir!['id'] =
                                _absensiController.dataProfile!['id'];
                          }

                          _leaveController.getHistoryMangkir("mangkir");
                          AllNavigation.pushNav(
                              context, HistoryMangkirScreen(), (_) {});
                        },
                        child: badges.Badge(
                          badgeContent: Text(_absensiController
                                      .dataProfile!['role'] ==
                                  'Manager'
                              ? "${_leaveController.countPendingMangkir!.value}"
                              : ""),
                          badgeStyle: badges.BadgeStyle(
                              badgeColor:
                                  _absensiController.dataProfile!['role'] ==
                                          'Manager'
                                      ? const Color.fromARGB(248, 8, 235, 65)
                                      : Colors.transparent),
                          position:
                              badges.BadgePosition.topEnd(top: 30, end: 10),
                          child: Container(
                            // color: Colors.red,
                            margin: EdgeInsets.only(
                              top: GlobalSize.safeBlockVertical! * 3,
                            ),
                            width: GlobalSize.safeBlockHorizontal! * 35,
                            height: GlobalSize.safeBlockVertical! * 25,
                            decoration: BoxDecoration(
                              color: GlobalColor.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesome5.calendar_minus,
                                  size: GlobalSize.safeBlockVertical! * 8,
                                  color: GlobalColor.light,
                                ),
                                SizedBox(
                                  height: GlobalSize.blockSizeVertical! * 1,
                                ),
                                Text(
                                  'Mangkir',
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
                        ),
                      )),
                  Obx(() => InkWell(
                        onTap: () {
                          _leaveController.paramsHistoryCuti!({
                            'role': _absensiController.dataProfile!['role'],
                          });
                          if (_absensiController.dataProfile!['role'] ==
                              'Manager') {
                            _leaveController.paramsHistoryCuti!['id'] =
                                _absensiController
                                    .dataProfile!['id_parent_department'];
                          }
                          if (_absensiController.dataProfile!['role'] ==
                              'Employee') {
                            _leaveController.paramsHistoryCuti!['id'] =
                                _absensiController.dataProfile!['id'];
                          }

                          _leaveController.getHistoryCuti();
                          AllNavigation.pushNav(
                              context, HistoryCutiScreen(), (_) {});
                        },
                        child: badges.Badge(
                          badgeContent: Text(_absensiController
                                      .dataProfile!['role'] ==
                                  'Manager'
                              ? "${_leaveController.countPendingCuti!.value}"
                              : ""),
                          badgeStyle: badges.BadgeStyle(
                              badgeColor:
                                  _absensiController.dataProfile!['role'] ==
                                          'Manager'
                                      ? const Color.fromARGB(248, 8, 235, 65)
                                      : Colors.transparent),
                          position:
                              badges.BadgePosition.topEnd(top: 30, end: 10),
                          child: Container(
                            // color: Colors.red,
                            margin: EdgeInsets.only(
                              top: GlobalSize.safeBlockVertical! * 3,
                            ),
                            width: GlobalSize.safeBlockHorizontal! * 35,
                            height: GlobalSize.safeBlockVertical! * 25,
                            decoration: BoxDecoration(
                              color: GlobalColor.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconGlobal.iconleave,
                                  size: GlobalSize.safeBlockVertical! * 8,
                                  color: GlobalColor.light,
                                ),
                                SizedBox(
                                  height: GlobalSize.blockSizeVertical! * 1,
                                ),
                                Text(
                                  'Cuti',
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
                        ),
                      ))
                ],
              ),
            ],
          ),
          Obx(() {
            if (_leaveController.isLoading!.value) {
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
