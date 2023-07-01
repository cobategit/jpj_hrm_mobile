import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/screens/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:jpj_hrm_mobile/widgets/index.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LeaveScreen extends StatelessWidget {
  LeaveScreen({Key? key}) : super(key: key);

  final LeaveController leaveController = Get.put(LeaveController());
  final AbsensiController absensiController = Get.find<AbsensiController>();

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return WillPopScope(
      onWillPop: () {
        AllNavigation.popNav(context, false, null);
        leaveController.filterTglLeave?.clear();
        throw true;
      },
      child: Scaffold(
        backgroundColor: GlobalColor.grey.withOpacity(0.02),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(GlobalSize.blockSizeVertical! * 5.5),
          child: CustomAppBar(
            textJudul: 'LEAVE',
            textUsername:
                '${absensiController.dataProfile!['name']?.split(' ')[0]}',
            checkNetwork: absensiController.checkNetwork!.value,
            onPressedSearch: () {},
          ),
        ),
        body: Stack(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: GlobalSize.safeBlockHorizontal! * 7,
                right: GlobalSize.safeBlockHorizontal! * 7,
                // top: GlobalSize.safeBlockVertical! * 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => CircularPercentIndicator(
                        radius: GlobalSize.safeBlockVertical! * 12,
                        lineWidth: GlobalSize.safeBlockVertical! * 1.8,
                        animation: true,
                        percent: leaveController.sumcutiTahunan!.value /
                            leaveController.quotacutiTahunan!.value,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${leaveController.sumcutiTahunan!}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: GlobalSize.safeBlockVertical! * 4.5,
                                color: GlobalColor.blue,
                                fontFamily: 'IconGlobal',
                              ),
                            ),
                            Text(
                              "Leave Balance",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: GlobalSize.safeBlockVertical! * 1.8,
                                color: GlobalColor.blue,
                                fontFamily: 'IconGlobal',
                              ),
                            ),
                          ],
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: GlobalColor.blue,
                      )),
                  SizedBox(
                    height: GlobalSize.blockSizeVertical! * 5, // 17
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: GlobalSize.safeBlockHorizontal! * 1.5,
                                height: GlobalSize.safeBlockVertical! * 1,
                                decoration: BoxDecoration(
                                  color: GlobalColor.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width:
                                    GlobalSize.safeBlockHorizontal! * 2.5, // 17
                              ),
                              Text(
                                "Total Leaves",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: GlobalSize.blockSizeVertical! * 1.6,
                                  color: GlobalColor.blue,
                                ),
                              ),
                            ],
                          ),
                          Obx(() => Text(
                                "${leaveController.sumcutiTahunan!.value + leaveController.sisacutiTahunan!.value}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: GlobalSize.blockSizeVertical! * 2,
                                  color: GlobalColor.blue,
                                ),
                              )),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: GlobalSize.safeBlockHorizontal! * 1.5,
                                height: GlobalSize.safeBlockVertical! * 1,
                                decoration: BoxDecoration(
                                  color: GlobalColor.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width:
                                    GlobalSize.safeBlockHorizontal! * 2.5, // 17
                              ),
                              Text(
                                "Leaves Used",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: GlobalSize.blockSizeVertical! * 1.6,
                                  color: GlobalColor.blue,
                                ),
                              ),
                            ],
                          ),
                          Obx(() => Text(
                                "${leaveController.sisacutiTahunan?.value}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: GlobalSize.blockSizeVertical! * 2,
                                  color: GlobalColor.blue,
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: GlobalSize.blockSizeVertical! * 4, // 17
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Obx(() => CircularPercentIndicator(
                                radius: GlobalSize.safeBlockVertical! * 2.5,
                                lineWidth: GlobalSize.safeBlockVertical! * 0.4,
                                animation: true,
                                percent: leaveController.sumcutiTahunan!.value /
                                    leaveController.quotacutiTahunan!.value,
                                center: Text(
                                  "${leaveController.sumcutiTahunan?.value}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        GlobalSize.safeBlockVertical! * 1.8,
                                    color: GlobalColor.blue,
                                    fontFamily: 'IconGlobal',
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: GlobalColor.blue,
                              )),
                          SizedBox(
                            height: GlobalSize.blockSizeVertical! * 0.5, // 17
                          ),
                          Text(
                            "Tahunan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: GlobalSize.safeBlockVertical! * 1.6,
                              color: GlobalColor.blue,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Obx(() => CircularPercentIndicator(
                                radius: GlobalSize.safeBlockVertical! * 2.5,
                                lineWidth: GlobalSize.safeBlockVertical! * 0.4,
                                animation: true,
                                percent: leaveController.sumcutiLahir!.value /
                                    leaveController.quotacutiLahir!.value,
                                center: Text(
                                  "${leaveController.sumcutiLahir?.value}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        GlobalSize.safeBlockVertical! * 1.8,
                                    color: GlobalColor.blue,
                                    fontFamily: 'IconGlobal',
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: GlobalColor.blue,
                              )),
                          SizedBox(
                            height: GlobalSize.blockSizeVertical! * 0.5, // 17
                          ),
                          Text(
                            "Melahirkan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: GlobalSize.safeBlockVertical! * 1.6,
                              color: GlobalColor.blue,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Obx(() => CircularPercentIndicator(
                                radius: GlobalSize.safeBlockVertical! * 2.5,
                                lineWidth: GlobalSize.safeBlockVertical! * 0.4,
                                animation: true,
                                percent: leaveController.sumcutiKhusus!.value /
                                    leaveController.quotacutiKhusus!.value,
                                center: Text(
                                  "${leaveController.sumcutiKhusus?.value}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        GlobalSize.safeBlockVertical! * 1.8,
                                    color: GlobalColor.blue,
                                    fontFamily: 'IconGlobal',
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: GlobalColor.blue,
                              )),
                          SizedBox(
                            height: GlobalSize.blockSizeVertical! * 0.5, // 17
                          ),
                          Text(
                            "Khusus",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: GlobalSize.safeBlockVertical! * 1.6,
                              color: GlobalColor.blue,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Obx(() => CircularPercentIndicator(
                                radius: GlobalSize.safeBlockVertical! * 2.5,
                                lineWidth: GlobalSize.safeBlockVertical! * 0.4,
                                animation: true,
                                percent: leaveController.sumcutiBesar!.value /
                                    leaveController.quotacutiBesar!.value,
                                center: Text(
                                  "${leaveController.sumcutiBesar?.value}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        GlobalSize.safeBlockVertical! * 1.8,
                                    color: GlobalColor.blue,
                                    fontFamily: 'IconGlobal',
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: GlobalColor.blue,
                              )),
                          SizedBox(
                            height: GlobalSize.blockSizeVertical! * 0.5, // 17
                          ),
                          Text(
                            "Besar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: GlobalSize.safeBlockVertical! * 1.6,
                              color: GlobalColor.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: GlobalSize.blockSizeVertical! * 5, // 17
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlobalButtonElevated(
                        onPressed: () {
                          AllNavigation.pushNav(
                              context, FormLeaveScreen(), (_) {});
                        },
                        tittle: 'Request Leave',
                        fontSize: GlobalSize.blockSizeVertical! * 1.8,
                        color: GlobalColor.light,
                        colorPrim: GlobalColor.green,
                        colorOnPrim: Colors.white.withOpacity(0.9),
                        colorShadowPrim: Colors.white,
                        borderRadius: GlobalSize.blockSizeVertical! * 1,
                        sizeH: GlobalSize.safeBlockVertical! * 4.5,
                        sizeW: GlobalSize.safeBlockHorizontal! * 8,
                      ),
                      GlobalButtonElevated(
                        onPressed: () {
                          AllNavigation.pushNav(
                              context, HistoryLeaveScreen(), (_) {});
                        },
                        tittle: 'History Leave',
                        fontSize: GlobalSize.blockSizeVertical! * 1.8,
                        color: GlobalColor.light,
                        colorPrim: GlobalColor.grey,
                        colorOnPrim: Colors.white.withOpacity(0.9),
                        colorShadowPrim: Colors.white,
                        borderRadius: GlobalSize.blockSizeVertical! * 1,
                        sizeH: GlobalSize.safeBlockVertical! * 4.5,
                        sizeW: GlobalSize.safeBlockHorizontal! * 8,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Obx(() {
              if (leaveController.isLoading!.value) {
                return const ProgressBar();
              } else {
                return Container();
              }
            })
          ],
        ),
      ),
    );
  }
}
