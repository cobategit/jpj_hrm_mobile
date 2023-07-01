import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:jpj_hrm_mobile/widgets/index.dart';

class HistoryLeaveScreen extends StatelessWidget {
  HistoryLeaveScreen({Key? key}) : super(key: key);

  final LeaveController leaveController = Get.put(LeaveController());
  final AbsensiController absensiController = Get.find<AbsensiController>();

  @override
  Widget build(BuildContext context) {
    leaveController.getLeaveHist();
    GlobalSize().init(context);
    return WillPopScope(
      onWillPop: () {
        leaveController.filterTglLeave?.clear();
        leaveController.valTypeCuti = Rxn<String>();
        leaveController.valTypeStatus = Rxn<String>();
        leaveController.filterlistLeaveHistCuti?.clear();
        leaveController.filterlistLeaveHistStat?.clear();
        AllNavigation.popNav(context, false, null);
        throw true;
      },
      child: Scaffold(
        backgroundColor: GlobalColor.light,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(GlobalSize.blockSizeVertical! * 5.5),
          child: Obx(() => CustomAppBar(
                automaticallyImplyLeading: false,
                textJudul: 'HISTORY LEAVE',
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
              key: leaveController.refreshKey,
              onRefresh: () {
                leaveController.handleRefresh();
                return Future.delayed(const Duration(seconds: 0));
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: GlobalSize.safeBlockHorizontal! * 5,
                  right: GlobalSize.safeBlockHorizontal! * 5,
                  top: GlobalSize.safeBlockVertical! * 1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: Obx(() {
                            if (leaveController
                                .filterlistLeaveHistCuti!.isNotEmpty) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: leaveController
                                    .filterlistLeaveHistCuti!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                      bottom: GlobalSize.safeBlockVertical! * 1,
                                    ),
                                    child: Card(
                                      color: GlobalColor.blue,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            GlobalSize.blockSizeVertical! *
                                                1.5),
                                        side: BorderSide.none,
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: GlobalSize
                                                    .safeBlockHorizontal! *
                                                2.5,
                                            vertical:
                                                GlobalSize.safeBlockVertical! *
                                                    1.5,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Tanggal Mengajukan',
                                                          style: TextStyle(
                                                              color: GlobalColor
                                                                  .light,
                                                              fontSize: GlobalSize
                                                                      .safeBlockVertical! *
                                                                  1.8)),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        'Tanggal Cuti',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        'Type Cuti',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        'Keterangan',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        'Status Cuti',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('  :',
                                                          style: TextStyle(
                                                              color: GlobalColor
                                                                  .light,
                                                              fontSize: GlobalSize
                                                                      .safeBlockVertical! *
                                                                  1.8)),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        '  :',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        '  :',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        '  :',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        '  :',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      '${leaveController.filterlistLeaveHistCuti![index]['filling_date']}',
                                                      style: TextStyle(
                                                          color:
                                                              GlobalColor.light,
                                                          fontSize: GlobalSize
                                                                  .safeBlockVertical! *
                                                              1.8)),
                                                  SizedBox(
                                                    height: GlobalSize
                                                            .safeBlockVertical! *
                                                        1,
                                                  ),
                                                  Text(
                                                    '${leaveController.filterlistLeaveHistCuti![index]['start_leave_date']} s/d ${leaveController.filterlistLeaveHistCuti![index]['end_leave_date']}',
                                                    style: TextStyle(
                                                        color:
                                                            GlobalColor.light,
                                                        fontSize: GlobalSize
                                                                .safeBlockVertical! *
                                                            1.8),
                                                  ),
                                                  SizedBox(
                                                    height: GlobalSize
                                                            .safeBlockVertical! *
                                                        1,
                                                  ),
                                                  Text(
                                                    '${leaveController.filterlistLeaveHistCuti![index]['leave_type_name']}',
                                                    style: TextStyle(
                                                        color:
                                                            GlobalColor.light,
                                                        fontSize: GlobalSize
                                                                .safeBlockVertical! *
                                                            1.8),
                                                  ),
                                                  SizedBox(
                                                    height: GlobalSize
                                                            .safeBlockVertical! *
                                                        1,
                                                  ),
                                                  Text(
                                                    '${leaveController.filterlistLeaveHistCuti![index]['reasons']}',
                                                    style: TextStyle(
                                                        color:
                                                            GlobalColor.light,
                                                        fontSize: GlobalSize
                                                                .safeBlockVertical! *
                                                            1.8),
                                                  ),
                                                  SizedBox(
                                                    height: GlobalSize
                                                            .safeBlockVertical! *
                                                        1,
                                                  ),
                                                  Text(
                                                    leaveController.filterlistLeaveHistCuti![
                                                                    index]
                                                                ['status'] ==
                                                            0
                                                        ? 'Pending'
                                                        : leaveController.filterlistLeaveHistCuti![
                                                                        index][
                                                                    'status'] ==
                                                                1
                                                            ? 'Approved'
                                                            : 'Rejected',
                                                    style: TextStyle(
                                                        color:
                                                            GlobalColor.green,
                                                        fontSize: GlobalSize
                                                                .safeBlockVertical! *
                                                            1.8),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                  );
                                },
                              );
                            } else if (leaveController
                                .filterlistLeaveHistStat!.isNotEmpty) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: leaveController
                                    .filterlistLeaveHistStat!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                      bottom: GlobalSize.safeBlockVertical! * 1,
                                    ),
                                    child: Card(
                                      color: GlobalColor.blue,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            GlobalSize.blockSizeVertical! *
                                                1.5),
                                        side: BorderSide.none,
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: GlobalSize
                                                    .safeBlockHorizontal! *
                                                2.5,
                                            vertical:
                                                GlobalSize.safeBlockVertical! *
                                                    1.5,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Tanggal Mengajukan',
                                                          style: TextStyle(
                                                              color: GlobalColor
                                                                  .light,
                                                              fontSize: GlobalSize
                                                                      .safeBlockVertical! *
                                                                  1.8)),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        'Tanggal Cuti',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        'Type Cuti',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        'Keterangan',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        'Status Cuti',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('  :',
                                                          style: TextStyle(
                                                              color: GlobalColor
                                                                  .light,
                                                              fontSize: GlobalSize
                                                                      .safeBlockVertical! *
                                                                  1.8)),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        '  :',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        '  :',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        '  :',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        '  :',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      '${leaveController.filterlistLeaveHistStat![index]['filling_date']}',
                                                      style: TextStyle(
                                                          color:
                                                              GlobalColor.light,
                                                          fontSize: GlobalSize
                                                                  .safeBlockVertical! *
                                                              1.8)),
                                                  SizedBox(
                                                    height: GlobalSize
                                                            .safeBlockVertical! *
                                                        1,
                                                  ),
                                                  Text(
                                                    '${leaveController.filterlistLeaveHistStat![index]['start_leave_date']} s/d ${leaveController.filterlistLeaveHistStat![index]['end_leave_date']}',
                                                    style: TextStyle(
                                                        color:
                                                            GlobalColor.light,
                                                        fontSize: GlobalSize
                                                                .safeBlockVertical! *
                                                            1.8),
                                                  ),
                                                  SizedBox(
                                                    height: GlobalSize
                                                            .safeBlockVertical! *
                                                        1,
                                                  ),
                                                  Text(
                                                    '${leaveController.filterlistLeaveHistStat![index]['leave_type_name']}',
                                                    style: TextStyle(
                                                        color:
                                                            GlobalColor.light,
                                                        fontSize: GlobalSize
                                                                .safeBlockVertical! *
                                                            1.8),
                                                  ),
                                                  SizedBox(
                                                    height: GlobalSize
                                                            .safeBlockVertical! *
                                                        1,
                                                  ),
                                                  Text(
                                                    '${leaveController.filterlistLeaveHistStat![index]['reasons']}',
                                                    style: TextStyle(
                                                        color:
                                                            GlobalColor.light,
                                                        fontSize: GlobalSize
                                                                .safeBlockVertical! *
                                                            1.8),
                                                  ),
                                                  SizedBox(
                                                    height: GlobalSize
                                                            .safeBlockVertical! *
                                                        1,
                                                  ),
                                                  Text(
                                                    leaveController.filterlistLeaveHistStat![
                                                                    index]
                                                                ['status'] ==
                                                            0
                                                        ? 'Pending'
                                                        : leaveController.filterlistLeaveHistStat![
                                                                        index][
                                                                    'status'] ==
                                                                1
                                                            ? 'Approved'
                                                            : 'Rejected',
                                                    style: TextStyle(
                                                        color:
                                                            GlobalColor.green,
                                                        fontSize: GlobalSize
                                                                .safeBlockVertical! *
                                                            1.8),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount:
                                    leaveController.listLeaveHist!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                      bottom: GlobalSize.safeBlockVertical! * 1,
                                    ),
                                    child: Card(
                                      color: GlobalColor.blue,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            GlobalSize.blockSizeVertical! *
                                                1.5),
                                        side: BorderSide.none,
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: GlobalSize
                                                    .safeBlockHorizontal! *
                                                2.5,
                                            vertical:
                                                GlobalSize.safeBlockVertical! *
                                                    1.5,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Tanggal Mengajukan',
                                                          style: TextStyle(
                                                              color: GlobalColor
                                                                  .light,
                                                              fontSize: GlobalSize
                                                                      .safeBlockVertical! *
                                                                  1.8)),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        'Tanggal Cuti',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        'Type Cuti',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        'Keterangan',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        'Status Cuti',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('  :',
                                                          style: TextStyle(
                                                              color: GlobalColor
                                                                  .light,
                                                              fontSize: GlobalSize
                                                                      .safeBlockVertical! *
                                                                  1.8)),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        '  :',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        '  :',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        '  :',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                      SizedBox(
                                                        height: GlobalSize
                                                                .safeBlockVertical! *
                                                            1,
                                                      ),
                                                      Text(
                                                        '  :',
                                                        style: TextStyle(
                                                            color: GlobalColor
                                                                .light,
                                                            fontSize: GlobalSize
                                                                    .safeBlockVertical! *
                                                                1.8),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      '${leaveController.listLeaveHist![index]['filling_date']}',
                                                      style: TextStyle(
                                                          color:
                                                              GlobalColor.light,
                                                          fontSize: GlobalSize
                                                                  .safeBlockVertical! *
                                                              1.8)),
                                                  SizedBox(
                                                    height: GlobalSize
                                                            .safeBlockVertical! *
                                                        1,
                                                  ),
                                                  Text(
                                                    '${leaveController.listLeaveHist![index]['start_leave_date']} s/d ${leaveController.listLeaveHist![index]['end_leave_date']}',
                                                    style: TextStyle(
                                                        color:
                                                            GlobalColor.light,
                                                        fontSize: GlobalSize
                                                                .safeBlockVertical! *
                                                            1.8),
                                                  ),
                                                  SizedBox(
                                                    height: GlobalSize
                                                            .safeBlockVertical! *
                                                        1,
                                                  ),
                                                  Text(
                                                    '${leaveController.listLeaveHist![index]['leave_type_name']}',
                                                    style: TextStyle(
                                                        color:
                                                            GlobalColor.light,
                                                        fontSize: GlobalSize
                                                                .safeBlockVertical! *
                                                            1.8),
                                                  ),
                                                  SizedBox(
                                                    height: GlobalSize
                                                            .safeBlockVertical! *
                                                        1,
                                                  ),
                                                  Text(
                                                    '${leaveController.listLeaveHist![index]['reasons']}',
                                                    style: TextStyle(
                                                        color:
                                                            GlobalColor.light,
                                                        fontSize: GlobalSize
                                                                .safeBlockVertical! *
                                                            1.8),
                                                  ),
                                                  SizedBox(
                                                    height: GlobalSize
                                                            .safeBlockVertical! *
                                                        1,
                                                  ),
                                                  Text(
                                                    leaveController.listLeaveHist![
                                                                    index]
                                                                ['status'] ==
                                                            0
                                                        ? 'Pending'
                                                        : leaveController.listLeaveHist![
                                                                        index][
                                                                    'status'] ==
                                                                1
                                                            ? 'Approved'
                                                            : 'Rejected',
                                                    style: TextStyle(
                                                        color: leaveController
                                                                            .listLeaveHist![
                                                                        index][
                                                                    'status'] ==
                                                                0
                                                            ? GlobalColor.orange
                                                            : leaveController.listLeaveHist![
                                                                            index][
                                                                        'status'] ==
                                                                    1
                                                                ? GlobalColor
                                                                    .green
                                                                : GlobalColor
                                                                    .red,
                                                        fontSize: GlobalSize
                                                                .safeBlockVertical! *
                                                            1.8),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ),
                                  );
                                },
                              );
                            }
                          })),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => CustomDropdownMenu(
                            value: leaveController.valTypeStatus!.value,
                            hinText: 'Status',
                            isExpanded: true,
                            items: leaveController.listTypeStatus!
                                .map<DropdownMenuItem<String>>((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value['id'].toString(),
                                child: Text(value['status'],
                                    style: GoogleFonts.poppins(
                                        fontSize:
                                            GlobalSize.blockSizeVertical! *
                                                1.8)),
                              );
                            }).toList(),
                            hp: 5.5,
                            wp: 28,
                            margin: EdgeInsets.only(
                                top: GlobalSize.blockSizeVertical! * 1),
                            onChanged: (value) {
                              leaveController.valTypeStatus!(value);
                              leaveController.handleFilterLeavesHist(
                                  'status', value);
                            },
                          ),
                        ),
                        Obx(
                          () => CustomDropdownMenu(
                            value: leaveController.valTypeCuti!.value,
                            hinText: 'Cuti',
                            isExpanded: true,
                            items: leaveController.listTypeCuti!
                                .map<DropdownMenuItem<String>>((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value['id'].toString(),
                                child: Text(value['name'].split(' ')[1],
                                    style: GoogleFonts.poppins(
                                        fontSize:
                                            GlobalSize.blockSizeVertical! *
                                                1.8)),
                              );
                            }).toList(),
                            hp: 5.5,
                            wp: 28,
                            margin: EdgeInsets.only(
                                top: GlobalSize.blockSizeVertical! * 1),
                            onChanged: (value) {
                              leaveController.valTypeCuti!(value);
                              leaveController.handleFilterLeavesHist(
                                  'cuti', value);
                            },
                          ),
                        ),
                        GlobalButtonElevated(
                          onPressed: () {
                            leaveController.handleClearHistory();
                          },
                          tittle: 'CLEAR',
                          fontSize: GlobalSize.blockSizeVertical! * 1.8,
                          color: GlobalColor.light,
                          colorPrim: GlobalColor.red,
                          colorOnPrim: Colors.white.withOpacity(0.9),
                          colorShadowPrim: Colors.white,
                          borderRadius: GlobalSize.blockSizeVertical! * 1,
                          sizeH: GlobalSize.safeBlockVertical! * 4.5,
                          sizeW: GlobalSize.safeBlockHorizontal! * 8,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: GlobalSize.blockSizeVertical! * 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
