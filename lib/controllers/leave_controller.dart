import 'dart:convert';
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
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import '../widgets/index.dart';

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
  Rxn<String>? valPicPengganti1;
  Rxn<String>? valPicPengganti2;
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
  GlobalKey<FormState>? formKeyMangkir;
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
  RxList<dynamic>? listHistoryCuti;
  RxBool? selectedJenisMangkir;
  RxMap? tmpJenisMangkir;
  Rxn<File>? fileSakitMangkir;
  Rxn<dynamic>? fileSakitMangkirWebBytes;
  // Rxn<PlatformFile>? fileSakitMangkirWeb;
  AbsensiController? _absensiController;
  RxMap<String, dynamic>? paramsHistoryMangkir;
  RxMap<String, dynamic>? paramsHistoryCuti;
  RxMap<String, dynamic>? warningCutiKhusus;
  RxInt? countPendingMangkir;
  RxInt? countPendingCuti;
  RxInt? jmlhCuti;
  RxInt? hakCutiJalan;
  RxInt? cutiNya;
  RxInt? sisaCutiPer;
  RxInt? warningSakit;

  @override
  void onInit() async {
    filterTglLeave = TextEditingController();
    backUpEmpTxt = {}.obs;
    dariTglTxt = TextEditingController();
    sampaiTglTxt = TextEditingController();
    keteranganTxt = TextEditingController();
    fileSakitMangkirTxt = TextEditingController();
    timeFromTugasKantor = TextEditingController();
    timeToTugasKantor = TextEditingController();
    filterDateMangkirText = TextEditingController();
    formKeyMangkir = GlobalKey<FormState>();
    valTypeCuti = Rxn<String>();
    valBackupEmp = Rxn<String>();
    dariTglVal = Rxn<String>();
    valTypeStatus = Rxn<String>();
    valTypeLeaveSub = Rxn<String>();
    valPicPengganti1 = Rxn<String>();
    valPicPengganti2 = Rxn<String>();
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
    listHistoryCuti = <dynamic>[].obs;
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
    countPendingMangkir = 0.obs;
    countPendingCuti = 0.obs;
    jmlhCuti = 0.obs;
    hakCutiJalan = 0.obs;
    cutiNya = 0.obs;
    sisaCutiPer = 0.obs;
    warningSakit = 0.obs;
    selectedJenisMangkir = false.obs;
    tmpJenisMangkir = {'id': 0, 'name': '', 'active': false}.obs;
    _absensiController = Get.find<AbsensiController>();
    paramsHistoryMangkir = RxMap<String, dynamic>({});
    paramsHistoryCuti = RxMap<String, dynamic>({});
    warningCutiKhusus = RxMap<String, dynamic>({});
    fileSakitMangkirWebBytes = Rxn<dynamic>(null);
    // fileSakitMangkirWeb = Rxn<PlatformFile>(null);
    getCountPendingMangkir();
    getCountPendingCuti();
    getLeaveSummary();
    getBackupEmp();
    getLeaveHist();
    super.onInit();
  }

  @override
  void onClose() {
    filterTglLeave?.clear();
    tmpJenisMangkir = {'id': 0, 'name': '', 'active': false}.obs;
    backUpEmpTxt!({});
    dariTglTxt?.clear();
    sampaiTglTxt?.clear();
    valTypeCuti!('');
    keteranganTxt?.clear();
    filterDateMangkirText?.clear();
    super.onClose();
  }

  onChangedJenisMangkir(dynamic element, int i) {
    final id = element['id'];
    final name = element['name'];
    final select = !element['selected'];
    listTypeCuti?[i]['selected'] = select;
    tmpJenisMangkir!['name'] = name;
    tmpJenisMangkir!['active'] = select;
    tmpJenisMangkir!['id'] = id;
    valTypeLeaveSub = Rxn<String>();
    fileSakitMangkir = Rxn<File>();
    fileSakitMangkirTxt?.clear();
    fileSakitMangkirWebBytes!(null);
    timeFromTugasKantor?.clear();
    timeToTugasKantor?.clear();
    if (name == 'Lainnya') {
      getLeaveTypeSub(element['id']);
    }
    if (element['selected'] == false) {
      tmpJenisMangkir!['name'] = '';
      tmpJenisMangkir!['id'] = 0;
      dariTglTxt?.clear();
    }
  }

  onChangedJenisCuti(dynamic element, int i) {
    final id = element['id'];
    final name = element['name'];
    final select = !element['selected'];
    listTypeCuti?[i]['selected'] = select;
    tmpJenisMangkir!['name'] = name;
    tmpJenisMangkir!['active'] = select;
    tmpJenisMangkir!['id'] = id;
    valTypeLeaveSub!.value = null;
    fileSakitMangkir = Rxn<File>();
    fileSakitMangkirWebBytes!(null);
    warningCutiKhusus?.clear();
    fileSakitMangkirTxt?.clear();
    jmlhCuti = 0.obs;
    cutiNya = 0.obs;
    hakCutiJalan = 0.obs;
    sisaCutiPer = 0.obs;
    if (name == 'Khusus') {
      getLeaveTypeSub(element['id']);
    }
    if (element['selected'] == false) {
      tmpJenisMangkir!['name'] = '';
      tmpJenisMangkir!['id'] = 0;
      dariTglTxt?.clear();
      sampaiTglTxt?.clear();
      dariTglVal!.value = null;
      valPicPengganti1!.value = null;
      valPicPengganti2!.value = null;
    }
  }

  handlePickFileSakit() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);

    if (result != null) {
      fileSakitMangkirTxt!.text = result.files.single.name;
      if (kIsWeb) {
        fileSakitMangkirWebBytes!(result.files.first.bytes);
      } else {
        fileSakitMangkir!(File(result.files.single.path.toString()));
      }
    }
  }

  handlePickTimeTugasKantor(BuildContext context, String? type) async {
    // TimeOfDay? initialTime;

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
    getHistoryMangkir("mangkir");
  }

  Future<void> handleRefreshCuti() async {
    refreshKey?.currentState?.show(atTop: false);
    getHistoryCuti();
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

  Future<List<String>> getDaysInBetween(DateTime start, DateTime end) async {
    List<String> days = [];

    for (int i = 0; i <= end.difference(start).inDays; i++) {
      final dateParse = start.add(Duration(days: i));
      days.add(DateFormat('yyyy-MM-dd').format(dateParse));
    }
    return days;
  }

  handleSelectDateForm(BuildContext ctx, type, wp, hp,
      {String? jenis = ''}) async {
    DateTime selectDate = DateTime.now();
    late final DateTime firstDate;
    late final DateTime lastDate;

    if (type == 'sampai') {
      if (dariTglTxt?.text == '') {
        firstDate = DateTime.now();
        lastDate = DateTime(5000);
      } else {
        firstDate = DateTime.parse(dariTglTxt!.text);
        lastDate = firstDate.add(const Duration(days: 90));
      }
    } else {
      if (jenis == "mangkir") {
        firstDate = DateTime.now().add(const Duration(days: -3));
        lastDate = selectDate.add(const Duration(days: 3));
      } else {
        firstDate = DateTime.now();
        lastDate = firstDate.add(const Duration(days: 90));
      }
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
              height: hp * 60,
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

                  if (sampaiTglTxt!.text.isNotEmpty) {
                    List<String> betweenDays = await getDaysInBetween(
                        DateTime.parse(dariTglTxt!.text),
                        DateTime.parse(sampaiTglTxt!.text));
                    sampleBlockDate?.forEach((element1) {
                      for (int i = 0; i < betweenDays.length; i++) {
                        if (element1['date'] == betweenDays[i]) {
                          betweenDays.removeWhere(
                              (element2) => element2 == element1['date']);
                        }
                      }
                    });

                    jmlhCuti!(betweenDays.length);
                  }

                  if (jenis == "mangkir" &&
                      tmpJenisMangkir?['name'] == "Sakit") {
                    await getWarningSakit(
                        _absensiController?.dataProfile?['id'], 4, 1);

                    if (warningSakit!.value >= 3) {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await AlertDialogMsg.showCupertinoDialogSimple(
                            ctx,
                            'Peringatan',
                            'Anda mengajukan sakit tanpa surat sudah $warningSakit kali...',
                            [
                              ElevatedButton(
                                onPressed: () async {
                                  AllNavigation.popNav(ctx, false, null);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                            hp);
                      });
                    }
                  }

                  if (tmpJenisMangkir?['name'] == "Khusus" &&
                      valTypeLeaveSub!.value != null) {
                    await getWarningCutiKhusus(
                        _absensiController?.dataProfile?['id'],
                        tmpJenisMangkir?['id'],
                        valTypeLeaveSub!.value,
                        1);
                  }
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
      getHistoryMangkir("mangkir");
    }
  }

  handleFilterDateCuti(BuildContext context) async {
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
      paramsHistoryCuti?['month'] = DateFormat('MM')
          .format(DateTime.parse("${filterDateMangkirText!.text}-01"));
      paramsHistoryCuti?['years'] = DateFormat('yyyy')
          .format(DateTime.parse("${filterDateMangkirText!.text}-01"));
      getHistoryCuti();
    }
  }

  handleFilterStatusMangkir(String? value) {
    valTypeStatus!(value);
    paramsHistoryMangkir?['status'] = value;
    getHistoryMangkir("mangkir");
  }

  handleFilterStatusCuti(String? value) {
    valTypeStatus!(value);
    paramsHistoryCuti?['status'] = value;
    getHistoryCuti();
  }

  handleClearHistoryMangkir() {
    filterDateMangkirText?.clear();
    valTypeStatus?.value = null;
    paramsHistoryMangkir?['month'] = null;
    paramsHistoryMangkir?['years'] = null;
    paramsHistoryMangkir?['status'] = null;

    getHistoryMangkir("mangkir");
  }

  handleClearHistoryCuti() {
    filterDateMangkirText?.clear();
    valTypeStatus?.value = null;
    paramsHistoryCuti?['month'] = null;
    paramsHistoryCuti?['years'] = null;
    paramsHistoryCuti?['status'] = null;

    getHistoryCuti();
  }

  handleBackFormMangkir(context) {
    tmpJenisMangkir?['id'] = 0;
    tmpJenisMangkir?['name'] = '';
    tmpJenisMangkir?['active'] = false;
    dariTglTxt?.clear();
    keteranganTxt?.clear();
    sampleBlockDate?.clear();
    blockoutDate?.clear();
    dariTglVal!.value = null;
    sampaiTglTxt?.clear();
    valPicPengganti1!.value = null;
    valPicPengganti2!.value = null;
    jmlhCuti = 0.obs;
    cutiNya = 0.obs;
    hakCutiJalan = 0.obs;
    sisaCutiPer = 0.obs;
    AllNavigation.popNav(context, false, null);
  }

  handleDownloadPdf(context, fileSakit, name, hp, type) async {
    FileDownloader.downloadFile(
      url: fileSakit,
      name: "$type-$name",
      onProgress: (fileName, progress) {
        isLoading!(true);
      },
      onDownloadCompleted: (value) {
        isLoading!(false);
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await AlertDialogMsg.showCupertinoDialogSimple(
              context,
              'Informasi',
              'File berhasil didownload: $value',
              [
                ElevatedButton(
                  onPressed: () async {
                    AllNavigation.popNav(context, false, null);
                  },
                  child: const Text('OK'),
                ),
              ],
              hp);
        });
      },
      onDownloadError: (errorMessage) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await AlertDialogMsg.showCupertinoDialogSimple(
              context,
              'Informasi',
              'File gagal didownload, $errorMessage',
              [
                ElevatedButton(
                  onPressed: () async {
                    AllNavigation.popNav(context, false, null);
                  },
                  child: const Text('OK'),
                ),
              ],
              hp);
        });
      },
    );
  }

  handleUpdateUploadCuti(ctx, wp, hp, data) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showCupertinoDialog(
        context: ctx,
        builder: (BuildContext context) => AlertDialog(
          content: SizedBox(
            width: wp * 100,
            height: hp * 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextInput(
                    hp: hp * 7,
                    margin: EdgeInsets.only(right: wp * 2),
                    readOnly: true,
                    contentPadding:
                        EdgeInsets.only(top: hp * 0.5, left: wp * 2),
                    textController: fileSakitMangkirTxt,
                    hintText: 'Upload File',
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.upload_file_outlined,
                    color: GlobalColor.light,
                    size: hp * 3,
                  ),
                  label:
                      Text('Pilih File', style: TextStyle(fontSize: hp * 2.1)),
                  onPressed: () {
                    handlePickFileSakit();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white.withOpacity(0.9),
                    backgroundColor: GlobalColor.green,
                    elevation: 2,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        hp * 1,
                      ),
                    ),
                    minimumSize: Size(
                      hp * 5,
                      wp * 11,
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                AllNavigation.popNav(ctx, false, null);
                if (fileSakitMangkirTxt!.text.isNotEmpty ||
                    fileSakitMangkir!.value != null) {
                  SharedPreferences session =
                      await SharedPreferences.getInstance();
                  final Map<String, dynamic> bodyData = {
                    "id_leave": data['id'].toString(),
                    "file_cuti": kIsWeb
                        ? base64Encode(fileSakitMangkirWebBytes!.value)
                        : fileSakitMangkir?.value?.path,
                    'file_cuti_name': fileSakitMangkirTxt!.text
                  };

                  final ApiModel apiModel = ApiModel(
                    url: Api.apiUrl,
                    path: Path.updateFileCuti,
                    body: bodyData,
                    token: session.getString('token'),
                    isToken: true,
                  );

                  isLoading!(true);
                  late Map<String, dynamic> res = {};

                  if (kIsWeb) {
                    res = await PostData().postData(apiModel);
                  } else {
                    res = await PostData().postFormData(apiModel, "POST");
                  }
                  isLoading!(false);

                  if (res['success']) {
                    fileSakitMangkirTxt?.clear();
                    fileSakitMangkir = Rxn<File>();
                    fileSakitMangkirWebBytes = Rxn(null);
                    getHistoryCuti();
                    getCountPendingCuti();
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await AlertDialogMsg.showCupertinoDialogSimple(
                          ctx,
                          'Informasi!',
                          'Terjadi kesalahan add cuti',
                          [
                            ElevatedButton(
                              onPressed: () async {
                                AllNavigation.popNav(ctx, false, null);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                          hp);
                    });
                  }
                }
              },
              child: const Text('OK'),
            )
          ],
        ),
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

  Future<void> getBlockDateLeave(type) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path:
            '${Path.blockdateleave}?id_user=${_absensiController?.dataProfile?['id']}&type=$type',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    sampleBlockDate!(res['data']);
  }

  Future<void> getHistoryMangkir(type) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path:
            '${Path.historyMangkir}?type=$type&role=${paramsHistoryMangkir?['role']}&id=${paramsHistoryMangkir?['id']}&month=${paramsHistoryMangkir?['month']}&years=${paramsHistoryMangkir?['years']}&status=${paramsHistoryMangkir?['status']}',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    listHistoryMangkir!(res['data']);
  }

  Future<void> getHistoryCuti() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path:
            '${Path.historyMangkir}?type=cuti&role=${paramsHistoryCuti?['role']}&id=${paramsHistoryCuti?['id']}&month=${paramsHistoryCuti?['month']}&years=${paramsHistoryCuti?['years']}&status=${paramsHistoryCuti?['status']}',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    listHistoryCuti!(res['data']);
  }

  Future<void> getWarningSakit(idUserReq, idLeaveTypes, status) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path:
            '${Path.warningSakit}?id_user_request=$idUserReq&id_leave_types=$idLeaveTypes&status=$status',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    warningSakit!(res['data']);
  }

  Future<void> getWarningCutiKhusus(
      idUserReq, idLeaveTypes, idLeaveTypesSub, status) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path:
            '${Path.warningCutiKhusus}?id_user_request=$idUserReq&id_leave_types=$idLeaveTypes&id_leave_types_subs=$idLeaveTypesSub&status=$status',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    if (res['cuti_khusus']['total'] != null) {
      warningCutiKhusus?['total_cuti'] = res['total_cuti'];
      warningCutiKhusus?['maksimal_cuti'] = res['cuti_khusus']['total'];
      cutiNya!(res['cuti_khusus']['total']);
      hakCutiJalan!(res['cuti_khusus']['total'] - res['total_cuti']);
      sisaCutiPer!(hakCutiJalan!.value - jmlhCuti!.value);
    }
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
                path: Path.updateStatusMangkirCuti,
                body: bodyData,
                token: session.getString('token'),
                isToken: true,
              );

              final Map<String, dynamic> res =
                  await PostData().patchData(apiModel);

              isLoading!(false);
              if (res['success']) {
                getHistoryMangkir("mangkir");
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

  Future<void> updateStatusCuti(ctx, wp, hp, data, status) async {
    if (data['leave_types'] == "Khusus" &&
        data['file'] == null &&
        status == "Approved") {
      return WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AlertDialogMsg.showCupertinoDialogSimple(
            ctx,
            'Peringatan!',
            'Belum upload file bukti, harap untuk upload',
            [
              ElevatedButton(
                onPressed: () async {
                  AllNavigation.popNav(ctx, false, null);
                },
                child: const Text('OK'),
              ),
            ],
            hp);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AlertDialogMsg.showCupertinoDialogSimple(
        ctx,
        'Peringatan!',
        'Anda Yakin Ingin $status Cuti ?.',
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
                path: Path.updateStatusMangkirCuti,
                body: bodyData,
                token: session.getString('token'),
                isToken: true,
              );

              final Map<String, dynamic> res =
                  await PostData().patchData(apiModel);

              isLoading!(false);
              if (res['success']) {
                getHistoryCuti();
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

  Future<void> getCountPendingMangkir() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path:
            '${Path.countPendingMangkir}?id_parent_department=${_absensiController?.dataProfile?['id_parent_department']}',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    countPendingMangkir!(res['pending']);
  }

  Future<void> getCountPendingCuti() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path:
            '${Path.countPendingCuti}?id_parent_department=${_absensiController?.dataProfile?['id_parent_department']}',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    countPendingCuti!(res['pending']);
  }

  _dialogFormMangkirCuti(context, wp, hp) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AlertDialogMsg.showCupertinoDialogSimple(
          context,
          'Peringatan!',
          'Harap isi form yang kosong',
          [
            ElevatedButton(
              onPressed: () async {
                AllNavigation.popNav(context, false, null);
              },
              child: const Text('OK'),
            ),
          ],
          hp);
    });
  }

  Future<void> addMangkir(ctx, wp, hp) async {
    if (tmpJenisMangkir!['id'] == 0 || dariTglTxt!.text.isEmpty) {
      return _dialogFormMangkirCuti(ctx, wp, hp);
    }

    if ((tmpJenisMangkir!['id'] == 6 && valTypeLeaveSub!.value == null) ||
        dariTglTxt!.text.isEmpty) {
      return _dialogFormMangkirCuti(ctx, wp, hp);
    }

    if ((tmpJenisMangkir!['id'] == 6 &&
            valTypeLeaveSub!.value == "3" &&
            (timeFromTugasKantor!.text.isEmpty ||
                timeToTugasKantor!.text.isEmpty)) ||
        dariTglTxt!.text.isEmpty) {
      return _dialogFormMangkirCuti(ctx, wp, hp);
    }

    SharedPreferences session = await SharedPreferences.getInstance();
    final Map<String, dynamic> bodyData = {
      "id_user": _absensiController!.dataProfile!['id'].toString(),
      "nik": _absensiController!.dataProfile!['nik'].split("-")[1],
      "id_dept": _absensiController!.dataProfile!['id_department'].toString(),
      "id_leave_types": tmpJenisMangkir!['id'].toString(),
      "reasons": keteranganTxt!.text,
      "start_leave_date": dariTglTxt!.text
    };

    if (valTypeLeaveSub!.value != null) {
      bodyData['id_leave_types_sub'] = valTypeLeaveSub!.value;
    }

    if (timeFromTugasKantor!.text.isNotEmpty &&
        timeToTugasKantor!.text.isNotEmpty) {
      bodyData['from_time_tugas_kantor'] = timeFromTugasKantor!.text;
      bodyData['to_time_tugas_kantor'] = timeToTugasKantor!.text;
    }

    if (fileSakitMangkirTxt!.text.isNotEmpty) {
      bodyData['file_sakit'] = kIsWeb
          ? base64Encode(fileSakitMangkirWebBytes!.value)
          : fileSakitMangkir?.value?.path;
      bodyData['file_sakit_name'] = fileSakitMangkirTxt!.text;
    }

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: Path.addMangkir,
        body: bodyData,
        token: session.getString('token'),
        isToken: true);

    isLoading!(true);
    late Map<String, dynamic> res = {};

    if (kIsWeb) {
      res = await PostData().postData(apiModel);
    } else {
      res = await PostData().postFormData(apiModel, 'POST');
    }
    isLoading!(false);

    if (res['success']) {
      tmpJenisMangkir?['id'] = 0;
      tmpJenisMangkir?['name'] = '';
      tmpJenisMangkir?['active'] = false;
      valTypeLeaveSub!.value = null;
      fileSakitMangkirTxt!.clear();
      fileSakitMangkir = Rxn<File>();
      fileSakitMangkirWebBytes = Rxn(null);
      keteranganTxt!.clear();
      dariTglTxt?.clear();
      timeFromTugasKantor!.clear();
      timeToTugasKantor!.clear();
      getHistoryMangkir("mangkir");
      getCountPendingMangkir();
      AllNavigation.popNav(ctx, false, null);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AlertDialogMsg.showCupertinoDialogSimple(
            ctx,
            'Informasi!',
            'Terjadi kesalahan add mangkir',
            [
              ElevatedButton(
                onPressed: () async {
                  AllNavigation.popNav(ctx, false, null);
                },
                child: const Text('OK'),
              ),
            ],
            hp);
      });
    }
  }

  Future<void> addCuti(ctx, wp, hp) async {
    if (tmpJenisMangkir!['id'] == 0 ||
        dariTglTxt!.text.isEmpty ||
        sampaiTglTxt!.text.isEmpty ||
        valPicPengganti1!.value == null) {
      return _dialogFormMangkirCuti(ctx, wp, hp);
    }

    if ((tmpJenisMangkir!['id'] == 2 && valTypeLeaveSub!.value == null) ||
        dariTglTxt!.text.isEmpty ||
        sampaiTglTxt!.text.isEmpty) {
      return _dialogFormMangkirCuti(ctx, wp, hp);
    }

    if (warningCutiKhusus!.isNotEmpty) {
      if (tmpJenisMangkir!['name'] == "Khusus" &&
          (jmlhCuti!.value + warningCutiKhusus!['total_cuti']) >
              warningCutiKhusus!['maksimal_cuti']) {
        return WidgetsBinding.instance.addPostFrameCallback((_) async {
          await AlertDialogMsg.showCupertinoDialogSimple(
              ctx,
              'Peringatan!',
              'Cuti melebihi dari kententuan',
              [
                ElevatedButton(
                  onPressed: () async {
                    AllNavigation.popNav(ctx, false, null);
                  },
                  child: const Text('OK'),
                ),
              ],
              hp);
        });
      }
    }

    SharedPreferences session = await SharedPreferences.getInstance();
    final Map<String, dynamic> bodyData = {
      "id_user": _absensiController?.dataProfile!['id'].toString(),
      "nik": _absensiController?.dataProfile!['nik'].split("-")[1].toString(),
      "id_dept": _absensiController?.dataProfile!['id_department'].toString(),
      "id_leave_types": tmpJenisMangkir!['id'].toString(),
      "start_leave_date": dariTglTxt?.text,
      "end_leave_date": sampaiTglTxt?.text,
      "total_cuti": jmlhCuti?.value.toString(),
      "id_user_shift_one": valPicPengganti1?.value.toString(),
      "reasons": keteranganTxt?.text
    };

    if (valTypeLeaveSub!.value != null) {
      bodyData['id_leave_types_sub'] = valTypeLeaveSub!.value;
    }

    if (valPicPengganti2!.value != null) {
      bodyData['id_user_shift_two'] = valPicPengganti2!.value;
    }

    if (fileSakitMangkirTxt!.text.isNotEmpty) {
      bodyData['file_cuti'] = kIsWeb
          ? base64Encode(fileSakitMangkirWebBytes!.value)
          : fileSakitMangkir?.value?.path;
      bodyData['file_cuti_name'] = fileSakitMangkirTxt!.text;
    }

    final ApiModel apiModel = ApiModel(
      url: Api.apiUrl,
      path: Path.addCuti,
      body: bodyData,
      token: session.getString('token'),
      isToken: true,
    );

    isLoading!(true);
    late Map<String, dynamic> res = {};

    if (kIsWeb) {
      res = await PostData().postData(apiModel);
    } else {
      res = await PostData().postFormData(apiModel, "POST");
    }
    isLoading!(false);

    if (res['success']) {
      tmpJenisMangkir?['id'] = 0;
      tmpJenisMangkir?['name'] = '';
      tmpJenisMangkir?['active'] = false;
      valTypeLeaveSub!.value = null;
      valPicPengganti1!.value = null;
      valPicPengganti2!.value = null;
      keteranganTxt?.clear();
      dariTglTxt?.clear();
      dariTglVal!.value = null;
      sampaiTglTxt?.clear();
      fileSakitMangkirTxt?.clear();
      fileSakitMangkir = Rxn<File>();
      fileSakitMangkirWebBytes = Rxn(null);
      getHistoryCuti();
      getCountPendingCuti();
      jmlhCuti = 0.obs;
      cutiNya = 0.obs;
      hakCutiJalan = 0.obs;
      sisaCutiPer = 0.obs;
      AllNavigation.popNav(ctx, false, null);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AlertDialogMsg.showCupertinoDialogSimple(
            ctx,
            'Informasi!',
            'Terjadi kesalahan add mangkir',
            [
              ElevatedButton(
                onPressed: () async {
                  AllNavigation.popNav(ctx, false, null);
                },
                child: const Text('OK'),
              ),
            ],
            hp);
      });
    }
  }
}
