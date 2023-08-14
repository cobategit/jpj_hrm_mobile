import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:jpj_hrm_mobile/widgets/index.dart';

class FormCutiScreen extends StatelessWidget {
  FormCutiScreen({super.key});

  final LeaveController leaveController = Get.find<LeaveController>();
  final AbsensiController _absensiController = Get.find<AbsensiController>();

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return WillPopScope(
      onWillPop: () {
        leaveController.handleBackFormMangkir(context);
        throw true;
      },
      child: CloseKeyboardTapAnyWhr(
        child: Scaffold(
          backgroundColor: GlobalColor.light,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(GlobalSize.blockSizeVertical! * 5.5),
            child: CustomAppBar(
              automaticallyImplyLeading: false,
              textJudul: 'REQUEST CUTI',
              textUsername:
                  '${_absensiController.dataProfile!['name'].split(' ')[0]}',
              checkNetwork: _absensiController.checkNetwork!.value,
            ),
          ),
          body: Stack(
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            children: [
              ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                      top: GlobalSize.safeBlockVertical! * 2,
                      bottom: GlobalSize.safeBlockVertical! * 2,
                      left: GlobalSize.blockSizeHorizontal! * 7,
                      right: GlobalSize.blockSizeHorizontal! * 7),
                  child: Form(
                    key: leaveController.formKeyMangkir,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jenis:',
                              style: TextStyle(
                                  fontSize:
                                      GlobalSize.blockSizeVertical! * 2.2),
                            ),
                            Obx(() {
                              return Column(
                                children: leaveController.listTypeCuti!
                                    .asMap()
                                    .map((i, element) => MapEntry(
                                        i,
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: leaveController
                                                              .tmpJenisMangkir![
                                                          'name'] ==
                                                      element['name']
                                                  ? leaveController
                                                          .tmpJenisMangkir![
                                                      'active']
                                                  : false,
                                              onChanged: (bool? value) {
                                                leaveController
                                                    .onChangedJenisCuti(
                                                        leaveController
                                                            .listTypeCuti![i],
                                                        i);
                                              },
                                            ),
                                            Text(
                                              '${element['name']}',
                                              style: TextStyle(
                                                  fontSize: GlobalSize
                                                          .blockSizeVertical! *
                                                      2.2),
                                            ),
                                          ],
                                        )))
                                    .values
                                    .toList(),
                              );
                            }),
                            Obx(() {
                              if (leaveController.tmpJenisMangkir?['name'] ==
                                      'Khusus' &&
                                  leaveController.tmpJenisMangkir?['active']) {
                                return CustomDropdownMenu(
                                  value: leaveController.valTypeLeaveSub!.value,
                                  hinText: 'Pilih',
                                  isExpanded: true,
                                  items: leaveController.listTypeCutiSub!
                                      .map<DropdownMenuItem<String>>(
                                          (dynamic value) {
                                    return DropdownMenuItem<String>(
                                      value: value['id'].toString(),
                                      child: Text(value['nama'],
                                          style: GoogleFonts.poppins(
                                              fontSize: GlobalSize
                                                      .blockSizeVertical! *
                                                  1.8)),
                                    );
                                  }).toList(),
                                  hp: 8,
                                  wp: 100,
                                  onChanged: (value) {
                                    leaveController.valTypeLeaveSub!(value);
                                  },
                                );
                              } else {
                                return Container();
                              }
                            }),
                            Obx(() {
                              if (leaveController.tmpJenisMangkir?['name'] ==
                                      'Khusus' &&
                                  leaveController.tmpJenisMangkir?['active']) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomTextInput(
                                        hp: GlobalSize.blockSizeVertical! * 7,
                                        margin: EdgeInsets.only(
                                            right: GlobalSize
                                                    .blockSizeHorizontal! *
                                                2),
                                        readOnly: true,
                                        contentPadding: EdgeInsets.only(
                                            top: GlobalSize.blockSizeVertical! *
                                                0.5,
                                            left: GlobalSize
                                                    .blockSizeHorizontal! *
                                                2),
                                        textController:
                                            leaveController.fileSakitMangkirTxt,
                                        hintText: 'Upload File',
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      icon: Icon(
                                        Icons.upload_file_outlined,
                                        color: GlobalColor.light,
                                        size: GlobalSize.blockSizeVertical! * 3,
                                      ),
                                      label: Text('Pilih File',
                                          style: TextStyle(
                                              fontSize: GlobalSize
                                                      .blockSizeVertical! *
                                                  2.1)),
                                      onPressed: () {
                                        leaveController.handlePickFileSakit();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            Colors.white.withOpacity(0.9),
                                        backgroundColor: GlobalColor.green,
                                        elevation: 2,
                                        shadowColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            GlobalSize.blockSizeVertical! * 1,
                                          ),
                                        ),
                                        minimumSize: Size(
                                          GlobalSize.safeBlockVertical! * 5,
                                          GlobalSize.safeBlockHorizontal! * 11,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }),
                          ],
                        ),
                        SizedBox(
                          height: GlobalSize.blockSizeVertical! * 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pic Pengganti 1:',
                                    style: TextStyle(
                                        fontSize:
                                            GlobalSize.blockSizeVertical! *
                                                2.2),
                                  ),
                                  Obx(() => CustomDropdownMenu(
                                        margin: EdgeInsets.only(
                                          top:
                                              GlobalSize.blockSizeVertical! * 1,
                                        ),
                                        value: leaveController
                                            .valPicPengganti1!.value,
                                        hinText: 'Pilih',
                                        isExpanded: true,
                                        items: leaveController.listBackEmp!
                                            .map<DropdownMenuItem<String>>(
                                                (dynamic value) {
                                          return DropdownMenuItem<String>(
                                            value: value['id'].toString(),
                                            child: Text(value['name'],
                                                style: GoogleFonts.poppins(
                                                    fontSize: GlobalSize
                                                            .blockSizeVertical! *
                                                        1.8)),
                                          );
                                        }).toList(),
                                        hp: 8,
                                        wp: 42,
                                        onChanged: (value) {
                                          leaveController
                                              .valPicPengganti1!(value);
                                        },
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: GlobalSize.blockSizeHorizontal! * 5,
                            ),
                            if (_absensiController.dataProfile?['role'] ==
                                "Manager") ...[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pic Pengganti 2:',
                                      style: TextStyle(
                                          fontSize:
                                              GlobalSize.blockSizeVertical! *
                                                  2.2),
                                    ),
                                    Obx(() => CustomDropdownMenu(
                                          margin: EdgeInsets.only(
                                            top: GlobalSize.blockSizeVertical! *
                                                1,
                                          ),
                                          value: leaveController
                                              .valPicPengganti2!.value,
                                          hinText: 'Pilih',
                                          isExpanded: true,
                                          items: leaveController.listBackEmp!
                                              .map<DropdownMenuItem<String>>(
                                                  (dynamic value) {
                                            return DropdownMenuItem<String>(
                                              value: value['id'].toString(),
                                              child: Text(value['name'],
                                                  style: GoogleFonts.poppins(
                                                      fontSize: GlobalSize
                                                              .blockSizeVertical! *
                                                          1.8)),
                                            );
                                          }).toList(),
                                          hp: 8,
                                          wp: 50,
                                          onChanged: (value) {
                                            leaveController
                                                .valPicPengganti2!(value);
                                          },
                                        )),
                                  ],
                                ),
                              )
                            ]
                          ],
                        ),
                        SizedBox(
                          height: GlobalSize.blockSizeVertical! * 2,
                        ),
                        Obx(() => Row(
                              children: [
                                if (leaveController.tmpJenisMangkir!['name'] !=
                                    '') ...[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dari Tanggal:',
                                          style: TextStyle(
                                              fontSize: GlobalSize
                                                      .blockSizeVertical! *
                                                  2.2),
                                        ),
                                        CustomTextInput(
                                          wp: GlobalSize.blockSizeHorizontal! *
                                              42,
                                          margin: EdgeInsets.only(
                                            top: GlobalSize.blockSizeVertical! *
                                                1,
                                          ),
                                          hintText: "Dari",
                                          textController:
                                              leaveController.dariTglTxt,
                                          readOnly: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: GlobalSize
                                                    .blockSizeHorizontal! *
                                                2,
                                          ),
                                          onTap: () {
                                            leaveController
                                                .handleSelectDateForm(
                                                    context,
                                                    'dari',
                                                    GlobalSize
                                                        .blockSizeHorizontal!,
                                                    GlobalSize
                                                        .blockSizeVertical!,
                                                    jenis: "cuti");
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                SizedBox(
                                  width: GlobalSize.blockSizeHorizontal! * 5,
                                ),
                                if (leaveController.dariTglVal!.value !=
                                    null) ...[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sampai Tanggal:',
                                          style: TextStyle(
                                              fontSize: GlobalSize
                                                      .blockSizeVertical! *
                                                  2.2),
                                        ),
                                        CustomTextInput(
                                          margin: EdgeInsets.only(
                                            top: GlobalSize.blockSizeVertical! *
                                                1,
                                          ),
                                          hintText: "Sampai",
                                          textController:
                                              leaveController.sampaiTglTxt,
                                          readOnly: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: GlobalSize
                                                    .blockSizeHorizontal! *
                                                2,
                                          ),
                                          onTap: () {
                                            leaveController
                                                .handleSelectDateForm(
                                                    context,
                                                    'sampai',
                                                    GlobalSize
                                                        .blockSizeHorizontal!,
                                                    GlobalSize
                                                        .blockSizeVertical!,
                                                    jenis: "cuti");
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                              ],
                            )),
                        SizedBox(
                          height: GlobalSize.blockSizeVertical! * 2.5,
                        ),
                        Obx(() {
                          if (leaveController.tmpJenisMangkir!['name'] ==
                                  "Tahunan" ||
                              leaveController.tmpJenisMangkir!['name'] ==
                                  "Khusus") {
                            return Text(
                              'Cuti ${leaveController.tmpJenisMangkir!['name']}: ${leaveController.cutiNya?.value}',
                              style: TextStyle(
                                  fontSize:
                                      GlobalSize.blockSizeVertical! * 2.2),
                            );
                          } else {
                            return Container();
                          }
                        }),
                        Obx(() {
                          if (leaveController.tmpJenisMangkir!['name'] ==
                                  "Tahunan" ||
                              leaveController.tmpJenisMangkir!['name'] ==
                                  "Khusus") {
                            return Text(
                              'Hari Cuti Berjalan: ${leaveController.hakCutiJalan?.value}',
                              style: TextStyle(
                                  fontSize:
                                      GlobalSize.blockSizeVertical! * 2.2),
                            );
                          } else {
                            return Container();
                          }
                        }),
                        Obx(() {
                          if (leaveController.tmpJenisMangkir!['name'] ==
                                  "Tahunan" ||
                              leaveController.tmpJenisMangkir!['name'] ==
                                  "Khusus") {
                            return Text(
                              'Cuti Yang Diambil/Diajukan: ${leaveController.jmlhCuti?.value}',
                              style: TextStyle(
                                  fontSize:
                                      GlobalSize.blockSizeVertical! * 2.2),
                            );
                          } else {
                            return Container();
                          }
                        }),
                        Obx(() {
                          if (leaveController.tmpJenisMangkir!['name'] ==
                                  "Tahunan" ||
                              leaveController.tmpJenisMangkir!['name'] ==
                                  "Khusus") {
                            return Text(
                              'Sisa Cuti: ${leaveController.sisaCutiPer?.value}',
                              style: TextStyle(
                                  fontSize:
                                      GlobalSize.blockSizeVertical! * 2.2),
                            );
                          } else {
                            return Container();
                          }
                        }),
                        SizedBox(
                          height: GlobalSize.blockSizeVertical! * 2.5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nomor atau alamat:',
                              style: TextStyle(
                                  fontSize:
                                      GlobalSize.blockSizeVertical! * 2.2),
                            ),
                            CustomTextInput(
                              margin: EdgeInsets.only(
                                top: GlobalSize.blockSizeVertical! * 1,
                              ),
                              labelText:
                                  "Nomor atau Alamat Yang Bisa Dihubungi",
                              textController: leaveController.keteranganTxt,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: GlobalSize.safeBlockVertical! * 1,
                                horizontal: GlobalSize.blockSizeHorizontal! * 2,
                              ),
                              maxLines: null,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: GlobalSize.blockSizeVertical! * 2.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: GlobalButtonElevated(
                                onPressed: () {
                                  leaveController
                                      .handleBackFormMangkir(context);
                                },
                                tittle: 'BACK',
                                fontSize: GlobalSize.blockSizeVertical! * 1.8,
                                color: GlobalColor.light,
                                colorPrim: GlobalColor.grey,
                                colorOnPrim: Colors.white.withOpacity(0.9),
                                colorShadowPrim: Colors.white,
                                borderRadius: GlobalSize.blockSizeVertical! * 1,
                                sizeH: GlobalSize.safeBlockVertical! * 5,
                                sizeW: GlobalSize.safeBlockHorizontal! * 8,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GlobalButtonElevated(
                                onPressed: () {
                                  leaveController.addCuti(
                                      context,
                                      GlobalSize.blockSizeHorizontal!,
                                      GlobalSize.blockSizeVertical!);
                                },
                                tittle: 'SUBMIT',
                                fontSize: GlobalSize.blockSizeVertical! * 1.8,
                                color: GlobalColor.light,
                                colorPrim: GlobalColor.green,
                                colorOnPrim: Colors.white.withOpacity(0.9),
                                colorShadowPrim: Colors.white,
                                borderRadius: GlobalSize.blockSizeVertical! * 1,
                                sizeH: GlobalSize.safeBlockVertical! * 5,
                                sizeW: GlobalSize.safeBlockHorizontal! * 8,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
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
      ),
    );
  }
}
