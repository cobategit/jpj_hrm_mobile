import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/screens/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:jpj_hrm_mobile/widgets/index.dart';
import 'package:intl/intl.dart';

class HistoryCutiScreen extends StatelessWidget {
  HistoryCutiScreen({super.key});

  final LeaveController _leaveController = Get.find<LeaveController>();
  final AbsensiController _absensiController = Get.find<AbsensiController>();

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return WillPopScope(
      onWillPop: () {
        _leaveController.filterDateMangkirText?.clear();
        _leaveController.valTypeStatus!.value = null;
        _leaveController.getCountPendingCuti();
        AllNavigation.popNav(context, false, null);
        throw true;
      },
      child: Scaffold(
        backgroundColor: GlobalColor.light,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(GlobalSize.blockSizeVertical! * 5.5),
          child: Obx(() => CustomAppBar(
                automaticallyImplyLeading: false,
                textJudul: "CUTI",
                textUsername:
                    '${_absensiController.dataProfile!['name'].split(' ')[0]}',
                checkNetwork: _absensiController.checkNetwork!.value,
              )),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: GlobalSize.blockSizeVertical! * 8),
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(248, 12, 85, 245),
            onPressed: () {
              _leaveController.getLeaveType(1);
              _leaveController.getBlockDateLeave("cuti");
              AllNavigation.pushNav(context, FormCutiScreen(), (_) {});
            },
            child: Icon(
              Icons.library_add_outlined,
              color: GlobalColor.light,
              size: GlobalSize.blockSizeVertical! * 5,
            ),
          ),
        ),
        body: Stack(
          children: [
            RefreshIndicator(
              key: _leaveController.refreshKey,
              onRefresh: _leaveController.handleRefreshCuti,
              child: Container(
                padding: EdgeInsets.only(
                    top: GlobalSize.blockSizeVertical! * 3,
                    left: GlobalSize.blockSizeHorizontal! * 5,
                    bottom: GlobalSize.blockSizeVertical! * 2,
                    right: GlobalSize.blockSizeHorizontal! * 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 8,
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: Obx(() => ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount:
                                  _leaveController.listHistoryCuti?.length,
                              itemBuilder: (context, index) {
                                String? fromDate = DateFormat('MMMEd').format(
                                    DateTime.parse(_leaveController
                                        .listHistoryCuti?[index]['from_date']));
                                String? toDate = DateFormat("MMMEd").format(
                                    DateTime.parse(_leaveController
                                        .listHistoryCuti?[index]['to_date']));
                                Color? colorStatus = _leaveController
                                                .listHistoryCuti?[index]
                                            ['status'] ==
                                        "Approved"
                                    ? const Color.fromARGB(248, 8, 235, 65)
                                    : _leaveController.listHistoryCuti?[index]
                                                ['status'] ==
                                            "Rejected"
                                        ? const Color.fromARGB(248, 245, 2, 22)
                                        : _leaveController
                                                        .listHistoryCuti?[index]
                                                    ['status'] ==
                                                "Finished"
                                            ? const Color.fromARGB(
                                                248, 238, 0, 226)
                                            : const Color.fromARGB(
                                                248, 248, 245, 37);
                                return Column(
                                  children: [
                                    Text(
                                      _leaveController.listHistoryCuti![index]
                                          ['no_leaves'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize:
                                            GlobalSize.blockSizeVertical! * 2.3,
                                        color: GlobalColor.dark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom:
                                              GlobalSize.blockSizeVertical! *
                                                  2.5),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                20, 19, 19, 0.043),
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
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "$fromDate s/d $toDate",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: GlobalSize
                                                                .blockSizeVertical! *
                                                            2.6,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: GlobalColor.dark,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: GlobalSize
                                                                .blockSizeVertical! *
                                                            1),
                                                    Text(
                                                      _leaveController.listHistoryCuti![
                                                                      index][
                                                                  'leave_types_sub'] !=
                                                              null
                                                          ? '${_leaveController.listHistoryCuti?[index]['leave_types']} (${_leaveController.listHistoryCuti?[index]['leave_types_sub']})'
                                                          : _leaveController
                                                                  .listHistoryCuti?[
                                                              index]['leave_types'],
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
                                                            1),
                                                    Text(
                                                      "${_leaveController.listHistoryCuti?[index]['total_cuti']} hari",
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
                                                            1),
                                                    Text(
                                                      "pengganti 1: ${_leaveController.listHistoryCuti?[index]['pengganti_one']}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: GlobalSize
                                                                .blockSizeVertical! *
                                                            2.3,
                                                        color: GlobalColor.dark,
                                                      ),
                                                    ),
                                                    if (_leaveController
                                                                    .listHistoryCuti?[
                                                                index]
                                                            ['pengganti_two'] !=
                                                        null) ...[
                                                      SizedBox(
                                                          height: GlobalSize
                                                                  .blockSizeVertical! *
                                                              1),
                                                      Text(
                                                        "pengganti 2: ${_leaveController.listHistoryCuti?[index]['pengganti_two']}",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: GlobalSize
                                                                  .blockSizeVertical! *
                                                              2.3,
                                                          color:
                                                              GlobalColor.dark,
                                                        ),
                                                      ),
                                                    ]
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    _leaveController
                                                        .listHistoryCuti![index]
                                                            ['name_request']
                                                        .split(' ')[0],
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: GlobalSize
                                                              .blockSizeVertical! *
                                                          2.3,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: GlobalColor.dark,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: GlobalSize
                                                              .blockSizeVertical! *
                                                          1),
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        color: colorStatus),
                                                    child: Text(
                                                      _leaveController
                                                              .listHistoryCuti?[
                                                          index]['status'],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: GlobalSize
                                                                .blockSizeVertical! *
                                                            1.8,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: GlobalColor.dark
                                                            .withOpacity(0.8),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: GlobalSize
                                                              .blockSizeVertical! *
                                                          1),
                                                  Row(
                                                    children: [
                                                      if (_leaveController
                                                                  .listHistoryCuti![
                                                              index]['file'] !=
                                                          null) ...[
                                                        InkWell(
                                                            onTap: () {
                                                              _leaveController.handleDownloadPdf(
                                                                  context,
                                                                  _leaveController
                                                                              .listHistoryCuti![
                                                                          index]
                                                                      ['file'],
                                                                  _leaveController
                                                                              .listHistoryCuti![
                                                                          index]
                                                                      [
                                                                      'name_request'],
                                                                  GlobalSize
                                                                      .blockSizeVertical,
                                                                  "Cuti");
                                                            },
                                                            child: Icon(
                                                              Icons.file_open,
                                                              color: Colors
                                                                  .grey[700],
                                                              size: GlobalSize
                                                                      .blockSizeHorizontal! *
                                                                  6.0,
                                                            )),
                                                      ],
                                                      if (_leaveController.listHistoryCuti![
                                                                      index]
                                                                  ['file'] ==
                                                              null &&
                                                          _leaveController.listHistoryCuti![
                                                                      index][
                                                                  'leave_types'] ==
                                                              "Khusus" &&
                                                          _leaveController.listHistoryCuti![
                                                                      index]
                                                                  ['status'] ==
                                                              "Pending") ...[
                                                        InkWell(
                                                            onTap: () {
                                                              _leaveController.handleUpdateUploadCuti(
                                                                  context,
                                                                  GlobalSize
                                                                      .blockSizeHorizontal,
                                                                  GlobalSize
                                                                      .blockSizeVertical,
                                                                  _leaveController
                                                                          .listHistoryCuti![
                                                                      index]);
                                                            },
                                                            child: Icon(
                                                              Icons.attach_file,
                                                              color: Colors
                                                                  .yellow[700],
                                                              size: GlobalSize
                                                                      .blockSizeHorizontal! *
                                                                  6.0,
                                                            )),
                                                      ],
                                                      SizedBox(
                                                        width: GlobalSize
                                                                .blockSizeHorizontal! *
                                                            4,
                                                      ),
                                                      if (_leaveController.listHistoryCuti![
                                                                      index]
                                                                  ['status'] ==
                                                              "Pending" &&
                                                          _absensiController
                                                                      .dataProfile![
                                                                  'role'] ==
                                                              "Manager") ...[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                                onTap: () {
                                                                  _leaveController.updateStatusCuti(
                                                                      context,
                                                                      GlobalSize
                                                                          .blockSizeHorizontal!,
                                                                      GlobalSize
                                                                          .blockSizeVertical!,
                                                                      _leaveController
                                                                              .listHistoryCuti![
                                                                          index],
                                                                      "Approved");
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .assignment_turned_in_rounded,
                                                                  color: Colors
                                                                          .green[
                                                                      700],
                                                                  size: GlobalSize
                                                                          .blockSizeHorizontal! *
                                                                      6.0,
                                                                )),
                                                            SizedBox(
                                                              width: GlobalSize
                                                                      .blockSizeHorizontal! *
                                                                  4,
                                                            ),
                                                            InkWell(
                                                                onTap: () {
                                                                  _leaveController.updateStatusCuti(
                                                                      context,
                                                                      GlobalSize
                                                                          .blockSizeHorizontal!,
                                                                      GlobalSize
                                                                          .blockSizeVertical!,
                                                                      _leaveController
                                                                              .listHistoryCuti![
                                                                          index],
                                                                      "Rejected");
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .backspace_rounded,
                                                                  color: Colors
                                                                      .red[700],
                                                                  size: GlobalSize
                                                                          .blockSizeHorizontal! *
                                                                      6.0,
                                                                ))
                                                          ],
                                                        )
                                                      ],
                                                      if (_leaveController.listHistoryCuti![
                                                                      index]
                                                                  ['status'] ==
                                                              "Approved" &&
                                                          _absensiController
                                                                      .dataProfile![
                                                                  'role'] ==
                                                              "Hrd") ...[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                                onTap: () {
                                                                  _leaveController.updateStatusCuti(
                                                                      context,
                                                                      GlobalSize
                                                                          .blockSizeHorizontal!,
                                                                      GlobalSize
                                                                          .blockSizeVertical!,
                                                                      _leaveController
                                                                              .listHistoryCuti![
                                                                          index],
                                                                      "Finished");
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .assignment_turned_in_rounded,
                                                                  color: Colors
                                                                          .green[
                                                                      700],
                                                                  size: GlobalSize
                                                                          .blockSizeHorizontal! *
                                                                      6.0,
                                                                )),
                                                            SizedBox(
                                                              width: GlobalSize
                                                                      .blockSizeHorizontal! *
                                                                  4,
                                                            ),
                                                            InkWell(
                                                                onTap: () {
                                                                  _leaveController.updateStatusCuti(
                                                                      context,
                                                                      GlobalSize
                                                                          .blockSizeHorizontal!,
                                                                      GlobalSize
                                                                          .blockSizeVertical!,
                                                                      _leaveController
                                                                              .listHistoryCuti![
                                                                          index],
                                                                      "Rejected");
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .backspace_rounded,
                                                                  color: Colors
                                                                      .red[700],
                                                                  size: GlobalSize
                                                                          .blockSizeHorizontal! *
                                                                      6.0,
                                                                ))
                                                          ],
                                                        )
                                                      ]
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CustomTextInput(
                              textController:
                                  _leaveController.filterDateMangkirText,
                              wp: GlobalSize.blockSizeHorizontal! * 26,
                              hp: GlobalSize.blockSizeVertical! * 5.5,
                              margin: EdgeInsets.only(
                                  top: GlobalSize.blockSizeVertical! * 0.5,
                                  right: GlobalSize.blockSizeHorizontal! * 4),
                              hintText: "Bulan-Tahun",
                              readOnly: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: GlobalSize.blockSizeHorizontal! * 2,
                              ),
                              onTap: () {
                                _leaveController.handleFilterDateCuti(context);
                              },
                            ),
                            Obx(
                              () => CustomDropdownMenu(
                                value: _leaveController.valTypeStatus!.value,
                                hinText: 'Status',
                                isExpanded: true,
                                items: _leaveController.listTypeStatus!
                                    .map<DropdownMenuItem<String>>(
                                        (dynamic value) {
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
                                wp: 26,
                                margin: EdgeInsets.only(
                                    top: GlobalSize.blockSizeVertical! * 0.3,
                                    right: GlobalSize.blockSizeHorizontal! * 4),
                                onChanged: (value) {
                                  _leaveController
                                      .handleFilterStatusCuti(value);
                                },
                              ),
                            ),
                            GlobalButtonElevated(
                              onPressed: () {
                                _leaveController.handleClearHistoryCuti();
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
      ),
    );
  }
}
