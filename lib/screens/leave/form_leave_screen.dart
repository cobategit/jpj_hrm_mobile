import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:jpj_hrm_mobile/widgets/index.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';

class FormLeaveScreen extends StatelessWidget {
  FormLeaveScreen({Key? key}) : super(key: key);

  final LeaveController leaveController = Get.put(LeaveController());
  final AbsensiController absensiController = Get.find<AbsensiController>();

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return WillPopScope(
      onWillPop: () {
        AllNavigation.popNav(context, false, null);
        leaveController.dariTglTxt?.clear();
        leaveController.sampaiTglTxt?.clear();
        leaveController.backUpEmpTxt!({});
        leaveController.keteranganTxt?.clear();
        throw true;
      },
      child: CloseKeyboardTapAnyWhr(
        child: Scaffold(
          backgroundColor: GlobalColor.light,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(GlobalSize.blockSizeVertical! * 5.5),
            child: CustomAppBar(
              automaticallyImplyLeading: false,
              textJudul: 'REQUESTED LEAVE',
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                            bottom: GlobalSize.safeBlockVertical! * 2,
                            left: GlobalSize.blockSizeHorizontal! * 7,
                            right: GlobalSize.blockSizeHorizontal! * 7),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextInput(
                                  margin: EdgeInsets.only(
                                    top: GlobalSize.blockSizeVertical! * 1,
                                  ),
                                  hintText: "Dari Tanggal",
                                  hp: GlobalSize.blockSizeVertical! * 5.5,
                                  wp: GlobalSize.safeBlockHorizontal! * 41,
                                  textController: leaveController.dariTglTxt,
                                  readOnly: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        GlobalSize.blockSizeHorizontal! * 2,
                                  ),
                                  onTap: () {
                                    leaveController.handleSelectDateForm(
                                        context,
                                        'dari',
                                        GlobalSize.blockSizeHorizontal!,
                                        GlobalSize.blockSizeVertical!);
                                  },
                                ),
                                Obx(() {
                                  if (leaveController.dariTglVal!.value !=
                                      null) {
                                    return CustomTextInput(
                                      margin: EdgeInsets.only(
                                        top: GlobalSize.blockSizeVertical! * 1,
                                      ),
                                      hintText: "Sampai Tanggal",
                                      hp: GlobalSize.blockSizeVertical! * 5.5,
                                      wp: GlobalSize.safeBlockHorizontal! * 41,
                                      textController:
                                          leaveController.sampaiTglTxt,
                                      readOnly: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            GlobalSize.blockSizeHorizontal! * 2,
                                      ),
                                      onTap: () {
                                        leaveController.handleSelectDateForm(
                                            context,
                                            'sampai',
                                            GlobalSize.blockSizeHorizontal!,
                                            GlobalSize.blockSizeVertical!);
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                })
                              ],
                            ),
                            SizedBox(
                              height: GlobalSize.blockSizeVertical! * 2,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => CustomDropdownMenu(
                                    value: leaveController.valTypeCuti!.value,
                                    hinText: 'Cuti',
                                    isExpanded: true,
                                    items: leaveController.listTypeCuti!
                                        .map<DropdownMenuItem<String>>(
                                            (dynamic value) {
                                      return DropdownMenuItem<String>(
                                        value: value['id'].toString(),
                                        child: Text(value['name'],
                                            style: GoogleFonts.poppins(
                                                fontSize: GlobalSize
                                                        .blockSizeVertical! *
                                                    1.7)),
                                      );
                                    }).toList(),
                                    hp: 5.5,
                                    wp: 41,
                                    margin: EdgeInsets.only(
                                        top: GlobalSize.blockSizeVertical! * 1),
                                    onChanged: (value) {
                                      leaveController.valTypeCuti!(value);
                                    },
                                  ),
                                ),
                                Container(
                                  color: GlobalColor.light,
                                  height: GlobalSize.blockSizeVertical! * 5.5,
                                  width: GlobalSize.blockSizeHorizontal! * 41,
                                  margin: EdgeInsets.only(
                                      top: GlobalSize.blockSizeVertical! * 1),
                                  child: DropdownSearch<String>(
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    showSelectedItems: true,
                                    dropdownSearchDecoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              GlobalSize.blockSizeHorizontal! *
                                                  2),
                                      hintText: 'Backup Employee',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            GlobalSize.safeBlockVertical! * 1.7,
                                        color: GlobalColor.blue,
                                      ),
                                      focusColor: GlobalColor.blue,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: GlobalColor.blue)),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              GlobalSize.blockSizeVertical! *
                                                  1),
                                          borderSide: const BorderSide(
                                              color: Colors.white)),
                                    ),
                                    items: leaveController.listnameBackEmp!,
                                    itemAsString: (val) =>
                                        val!.split(' ')[0].toLowerCase(),
                                    popupItemBuilder: (BuildContext context,
                                        String? item, bool isSelected) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: !isSelected
                                            ? null
                                            : BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white,
                                              ),
                                        child: ListTile(
                                          selected: isSelected,
                                          title: Text(
                                            item ?? '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: GlobalSize
                                                        .safeBlockVertical! *
                                                    1.7,
                                                fontFamily: 'IconGlobal',
                                                color: GlobalColor.blue),
                                          ),
                                        ),
                                      );
                                    },
                                    onChanged: (val) {
                                      leaveController.backUpEmpTxt!(
                                          leaveController.listBackEmp!
                                              .where((el) =>
                                                  el['name'].contains(val))
                                              .toList()[0]);
                                    },
                                    // selectedItem: "",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: GlobalSize.blockSizeVertical! * 2,
                            ),
                            CustomTextInput(
                              margin: EdgeInsets.only(
                                top: GlobalSize.blockSizeVertical! * 1,
                              ),
                              labelText: "Keterangan Cuti",
                              textController: leaveController.keteranganTxt,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: GlobalSize.safeBlockVertical! * 1,
                                horizontal: GlobalSize.blockSizeHorizontal! * 2,
                              ),
                              maxLines: null,
                            ),
                            SizedBox(
                              height: GlobalSize.blockSizeVertical! * 2,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GlobalButtonElevated(
                                onPressed: () {
                                  leaveController.handleReqLeave({
                                    "id_leave_types":
                                        leaveController.valTypeCuti?.value,
                                    'id_user_shift':
                                        leaveController.backUpEmpTxt?['id'],
                                    "filling_date": DateFormat('yyyy-MM-dd')
                                        .format(DateTime.now()),
                                    "start_leave_date":
                                        leaveController.dariTglTxt?.text,
                                    "end_leave_date":
                                        leaveController.sampaiTglTxt?.text,
                                    "reasons":
                                        leaveController.keteranganTxt?.text,
                                    "id_dept": absensiController
                                        .dataProfile!['id_department']
                                  }, context, GlobalSize.blockSizeVertical!);
                                },
                                tittle: 'SUBMIT',
                                fontSize: GlobalSize.blockSizeVertical! * 1.8,
                                color: GlobalColor.light,
                                colorPrim: GlobalColor.green,
                                colorOnPrim: Colors.white.withOpacity(0.9),
                                colorShadowPrim: Colors.white,
                                borderRadius: GlobalSize.blockSizeVertical! * 1,
                                sizeH: GlobalSize.safeBlockVertical! * 4.5,
                                sizeW: GlobalSize.safeBlockHorizontal! * 8,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
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
