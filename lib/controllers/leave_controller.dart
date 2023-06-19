import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/models/index.dart';
import 'package:jpj_hrm_mobile/services/index.dart';
import 'package:jpj_hrm_mobile/utils/allNav/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../screens/index.dart';
import '../utils/alertDialog/index.dart';

class LeaveController extends GetxController {
  RxList<dynamic>? listTypeCuti;
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
  TextEditingController? filterTglLeave;
  RxMap? backUpEmpTxt;
  Rxn<String>? dariTglVal;
  TextEditingController? dariTglTxt;
  TextEditingController? sampaiTglTxt;
  TextEditingController? keteranganTxt;
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
  RxList? sampleBlockDate;

  @override
  void onInit() {
    filterTglLeave = TextEditingController();
    backUpEmpTxt = {}.obs;
    dariTglTxt = TextEditingController();
    sampaiTglTxt = TextEditingController();
    keteranganTxt = TextEditingController();
    valTypeCuti = Rxn<String>();
    valBackupEmp = Rxn<String>();
    dariTglVal = Rxn<String>();
    valTypeStatus = Rxn<String>();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    listTypeCuti = <dynamic>[].obs;
    listBackEmp = <dynamic>[].obs;
    listnameBackEmp = <String>[].obs;
    listSumCuti = <dynamic>[].obs;
    listLeaveHist = <dynamic>[].obs;
    blockoutDate = <DateTime>[].obs;
    filterlistLeaveHistCuti = <dynamic>[].obs;
    filterlistLeaveHistStat = <dynamic>[].obs;
    listTypeStatus = [
      {"id": 0, "status": "Pending"},
      {"id": 2, "status": "Rejected"},
      {"id": 1, "status": "Approved"},
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
    super.onInit();
  }

  @override
  void onClose() {
    filterTglLeave?.clear();
    backUpEmpTxt!({});
    dariTglTxt?.clear();
    sampaiTglTxt?.clear();
    valTypeCuti!('');
    keteranganTxt?.clear();
    super.onClose();
  }

  @override
  void onReady() {
    getLeaveType();
    getLeaveSummary();
    getBackupEmp();
    getLeaveHist();
    sampleBlockDate = [
      '2023-03-05',
      '2023-03-04',
      '2023-03-01',
      '2023-03-10',
      '2023-03-12'
    ].obs;
    dariTglTxt?.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dariTglVal!(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    super.onReady();
  }

  getLeaveType() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: Path.typeleaves,
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    listTypeCuti!(res['data']);
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

  getBlockDateLeave() async {
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

  Future<void> handleRefresh() async {
    refreshKey?.currentState?.show(atTop: false);
    getLeaveHist();
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

  handleSelectDateForm(BuildContext ctx, type, hp) async {
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
      final dateParse = DateTime.parse(element);
      // final diffDate = dateParse.difference(selectDate).inDays;
      blockoutDate?.add(dateParse);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showCupertinoDialog(
        context: ctx,
        builder: (BuildContext context) => AlertDialog(
            content: SizedBox(
              height: hp * 50,
              child: SfCalendar(
                view: CalendarView.month,
                allowDragAndDrop: true,
                onTap: (val) {
                  if (kDebugMode) {
                    print('val ${val.date}');
                  }
                  if (type == 'dari') {
                    dariTglTxt?.text =
                        DateFormat('yyyy-MM-dd').format(val.date as DateTime);
                    dariTglVal!(
                        DateFormat('yyyy-MM-dd').format(val.date as DateTime));
                  } else {
                    sampaiTglTxt?.text =
                        DateFormat('yyyy-MM-dd').format(val.date as DateTime);
                  }
                },
                minDate: firstDate,
                maxDate: lastDate,
                blackoutDates: blockoutDate,
                blackoutDatesTextStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
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
}
