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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: Obx(
                      () {
                        if (absensiController.listLogAtt!.isNotEmpty) {
                          return ListView.builder(
                            padding: EdgeInsets.only(
                                left: GlobalSize.blockSizeHorizontal! * 7,
                                right: GlobalSize.blockSizeHorizontal! * 7,
                                top: GlobalSize.blockSizeVertical! * 2),
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
                                      color: Color.fromRGBO(20, 19, 19, 0.043),
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
                                        GlobalSize.blockSizeHorizontal! * 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
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
                                                ' ${absensiController.listLogAtt![index]['check_out'] ?? ' 00:00'} ',
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
                                        ),
                                        Expanded(
                                          child: Column(
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
                                          ),
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
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: GlobalSize.blockSizeHorizontal! * 7,
                      right: GlobalSize.blockSizeHorizontal! * 7,
                      bottom: GlobalSize.blockSizeVertical! * 1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextInput(
                          margin: EdgeInsets.only(
                            top: GlobalSize.blockSizeVertical! * 1,
                          ),
                          wp: GlobalSize.blockSizeHorizontal! * 26,
                          hp: GlobalSize.blockSizeVertical! * 5.5,
                          hintText: "Dari",
                          textController: absensiController.dariTglTxt,
                          readOnly: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: GlobalSize.blockSizeHorizontal! * 2,
                          ),
                          onTap: () {
                            absensiController.handleSelectDateForm(
                                context,
                                'dari',
                                GlobalSize.blockSizeHorizontal!,
                                GlobalSize.blockSizeVertical!);
                          },
                        ),
                        CustomTextInput(
                          margin: EdgeInsets.only(
                            top: GlobalSize.blockSizeVertical! * 1,
                          ),
                          wp: GlobalSize.blockSizeHorizontal! * 26,
                          hp: GlobalSize.blockSizeVertical! * 5.5,
                          hintText: "Sampai",
                          textController: absensiController.sampaiTglTxt,
                          readOnly: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: GlobalSize.blockSizeHorizontal! * 2,
                          ),
                          onTap: () {
                            absensiController.handleSelectDateForm(
                                context,
                                'sampai',
                                GlobalSize.blockSizeHorizontal!,
                                GlobalSize.blockSizeVertical!);
                          },
                        ),
                        GlobalButtonElevated(
                          onPressed: () {
                            absensiController.handleClearHistoryPresent();
                          },
                          tittle: 'CLEAR',
                          fontSize: GlobalSize.blockSizeVertical! * 1.8,
                          color: GlobalColor.light,
                          colorPrim: GlobalColor.red,
                          colorOnPrim: Colors.white.withOpacity(0.9),
                          colorShadowPrim: Colors.white,
                          borderRadius: GlobalSize.blockSizeVertical! * 1,
                          sizeH: GlobalSize.safeBlockVertical! * 5,
                          sizeW: GlobalSize.safeBlockHorizontal! * 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
