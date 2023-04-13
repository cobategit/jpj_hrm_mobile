import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:jpj_hrm_mobile/widgets/index.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatelessWidget {
  AttendanceScreen({Key? key}) : super(key: key);

  final AbsensiController absensiController = Get.put(AbsensiController());

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return WillPopScope(
      onWillPop: () {
        AllNavigation.popNav(context, false, null);
        absensiController.filterTglLeave?.clear();
        throw true;
      },
      child: Scaffold(
        backgroundColor: GlobalColor.grey.withOpacity(0.02),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(GlobalSize.blockSizeVertical! * 5.5),
          child: Obx(() => CustomAppBar(
                textJudul: 'REPORT ATTENDANCE',
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
              child: Container(
                padding: EdgeInsets.only(
                  top: GlobalSize.blockSizeVertical! * 2,
                  left: GlobalSize.blockSizeHorizontal! * 7,
                  right: GlobalSize.blockSizeHorizontal! * 7,
                ),
                width: GlobalSize.blockSizeHorizontal! * 100,
                decoration: BoxDecoration(
                  color: GlobalColor.light,
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(GlobalSize.blockSizeVertical! * 4.5),
                    topRight:
                        Radius.circular(GlobalSize.blockSizeVertical! * 4.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: Obx(
                          () {
                            if (absensiController.listLogAtt!.isNotEmpty) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: absensiController.listLogAtt!.length,
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
                                                7,
                                            vertical:
                                                GlobalSize.safeBlockVertical! *
                                                    1.2,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Tanggal Check',
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
                                                        'Jam Masuk',
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
                                                        'Jam Keluar',
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
                                                        'Check In',
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
                                                        'Check Out',
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
                                                        'Working Hrs',
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
                                                      DateFormat.yMMMEd().format(
                                                          DateTime.parse(
                                                              absensiController
                                                                          .listLogAtt![
                                                                      index]
                                                                  ['date'])),
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
                                                    absensiController
                                                            .listLogAtt![index]
                                                        ['start'],
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
                                                    absensiController
                                                            .listLogAtt![index]
                                                        ['end'],
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
                                                    absensiController
                                                                .listLogAtt![
                                                            index]['check_in'] ??
                                                        '-',
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
                                                    absensiController
                                                                    .listLogAtt![
                                                                index]
                                                            ['check_out'] ??
                                                        '-',
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
                                                    absensiController
                                                            .listLogAtt![index]
                                                        ['duration'],
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
                                                    absensiController.listLogAtt![
                                                                    index]
                                                                ['check_out'] !=
                                                            null
                                                        ? absensiController
                                                                .listLogAtt![
                                                            index]['behavior']
                                                        : '-',
                                                    style: TextStyle(
                                                        color:
                                                            GlobalColor.light,
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
                              return ListView();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
