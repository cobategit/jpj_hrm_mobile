import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:jpj_hrm_mobile/widgets/index.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatelessWidget {
  AttendanceScreen({Key? key}) : super(key: key);

  final AbsensiController absensiController = Get.find<AbsensiController>();

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return Scaffold(
      backgroundColor: GlobalColor.grey.withOpacity(0.02),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalSize.blockSizeVertical! * 5.5),
        child: Obx(() => CustomAppBar(
              textJudul: 'PRESENT',
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
                  topLeft: Radius.circular(GlobalSize.blockSizeVertical! * 4.5),
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
                                Color? colorBehavior = absensiController
                                            .listLogAtt![index]['behavior'] ==
                                        "Late"
                                    ? const Color.fromARGB(248, 245, 2, 22)
                                    : absensiController.listLogAtt![index]
                                                ['behavior'] ==
                                            "On Time"
                                        ? const Color.fromARGB(248, 215, 230, 9)
                                        : const Color.fromARGB(249, 2, 245, 63);
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom:
                                          GlobalSize.blockSizeVertical! * 1.5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromRGBO(20, 19, 19, 0.043),
                                        spreadRadius: 0,
                                        blurRadius: 5,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          GlobalSize.blockSizeHorizontal! *
                                              4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                DateFormat.yMMMEd().format(
                                                    DateTime.parse(
                                                        absensiController
                                                                .listLogAtt![
                                                            index]['date'])),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: GlobalSize
                                                          .blockSizeVertical! *
                                                      2.6,
                                                  fontWeight: FontWeight.w700,
                                                  color: GlobalColor.dark,
                                                ),
                                              ),
                                              SizedBox(
                                                  height: GlobalSize
                                                          .blockSizeVertical! *
                                                      1),
                                              Text(
                                                '${absensiController.listLogAtt![index]['check_in'] ?? '00:00'} '
                                                's/d'
                                                '${absensiController.listLogAtt![index]['check_out'] ?? ' 00:00'} ',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: GlobalSize
                                                          .blockSizeVertical! *
                                                      2.3,
                                                  color: GlobalColor.dark,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                absensiController.listLogAtt![
                                                                index]
                                                            ['duration'] ==
                                                        '-'
                                                    ? '0 Jam 0 Menit'
                                                    : absensiController
                                                            .listLogAtt![index]
                                                        ['duration'],
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: GlobalSize
                                                          .blockSizeVertical! *
                                                      2.3,
                                                  color: GlobalColor.dark,
                                                ),
                                              ),
                                              SizedBox(
                                                height: GlobalSize
                                                        .blockSizeVertical! *
                                                    1,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    color: colorBehavior),
                                                child: Text(
                                                  absensiController
                                                          .listLogAtt?[index]
                                                      ['behavior'],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: GlobalSize
                                                            .blockSizeVertical! *
                                                        1.8,
                                                    fontWeight: FontWeight.w400,
                                                    color: GlobalColor.dark
                                                        .withOpacity(0.8),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: GlobalSize
                                                          .blockSizeVertical! *
                                                      1),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
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
    );
  }
}
