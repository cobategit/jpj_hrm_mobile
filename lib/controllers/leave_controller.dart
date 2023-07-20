import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/models/index.dart';
import 'package:jpj_hrm_mobile/services/index.dart';
import 'package:jpj_hrm_mobile/utils/allNav/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../screens/index.dart';
import '../utils/alertDialog/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class LeaveController extends GetxController {
  RxList<dynamic>? listTypeCuti;
  RxList<dynamic>? listTypeCutiSub;
  RxList<dynamic>? listSumCuti;
  RxList<dynamic>? listBackEmp;
  RxList<String>? listnameBackEmp;
  RxList<dynamic>? listLeaveHist;
  RxList<dynamic>? filterlistLeaveHistCuti;
  RxList<dynamic>? filterlistLeaveHistStat;
  RxList<DateTime>? blockoutDate;
  RxList? listTypeStatus;
  Rxn<String>? valTypeCuti;
  Rxn<String>? valBackupEmp;
  Rxn<String>? valTypeStatus;
  Rxn<String>? valTypeLeaveSub;
  TextEditingController? filterTglLeave;
  RxMap? backUpEmpTxt;
  Rxn<String>? dariTglVal;
  TextEditingController? dariTglTxt;
  TextEditingController? sampaiTglTxt;
  TextEditingController? keteranganTxt;
  TextEditingController? fileSakitMangkirTxt;
  TextEditingController? timeFromTugasKantor;
  TextEditingController? timeToTugasKantor;
  TextEditingController? filterDateMangkirText;
  GlobalKey<RefreshIndicatorState>? refreshKey;
  RxInt? sumcutiTahunan;
  RxInt? sisacutiTahunan;
  RxInt? quotacutiTahunan;
  RxInt? sumcutiLahir;
  RxInt? quotacutiLahir;
  RxInt? sumcutiKhusus;
  RxInt? quotacutiKhusus;
  RxInt? sumcutiBesar;
  RxInt? quotacutiBesar;
  RxBool? isLoading;
  RxList<dynamic>? sampleBlockDate;
  RxList<dynamic>? listHistoryMangkir;
  RxBool? selectedJenisMangkir;
  RxMap? tmpJenisMangkir;
  Rxn<File>? fileSakitMangkir;
  AbsensiController? _absensiController;
  RxMap<String, dynamic>? paramsHistoryMangkir;

  @override
  void onInit() {
    filterTglLeave = TextEditingController();
    backUpEmpTxt = {}.obs;
    dariTglTxt = TextEditingController();
    sampaiTglTxt = TextEditingController();
    keteranganTxt = TextEditingController();
    fileSakitMangkirTxt = TextEditingController();
    timeFromTugasKantor = TextEditingController();
    timeToTugasKantor = TextEditingController();
    filterDateMangkirText = TextEditingController();
    valTypeCuti = Rxn<String>();
    valBackupEmp = Rxn<String>();
    dariTglVal = Rxn<String>();
    valTypeStatus = Rxn<String>();
    valTypeLeaveSub = Rxn<String>();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    listTypeCuti = <dynamic>[].obs;
    listBackEmp = <dynamic>[].obs;
    listnameBackEmp = <String>[].obs;
    listSumCuti = <dynamic>[].obs;
    listLeaveHist = <dynamic>[].obs;
    listTypeCutiSub = <dynamic>[].obs;
    blockoutDate = <DateTime>[].obs;
    filterlistLeaveHistCuti = <dynamic>[].obs;
    filterlistLeaveHistStat = <dynamic>[].obs;
    listHistoryMangkir = <dynamic>[].obs;
    fileSakitMangkir = Rxn<File>();
    sampleBlockDate = <dynamic>[].obs;
    listTypeStatus = [
      {"id": 0, "status": "Pending"},
      {"id": 1, "status": "Approved"},
      {"id": 2, "status": "Rejected"},
    ].obs;
    isLoading = false.obs;
    sumcutiTahunan = 0.obs;
    sumcutiLahir = 0.obs;
    sumcutiKhusus = 0.obs;
    sumcutiBesar = 0.obs;
    sisacutiTahunan = 0.obs;
    quotacutiTahunan = 0.obs;
    quotacutiBesar = 0.obs;
    quotacutiKhusus = 0.obs;
    quotacutiLahir = 0.obs;
    selectedJenisMangkir = false.obs;
    tmpJenisMangkir = {'id': 0, 'name': '', 'active': false}.obs;
    _absensiController = Get.find<AbsensiController>();
    paramsHistoryMangkir = RxMap<String, dynamic>({});
    super.onInit();
  }

  @override
  void onClose() {
    filterTglLeave?.clear();
    tmpJenisMangkir!({});
    backUpEmpTxt!({});
    dariTglTxt?.clear();
    sampaiTglTxt?.clear();
    valTypeCuti!('');
    keteranganTxt?.clear();
    filterDateMangkirText?.clear();
    super.onClose();
  }

  @override
  void onReady() {
    getLeaveSummary();
    getBackupEmp();
    getLeaveHist();
    dariTglTxt?.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dariTglVal!(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    super.onReady();
  }

  onChangedJenisMangkir(dynamic element, int i) {
    final name = element['name'];
    final select = !element['selected'];
    listTypeCuti?[i]['selected'] = select;
    tmpJenisMangkir!['name'] = name;
    tmpJenisMangkir!['active'] = select;
    valTypeLeaveSub = Rxn<String>();
    fileSakitMangkir = Rxn<File>();
    fileSakitMangkirTxt?.clear();
    timeFromTugasKantor?.clear();
    timeToTugasKantor?.clear();
    if (name == 'Urusan Pribadi / Kantor') {
      getLeaveTypeSub(element['id']);
    }
  }

  handlePickFileSakit() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      fileSakitMangkirTxt!.text = result.files.single.name;
      fileSakitMangkir!(File(result.files.single.path.toString()));
    }
  }

  handlePickTimeTugasKantor(BuildContext context, String? type) async {
    TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (pickedTime != null) {
      if (type == "from") {
        timeFromTugasKantor!.text =
            pickedTime.hour.toString() + ':' + pickedTime.minute.toString();
      }
      if (type == "to") {
        timeToTugasKantor!.text =
            pickedTime.hour.toString() + ':' + pickedTime.minute.toString();
      }
    }
  }

  Future<void> handleRefresh() async {
    refreshKey?.currentState?.show(atTop: false);
    getLeaveHist();
  }

  Future<void> handleRefreshMangkir() async {
    refreshKey?.currentState?.show(atTop: false);
    getHistoryMangkir();
  }

  handleSelectDateFilter(BuildContext context) async {
    DateTime selecDatae = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: selecDatae,
      firstDate: DateTime(2000),
      lastDate: DateTime(5000),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: "Select From Date",
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
    );

    if (picked != null && picked != selecDatae) {
      filterTglLeave?.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  handleSelectDateForm(BuildContext ctx, type, wp, hp) async {
    DateTime selectDate = DateTime.now();
    late final DateTime firstDate;
    late final DateTime lastDate;

    if (type == 'sampai') {
      if (dariTglTxt?.text == '') {
        firstDate = DateTime.now();
        lastDate = DateTime(5000);
      } else {
        firstDate = DateTime.parse(dariTglTxt!.text);
        lastDate = selectDate.add(const Duration(days: 30));
      }
    } else {
      firstDate = DateTime.now();
      lastDate = selectDate.add(const Duration(days: 30));
    }

    sampleBlockDate?.forEach((element) {
      final dateParse = DateTime.parse(element['date']);
      // final diffDate = dateParse.difference(selectDate).inDays;
      blockoutDate?.add(dateParse);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showCupertinoDialog(
        context: ctx,
        builder: (BuildContext context) => AlertDialog(
            content: SizedBox(
              width: wp * 100,
              height: hp * 50,
              child: SfCalendar(
                view: CalendarView.month,
                allowDragAndDrop: true,
                onTap: (val) {
                  if (type == 'dari') {
                    dariTglTxt?.text =
                        DateFormat('yyyy-MM-dd').format(val.date!);
                    dariTglVal!(DateFormat('yyyy-MM-dd').format(val.date!));
                  } else {
                    sampaiTglTxt?.text =
                        DateFormat('yyyy-MM-dd').format(val.date!);
                  }
                },
                minDate: firstDate,
                maxDate: lastDate,
                blackoutDates: blockoutDate,
                blackoutDatesTextStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: hp * 2.1,
                    color: Colors.pinkAccent,
                    decoration: TextDecoration.lineThrough),
                showDatePickerButton: true,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  AllNavigation.popNav(context, false, null);
                },
                child: const Text('OK'),
              ),
            ]),
      );
    });
  }

  handleFilterDateMangkir(BuildContext context) async {
    DateTime selectDate = DateTime.now();

    final picked = await showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: selectDate,
    );

    if (picked != null && picked != selectDate) {
      if (picked.month < 10) {
        filterDateMangkirText?.text = '${picked.year}-0${picked.month}';
      } else {
        filterDateMangkirText?.text = '${picked.year}-${picked.month}';
      }
      paramsHistoryMangkir?['month'] = DateFormat('MM')
          .format(DateTime.parse("${filterDateMangkirText!.text}-01"));
      paramsHistoryMangkir?['years'] = DateFormat('yyyy')
          .format(DateTime.parse("${filterDateMangkirText!.text}-01"));
      getHistoryMangkir();
    }
  }

  handleFilterStatusMangkir(String? value) {
    valTypeStatus!(value);
    paramsHistoryMangkir?['status'] = value;
    getHistoryMangkir();
  }

  handleClearHistoryMangkir() {
    filterDateMangkirText?.clear();
    valTypeStatus?.value = null;
    paramsHistoryMangkir?['month'] = null;
    paramsHistoryMangkir?['years'] = null;
    paramsHistoryMangkir?['status'] = null;

    getHistoryMangkir();
  }

  handleBackFormMangkir(context) {
    tmpJenisMangkir?['name'] = '';
    tmpJenisMangkir?['active'] = false;
    dariTglTxt?.clear();
    AllNavigation.popNav(context, false, null);
  }

  handleReqLeave(Map<String, dynamic> data, ctx, hp) async {
    SharedPreferences session = await SharedPreferences.getInstance();

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: Path.leavereq,
        body: data,
        token: session.getString('token'),
        isToken: true);

    if (dariTglTxt!.text.isEmpty ||
        sampaiTglTxt!.text.isEmpty ||
        keteranganTxt!.text.isEmpty ||
        backUpEmpTxt!.isEmpty ||
        valTypeCuti!.value == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AlertDialogMsg.showCupertinoDialogSimple(
            ctx,
            'Informasi',
            'Harap isi field yang kosong',
            [
              ElevatedButton(
                onPressed: () async {
                  AllNavigation.popNav(ctx, false, null);
                  dariTglTxt?.clear();
                  sampaiTglTxt?.clear();
                  keteranganTxt?.clear();
                  backUpEmpTxt!({});
                  valTypeCuti!(null);
                },
                child: const Text('OK'),
              ),
            ],
            hp);
      });
    } else {
      if (kDebugMode) {
        print('data leave= $data');
      }
      isLoading!(true);

      final Map<String, dynamic> res = await PostData().postData(apiModel);
      isLoading!(false);

      if (res['success']) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await AlertDialogMsg.showCupertinoDialogSimple(
              ctx,
              'Informasi',
              'Berhasil Ajukan Cuti...',
              [
                ElevatedButton(
                  onPressed: () async {
                    AllNavigation.pushRemoveUntilNav(
                        ctx,
                        const BottomNavScreen(
                            selectedIdx: 2, selectedIdxLeave: 0),
                        (_) => {});
                    dariTglTxt?.clear();
                    sampaiTglTxt?.clear();
                    keteranganTxt?.clear();
                    backUpEmpTxt!({});
                    valTypeCuti!(null);
                  },
                  child: const Text('OK'),
                ),
              ],
              hp);
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await AlertDialogMsg.showCupertinoDialogSimple(
              ctx,
              'Informasi',
              '${res['message']}',
              [
                ElevatedButton(
                  onPressed: () async {
                    AllNavigation.popNav(ctx, false, null);
                    dariTglTxt?.clear();
                    sampaiTglTxt?.clear();
                    keteranganTxt?.clear();
                    backUpEmpTxt!({});
                    valTypeCuti!(null);
                  },
                  child: const Text('OK'),
                ),
              ],
              hp);
        });
      }
    }
  }

  handleClearHistory() {
    valTypeCuti?.value = null;
    valTypeStatus?.value = null;
    valTypeLeaveSub?.value = null;
    filterlistLeaveHistCuti?.clear();
    filterlistLeaveHistStat?.clear();
    getLeaveHist();
  }

  handleFilterLeavesHist(String type, String value) {
    if (type == 'cuti') {
      filterlistLeaveHistCuti?.clear();
      filterlistLeaveHistStat?.clear();

      if (valTypeCuti!.value == null) {
        return;
      }

      listLeaveHist?.forEach((element) {
        if (element['id_leave_types'] == int.parse(value)) {
          filterlistLeaveHistCuti?.add(element);
        }
      });
    }

    if (type == 'status') {
      filterlistLeaveHistStat?.clear();
      filterlistLeaveHistCuti?.clear();

      if (valTypeStatus!.value == null) {
        return;
      }

      listLeaveHist?.forEach((element) {
        if (element['status'] == int.parse(value)) {
          filterlistLeaveHistStat?.add(element);
        }
      });
    }
  }

  getLeaveType(int? category) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: '${Path.typeleaves}?category=$category',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    listTypeCuti!(res['data']);
    listTypeCuti?.forEach((element) {
      element['selected'] = false;
    });
  }

  getLeaveTypeSub(int? idleavetypes) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: '${Path.leavetypesub}?id_leave_types=$idleavetypes',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    listTypeCutiSub!(res['data']);
  }

  getLeaveSummary() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: Path.leavesummary,
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    listSumCuti!(res['data']);
    sumcutiTahunan!(int.parse(listSumCuti![0]['sisa']));
    sisacutiTahunan!(int.parse(listSumCuti![0]['leave_total']));
    quotacutiTahunan!(listSumCuti![0]['quota']);

    sumcutiLahir!(int.parse(listSumCuti![1]['sisa']));
    quotacutiLahir!(listSumCuti![1]['quota']);

    sumcutiBesar!(int.parse(listSumCuti![2]['sisa']));
    quotacutiBesar!(listSumCuti![2]['quota']);

    sumcutiKhusus!(int.parse(listSumCuti![3]['sisa']));
    quotacutiKhusus!(listSumCuti![3]['quota']);
  }

  getBackupEmp() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: Path.backupem,
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    listBackEmp!(res['data']);
    res['data'].forEach((val) {
      listnameBackEmp!.add(val['name']);
    });
  }

  getLeaveHist() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: Path.leavehistory,
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    listLeaveHist!(res['data']);
  }

  Future<void> getBlockDateLeave() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: Path.blockdateleave,
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    sampleBlockDate!(res['data']);
  }

  Future<void> getHistoryMangkir() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path:
            '${Path.historyMangkir}?role=${paramsHistoryMangkir?['role']}&id=${paramsHistoryMangkir?['id']}&month=${paramsHistoryMangkir?['month']}&years=${paramsHistoryMangkir?['years']}&status=${paramsHistoryMangkir?['status']}',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    listHistoryMangkir!(res['data']);
  }

  Future<void> updateStatusMangkir(ctx, wp, hp, data, status) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AlertDialogMsg.showCupertinoDialogSimple(
        ctx,
        'Peringatan!',
        'Anda Yakin Ingin $status Mangkir ?.',
        [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: GlobalColor.light,
              elevation: 2,
              backgroundColor: GlobalColor.grey,
              shadowColor: GlobalColor.light.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  hp! * 1,
                ),
              ),
              minimumSize: Size(
                wp! * 10,
                hp! * 4,
              ),
            ),
            onPressed: () {
              AllNavigation.popNav(ctx, false, null);
            },
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: GlobalColor.light,
              elevation: 2,
              backgroundColor: GlobalColor.green,
              shadowColor: GlobalColor.light.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  hp! * 1,
                ),
              ),
              minimumSize: Size(
                wp! * 10,
                hp! * 4,
              ),
            ),
            onPressed: () async {
              AllNavigation.popNav(ctx, false, null);
              isLoading!(true);
              SharedPreferences session = await SharedPreferences.getInstance();
              final Map<String, dynamic> bodyData = {
                "id": data['id'],
                "status": status,
                "id_user_approved": _absensiController?.dataProfile?['id']
              };

              final ApiModel apiModel = ApiModel(
                url: Api.apiUrl,
                path: Path.updateStatusMangkir,
                body: bodyData,
                token: session.getString('token'),
                isToken: true,
              );

              final Map<String, dynamic> res =
                  await PostData().patchData(apiModel);

              isLoading!(false);
              if (res['success']) {
                getHistoryMangkir();
              } else {
                AlertDialogMsg.showCupertinoDialogSimple(
                  ctx,
                  'Infomasi!',
                  '${res['message']}',
                  [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: GlobalColor.light,
                        elevation: 2,
                        backgroundColor: GlobalColor.grey,
                        shadowColor: GlobalColor.light.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            hp! * 1,
                          ),
                        ),
                        minimumSize: Size(
                          wp! * 10,
                          hp! * 4,
                        ),
                      ),
                      onPressed: () {
                        AllNavigation.popNav(ctx, false, null);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                  hp,
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
        hp,
      );
    });
  }

  Future<void> addMangkir() async {}
}
