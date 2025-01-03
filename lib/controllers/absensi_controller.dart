import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/models/index.dart';
import 'package:jpj_hrm_mobile/services/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:safe_device/safe_device.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'dart:html' as html;

class AbsensiController extends GetxController {
  TextEditingController? filterTglLeave;
  Rx<String>? timerString;
  Rx<String>? dateString;
  Timer? timer;
  GpsController? gpsController;
  AuthController? authController;
  Rx<dynamic>? hasilBarcode;
  Rxn<XFile>? hasilCamera;
  Rx<bool>? isLoading;
  RxMap? dataProfile;
  RxMap? dataAbsen;
  Rx<String>? thisDay;
  Rx<String>? long;
  Rx<String>? lat;
  Rx<String>? location;
  Rx<bool>? isMocked;
  Rx<String>? workingHrs;
  Rx<double>? totalDistanceAbsen;
  StreamSubscription<Position>? positionStream;
  GlobalKey<RefreshIndicatorState>? refreshKey;
  RxList<dynamic>? listLogAtt;
  Rx<bool>? checkNetwork;
  Rx<double>? maxDistance;
  Rx<double>? locationWorkLong;
  Rx<double>? locationWorkLat;
  Rx<dynamic>? hostnameWeb;
  Rx<bool>? safeDeviceMocLoc;
  Rx<bool>? safeDeviceDevMod;
  final Connectivity networkConnectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> networkConnectivitySubscription;
  TextEditingController? dariTglTxt;
  TextEditingController? sampaiTglTxt;
  RxMap<String, dynamic>? checkPresentBefore;
  RxList<dynamic>? holidayDisable;
  AuthController? _authController;

  @override
  void onInit() async {
    isLoading = Rx<bool>(true);
    dataProfile = {}.obs;
    dataAbsen = {}.obs;
    timerString = Rx<String>('');
    dateString = Rx<String>('');
    hasilBarcode = Rx<dynamic>(null);
    thisDay = Rx<String>('');
    long = Rx<String>('');
    lat = Rx<String>('');
    workingHrs = Rx<String>('');
    location = Rx<String>('');
    isMocked = Rx<bool>(false);
    maxDistance = Rx<double>(0);
    totalDistanceAbsen = Rx<double>(0);
    locationWorkLong = Rx<double>(0);
    locationWorkLat = Rx<double>(0);
    filterTglLeave = TextEditingController();
    timerString!(handleFormatTime(DateTime.now()));
    dateString!(DateFormat.yMMMEd().format(DateTime.now()));
    thisDay!(DateFormat('EEEE').format(DateTime.now()).toLowerCase());
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      handleGetTimer();
    });
    hasilCamera = Rxn<XFile>();
    gpsController = Get.find<GpsController>();
    authController = Get.find<AuthController>();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    listLogAtt = <dynamic>[].obs;
    checkNetwork = Rx<bool>(false);
    safeDeviceMocLoc = Rx<bool>(false);
    safeDeviceDevMod = Rx<bool>(false);
    hostnameWeb = Rx<dynamic>('');
    dariTglTxt = TextEditingController();
    sampaiTglTxt = TextEditingController();
    checkPresentBefore = RxMap<String, dynamic>({});
    holidayDisable = RxList([{}]);
    _authController = Get.find<AuthController>();
    await getDataProfile();
    await handleGetLogAttandance();
    await getCheckPresentBefore();
    await gpsController?.handleLocationPermission();
    super.onInit();
  }

  @override
  void onReady() async {
    if (!kIsWeb) {
      isLoading!(true);
      await handleGetCurrentLocation();
      await handleCheckConnection();
      safeDeviceMocLoc!(await SafeDevice.canMockLocation);
      safeDeviceDevMod!(await SafeDevice.isDevelopmentModeEnable);
      isLoading!(false);
    }
    super.onReady();
  }

  @override
  void onClose() {
    timer?.cancel();
    if (positionStream != null) {
      positionStream?.cancel();
      positionStream = null;
    }
    networkConnectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> handleRefresh() async {
    refreshKey?.currentState?.show(atTop: false);
    if (dataProfile!['department'] == 'SP Operational') {
      getDataScheduleStockfile();
    } else {
      getDataScheduleEmpPerDay();
    }
    if (!kIsWeb) {
      await gpsController?.handleLocationPermission();
      isLoading!(true);
      await handleGetCurrentLocation();
      await handleCheckConnection();
      safeDeviceMocLoc!(await SafeDevice.canMockLocation);
      safeDeviceDevMod!(await SafeDevice.isDevelopmentModeEnable);
      isLoading!(false);
    }
    getDataProfile();
    handleGetLogAttandance();
    getCheckPresentBefore();
  }

  handleCheckConnection() async {
    try {
      // final rs = await InternetAddress.lookup('www.google.com');
      // if (rs.isNotEmpty && rs[0].rawAddress.isNotEmpty) {
      //   checkNetwork!(true);
      // }

      networkConnectivitySubscription =
          networkConnectivity.onConnectivityChanged.listen((event) {
        if (event == ConnectivityResult.mobile ||
            event == ConnectivityResult.wifi) {
          checkNetwork!(true);
        } else {
          checkNetwork!(false);
        }
      });
    } on SocketException catch (_) {
      checkNetwork!(false);
    }
  }

  handleGetCurrentLocation() async {
    isLoading!(true);
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((position) async {
      long!(position.longitude.toString());
      lat!(position.latitude.toString());
      isMocked!(position.isMocked);
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      location!(placemarks[0].locality);
    });

    positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    )).listen((Position position) async {
      long!(position.longitude.toString());
      lat!(position.latitude.toString());
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      location!(placemarks[0].locality);
    });
    isLoading!(false);
  }

  handleSelectDateFilter(BuildContext context) async {
    DateTime selectDate = DateTime.now();

    final picked = await showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: selectDate,
      locale: const Locale("id"),
    );

    if (picked != null && picked != selectDate) {
      if (picked.month < 10) {
        filterTglLeave?.text = '${picked.year}-0${picked.month}';
      } else {
        filterTglLeave?.text = '${picked.year}-${picked.month}';
      }
    }
  }

  String handleFormatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  handleGetTimer() {
    final DateTime now = DateTime.now();
    timerString!(handleFormatTime(now));
    dateString!(DateFormat.yMMMEd().format(now));
  }

  Future<dynamic> handleScanBarcode() async {
    dynamic barcode = await FlutterBarcodeScanner.scanBarcode(
        "#004297", "Cancel", true, ScanMode.DEFAULT);
    if (barcode != '-1') {
      Map<String, dynamic> convertBarcode = jsonDecode(barcode);
      maxDistance!(double.parse(convertBarcode['max_distance'].toString()));
      locationWorkLong!(double.parse(convertBarcode['longitude'].toString()));
      locationWorkLat!(double.parse(convertBarcode['latitude'].toString()));
      totalDistanceAbsen!(Geolocator.distanceBetween(
          double.parse(lat!.value),
          double.parse(long!.value),
          double.parse(convertBarcode['latitude'].toString()),
          double.parse(convertBarcode['longitude'].toString())));
      return convertBarcode;
    }
    return null;
  }

  Future<double?> handleCheckDistance() async {
    double hasil = 0.0;
    positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    )).listen((Position position) {
      hasil = Geolocator.distanceBetween(
          position.latitude, position.longitude, -6.224571, 106.825503);
      // if (kDebugMode) {
      //   print('hasil check distance $hasil');
      // }
    });
    return hasil;
  }

  Future<bool> handleBeforeCheckout() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('HH:mm:ss').format(now);
    final format = DateFormat("HH:mm:ss");
    final one = format.parse("${dataAbsen!['check_in']}");
    final two = format.parse(formattedDate);
    final hours = two.difference(one).toString().split(':')[0];

    if (int.parse(hours) < 9) {
      return false;
    }

    return true;
  }

  Future<XFile?> handleCamera() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 1920.0,
        maxWidth: 1080.0,
        preferredCameraDevice: CameraDevice.front);

    if (pickedFile != null) {
      return XFile(pickedFile.path);
    }
    return null;
  }

  handleFakeGps() async {
    positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    )).listen((Position position) async {
      isMocked!(position.isMocked);
      long!(position.longitude.toString());
      lat!(position.latitude.toString());
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      location!(placemarks[0].locality);
    });
  }

  handleClearHistoryPresent() async {
    dariTglTxt?.clear();
    sampaiTglTxt?.clear();
    handleGetLogAttandance();
  }

  handleSelectDateForm(BuildContext ctx, type, wp, hp) async {
    DateTime selectDate = DateTime.now();
    late final DateTime firstDate;
    late final DateTime lastDate;

    if (type == 'sampai') {
      if (dariTglTxt!.text.isEmpty) {
        firstDate = DateTime(DateTime.now().year - 1, 5);
        lastDate = DateTime(5000);
      } else {
        firstDate = DateTime.parse(dariTglTxt!.text);
        lastDate = firstDate.add(const Duration(days: 30));
      }
    } else {
      firstDate = DateTime(DateTime.now().year - 1, 5);
      lastDate = selectDate.add(const Duration(days: 30));
    }

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
                  } else {
                    sampaiTglTxt?.text =
                        DateFormat('yyyy-MM-dd').format(val.date!);
                  }
                },
                minDate: firstDate,
                maxDate: lastDate,
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
                  if (sampaiTglTxt!.text.isNotEmpty) {
                    handleGetLogAttandance(
                        start: dariTglTxt!.text, end: sampaiTglTxt!.text);
                  }
                  AllNavigation.popNav(context, false, null);
                },
                child: const Text('OK'),
              ),
            ]),
      );
    });
  }

  getDataProfile() async {
    SharedPreferences session = await SharedPreferences.getInstance();

    isLoading!(true);
    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: Path.profile,
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);

    // final Profile creataSqlite = Profile(
    //     name: res['data']['name'],
    //     department: res['data']['department'],
    //     token: '${session.getString('token')}');
    // await DbController?.createData('tb_profile', creataSqlite.toMap());

    isLoading!(false);
    dataProfile!(res['data']);
    if (res['data']['department'] == 'SP Operational') {
      getDataScheduleStockfile();
    } else {
      getDataScheduleEmpPerDay();
    }
  }

  getDataProfileSqflite() async {
    SharedPreferences session = await SharedPreferences.getInstance();

    isLoading!(true);

    final data = await DbController.rawQuery(
        "SELECT * FROM tb_profile WHERE token = '${session.getString('token')}'");

    isLoading!(false);
    dataProfile!(data[0]);
    if (data[0]['department'] == 'SP Operational') {
      getDataScheduleStockfileSqlflite();
    } else {
      getDataScheduleEmpPerDaySqflite();
    }
  }

  getDataScheduleEmpPerDay() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    final day = DateFormat('yyyy-MM-dd').format(DateTime.now());
    workingHrs!('');
    dataAbsen!({});

    isLoading!(true);
    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: '${Path.schedulePerDay}/$day',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    if (res['data'] is Map) {
      dataAbsen!(res['data']);
      if (res['data']['check_in'] != false &&
          (res['data']['check_out'] != false &&
              res['data']['check_out'] != null)) {
        final format = DateFormat("HH:mm:ss");
        final one = format.parse("${res['data']['check_in']}");
        final two = format.parse("${res['data']['check_out']}");
        final hours = two.difference(one).toString().split(':')[0];
        final minute = two.difference(one).toString().split(':')[1];
        workingHrs!('$hours hrs $minute min');
      }
    }
  }

  Future<void> getHolidayDisable() async {
    final String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String startDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().add(const Duration(days: -30)));

    final ApiModel apiModel = ApiModel(
      url: Api.apiUrl,
      path: '${Path.holidayDisable}?start_date=$startDate&end_date=$endDate',
      isToken: false,
    );

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    holidayDisable!(res['data']);
  }

  Future<void> getCheckPresentBefore() async {
    await getHolidayDisable();
    SharedPreferences session = await SharedPreferences.getInstance();
    int durationDays = -1;
    bool checkAcitvity = false;
    DateTime date = DateTime.now();
    final dateSet = holidayDisable
        ?.map((element) =>
            DateFormat('yyyy-MM-dd').format(DateTime.parse(element['dates'])))
        .toSet();

    for (int i = durationDays; i >= -holidayDisable!.length; i--) {
      final dateBefore =
          DateFormat('yyyy-MM-dd').format(date.add(Duration(days: i)));
      if (!dateSet!.contains(dateBefore)) {
        durationDays = i;
        break;
      }
    }

    final DateTime lastDateBefore = date.add(Duration(days: durationDays));
    isLoading!(true);
    final ApiModel apiModelNodeJs = ApiModel(
        url: Api.apiUrl,
        path:
            '${Path.checkActivityPresent}?date=${DateFormat('yyyy-MM-dd').format(lastDateBefore)}&nik=${dataProfile?['nik']}',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> resCheckActivity =
        await GetData().getData(apiModelNodeJs);

    if (resCheckActivity['data']['mangkir'].length > 0 ||
        resCheckActivity['data']['cuti'].length > 0 ||
        resCheckActivity['data']['dinas'].length > 0) {
      checkAcitvity = true;
    }

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path:
            '${Path.schedulePerDay}/${DateFormat('yyyy-MM-dd').format(lastDateBefore)}',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    checkPresentBefore!({
      "check_in": res['data']['check_in'],
      "check_out": res['data']['check_out'],
      "schedule": res['data']['schedule'],
      "check_activity": checkAcitvity
    });
  }

  getDataScheduleEmpPerDaySqflite() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    final day = DateFormat('yyyy-MM-dd').format(DateTime.now());
    workingHrs!('');
    dataAbsen!({});

    isLoading!(true);
    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: '${Path.schedulePerDay}/$day',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    if (res['data'] is Map) {
      SchedulePerday schedulePerday = SchedulePerday(
          iduser: res['data']?['id_user'],
          checkin: res['data']?['checkin'],
          checkout: res['data']?['checkout'],
          tgl: res['data']?['date'],
          token: '${session.getString('token')}');
      await DbController.createData(
          'tb_schedulePerDay', schedulePerday.toMap());
      dataAbsen!(res['data']);
      if (res['data']['check_in'] != false &&
          (res['data']['check_out'] != false &&
              res['data']['check_out'] != null)) {
        final format = DateFormat("HH:mm:ss");
        final one = format.parse("${res['data']['check_in']}");
        final two = format.parse("${res['data']['check_out']}");
        final hours = two.difference(one).toString().split(':')[0];
        final minute = two.difference(one).toString().split(':')[1];
        workingHrs!('$hours hrs $minute min');
      }
    }
  }

  getDataScheduleStockfile() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    final day = DateFormat('yyyy-MM-dd').format(DateTime.now());
    workingHrs!('');
    dataAbsen!({});

    isLoading!(true);
    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: Path.schedulestockfile,
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    if (res['data'].length > 0) {
      res['data'].forEach((elem) {
        if (day == elem['stock_file_date']) {
          dataAbsen!(elem);
        }
      });
    }

    if (dataAbsen!.isNotEmpty &&
        dataAbsen!['check_in'] != 'Not Yet' &&
        dataAbsen!['check_out'] != 'Not Yet') {
      final format = DateFormat("HH:mm:ss");
      final one = format.parse("${dataAbsen!['check_in']}");
      final two = format.parse("${dataAbsen!['check_out']}");
      final hours = two.difference(one).toString().split(':')[0];
      final minute = two.difference(one).toString().split(':')[1];
      workingHrs!('$hours hrs $minute min');
    }
  }

  getDataScheduleStockfileSqlflite() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    final day = DateFormat('yyyy-MM-dd').format(DateTime.now());
    workingHrs!('');
    dataAbsen!({});

    isLoading!(true);
    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: Path.schedulestockfile,
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    if (res['data'].length > 0) {
      res['data'].forEach((elem) async {
        if (day == elem['stock_file_date']) {
          SchedulePerday schedulePerday = SchedulePerday(
              iduser: res['data']['id_user'],
              checkin: res['data']['checkin'],
              checkout: res['data']['checkout'],
              tgl: res['data']['stock_file_date'],
              token: '${session.getString('token')}');
          await DbController.createData('tb_schedulePerDay', schedulePerday);
          dataAbsen!(elem);
        }
      });
    }

    if (dataAbsen!.isNotEmpty &&
        dataAbsen!['check_in'] != 'Not Yet' &&
        dataAbsen!['check_out'] != 'Not Yet') {
      final format = DateFormat("HH:mm:ss");
      final one = format.parse("${dataAbsen!['check_in']}");
      final two = format.parse("${dataAbsen!['check_out']}");
      final hours = two.difference(one).toString().split(':')[0];
      final minute = two.difference(one).toString().split(':')[1];
      workingHrs!('$hours hrs $minute min');
    }
  }

  handleCheckInStockfile(ctx, wp, hp) async {
    hasilBarcode!(await handleScanBarcode());
    if (hasilBarcode?.value != null) {
      if (!((totalDistanceAbsen!.value - maxDistance!.value) <= 0)) {
        return WidgetsBinding.instance.addPostFrameCallback((_) async {
          await AlertDialogMsg.showCupertinoDialogSimple(
              ctx,
              'Peringatan!',
              'Maximal Jarak Absensi ${maxDistance!.value.toStringAsFixed(0)} meter dari Lokasi absen...',
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
      isLoading!(true);
      hasilCamera!(await handleCamera());
      if (hasilCamera?.value != null) {
        // if (kDebugMode) {
        //   print('hasil barcode: ${hasilBarcode?.value}');
        //   print('hasil camera: ${hasilCamera?.value?.path}');
        // }
        if (isMocked!.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await AlertDialogMsg.showCupertinoDialogSimple(
                ctx,
                'Peringatan!',
                'Matikan Fake GPS...',
                [
                  ElevatedButton(
                    onPressed: () async {
                      Platform.isAndroid ? SystemNavigator.pop() : exit(0);
                    },
                    child: const Text('OK'),
                  ),
                ],
                hp);
          });
        } else {
          SharedPreferences session = await SharedPreferences.getInstance();
          final Map<String, dynamic> bodyData = {
            'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
            'id_stock_file': hasilBarcode?.value,
            'check_in': DateFormat('HH:mm:ss').format(DateTime.now()),
            'longitude': long?.value,
            'latitude': lat?.value,
            'device': authController?.deviceData?.value,
            'picture': hasilCamera?.value?.path,
          };
          final ApiModel apiModel = ApiModel(
              url: Api.apiUrl,
              path: Path.checkinstokfile,
              body: bodyData,
              token: session.getString('token'),
              isToken: true);

          final Map<String, dynamic> res =
              await PostData().postFormData(apiModel, 'POST');

          if (res['success']) {
            getDataScheduleStockfile();
            handleGetLogAttandance();
          } else if (res['data']['status'] == 'Not Scheduled') {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await AlertDialogMsg.showCupertinoDialogSimple(
                  ctx,
                  'Informasi!',
                  'Kamu tidak terjadwal,\nApa ingin Check-In manual ?.',
                  [
                    ElevatedButton(
                      onPressed: () async {
                        handleCheckInNotScheduleStockfile(ctx, wp, hp);
                        AllNavigation.popNav(ctx, false, null);
                      },
                      child: const Text('OK'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        AllNavigation.popNav(ctx, false, null);
                      },
                      child: const Text('Tidak'),
                    ),
                  ],
                  hp);
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await AlertDialogMsg.showCupertinoDialogSimple(
                  ctx,
                  'Informasi!',
                  '${res['message']}',
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
    }
    isLoading!(false);
  }

  handleCheckInNotScheduleStockfile(ctx, wp, hp) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    final Map<String, dynamic> bodyData = {
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'id_stock_file': hasilBarcode?.value,
      'check_in': DateFormat('HH:mm:ss').format(DateTime.now()),
      'longitude': long?.value,
      'latitude': lat?.value,
      'device': authController?.deviceData?.value,
      'picture': hasilCamera?.value?.path
    };
    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path: Path.checkinnotschedulestokfile,
        body: bodyData,
        token: session.getString('token'),
        isToken: true);

    final Map<String, dynamic> res =
        await PostData().postFormData(apiModel, 'POST');

    if (res['success']) {
      getDataScheduleStockfile();
      handleGetLogAttandance();
    } else if (res['data']['status'] == 'Not Scheduled') {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AlertDialogMsg.showCupertinoDialogSimple(
            ctx,
            'Informasi!',
            'Kamu tidak terjadwal,\nApa ingin Check-In manual ?.',
            [
              ElevatedButton(
                onPressed: () async {
                  handleCheckInNotScheduleStockfile(ctx, wp, hp);
                  AllNavigation.popNav(ctx, false, null);
                },
                child: const Text('OK'),
              ),
              ElevatedButton(
                onPressed: () async {
                  AllNavigation.popNav(ctx, false, null);
                },
                child: const Text('TIDAK'),
              ),
            ],
            hp);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AlertDialogMsg.showCupertinoDialogSimple(
            ctx,
            'Informasi!',
            '${res['message']}',
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

  handleCheckoutStockfile(ctx, wp, hp) async {
    SharedPreferences session = await SharedPreferences.getInstance();

    final Map<String, dynamic> bodyData = {
      'id_stock_file': hasilBarcode?.value,
      'check_out': DateFormat('HH:mm:ss').format(DateTime.now()),
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'longitude_out': long?.value,
      'latitude_out': lat?.value,
    };

    final ApiModel apiModel = ApiModel(
      url: Api.apiUrl,
      path: Path.checkoutstokfile,
      body: bodyData,
      token: session.getString('token'),
      isToken: true,
    );

    final Map<String, dynamic> res = await PostData().putData(apiModel);

    if (res['success']) {
      getDataScheduleStockfile();
      handleGetLogAttandance();
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
  }

  handleCheckInOffice(ctx, wp, hp) async {
    if (checkPresentBefore!['schedule'] == true &&
        checkPresentBefore!['check_activity'] == false &&
        (checkPresentBefore!['check_in'] == false ||
            checkPresentBefore!['check_out'] == null)) {
      return WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AlertDialogMsg.showCupertinoDialogSimple(
            ctx,
            'Peringatan!',
            'Harap Isi Form Mangkir (Tidak In/Out)',
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
      await showDialog<String>(
        context: ctx,
        builder: (BuildContext context) => Center(
          child: Container(
            padding: EdgeInsets.only(top: hp * 2),
            width: wp * 80,
            height: hp * 26,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(hp * 2),
            ),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Choose Work',
                    style: TextStyle(
                      fontSize: hp * 1.8,
                      color: GlobalColor.blue,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IconGlobal',
                    ),
                  ),
                ),
                SizedBox(
                  height: hp * 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // WFH
                    GestureDetector(
                      onTap: () async {
                        null;
                        // AllNavigation.popNav(ctx, false, null);
                        // if (location!.value == '' && !kIsWeb) {
                        //   return WidgetsBinding.instance
                        //       .addPostFrameCallback((_) async {
                        //     await AlertDialogMsg.showCupertinoDialogSimple(
                        //         ctx,
                        //         'Peringatan!',
                        //         'Clear Cache Apps',
                        //         [
                        //           ElevatedButton(
                        //             onPressed: () async {
                        //               SystemNavigator.pop();
                        //             },
                        //             child: const Text('OK'),
                        //           ),
                        //         ],
                        //         hp);
                        //   });
                        // }
                        // final serviceGps = await gpsController!
                        //     .handleCheckServiceGps(context, hp);
                        // if (!serviceGps) {
                        //   gpsController!.handleCheckGps(context, hp);
                        // } else {
                        //   hasilCamera!(await handleCamera());
                        //   if (hasilCamera?.value != null) {
                        //     if (isMocked!.value) {
                        //       WidgetsBinding.instance
                        //           .addPostFrameCallback((_) async {
                        //         await AlertDialogMsg.showCupertinoDialogSimple(
                        //             ctx,
                        //             'Peringatan!',
                        //             'Matikan Fake GPS...',
                        //             [
                        //               ElevatedButton(
                        //                 onPressed: () async {
                        //                   Platform.isAndroid
                        //                       ? SystemNavigator.pop()
                        //                       : exit(0);
                        //                 },
                        //                 child: const Text('OK'),
                        //               ),
                        //             ],
                        //             hp);
                        //       });
                        //       isLoading!(false);
                        //     } else {
                        //       SharedPreferences session =
                        //           await SharedPreferences.getInstance();
                        //       final Map<String, dynamic> bodyData = {
                        //         'date': DateFormat('yyyy-MM-dd')
                        //             .format(DateTime.now()),
                        //         'id_dept':
                        //             dataProfile!['id_department'].toString(),
                        //         'check_in': DateFormat('HH:mm:ss')
                        //             .format(DateTime.now()),
                        //         'longitude': long?.value,
                        //         'latitude': lat?.value,
                        //         'type': 'true',
                        //         'device': authController?.deviceData?.value,
                        //         'picture': hasilCamera?.value?.path,
                        //         'is_wfh': 'true'
                        //       };
                        //       final ApiModel apiModel = ApiModel(
                        //           url: Api.apiUrl,
                        //           path: Path.checkinoffice,
                        //           body: bodyData,
                        //           token: session.getString('token'),
                        //           isToken: true);

                        //       isLoading!(true);
                        //       final Map<String, dynamic> res = await PostData()
                        //           .postFormData(apiModel, 'POST');
                        //       isLoading!(false);

                        //       if (res['success']) {
                        //         getDataScheduleEmpPerDay();
                        //       } else {
                        //         WidgetsBinding.instance
                        //             .addPostFrameCallback((_) async {
                        //           await AlertDialogMsg
                        //               .showCupertinoDialogSimple(
                        //                   ctx,
                        //                   'Informasi!',
                        //                   '${res['message']}',
                        //                   [
                        //                     ElevatedButton(
                        //                       onPressed: () async {
                        //                         AllNavigation.popNav(
                        //                             ctx, false, null);
                        //                       },
                        //                       child: const Text('OK'),
                        //                     ),
                        //                   ],
                        //                   hp);
                        //         });
                        //       }
                        //     }
                        //   }
                        //   // if (kDebugMode) {
                        //   //   print('choose WFH');
                        //   //   print('hasil camera: ${hasilCamera?.value?.path}');
                        //   // }
                        // }
                      },
                      child: Container(
                        width: wp * 30,
                        height: hp * 15,
                        decoration: BoxDecoration(
                          color: GlobalColor.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesome5.home,
                              size: hp * 7,
                              color: GlobalColor.light,
                            ),
                            SizedBox(
                              height: hp * 1,
                            ),
                            Text(
                              'WFH',
                              style: TextStyle(
                                fontSize: hp * 1.6,
                                color: GlobalColor.light,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // WFO
                    GestureDetector(
                      onTap: () async {
                        await handleGetCurrentLocation();
                        safeDeviceMocLoc!(await SafeDevice.canMockLocation);
                        safeDeviceDevMod!(
                            await SafeDevice.isDevelopmentModeEnable);
                        AllNavigation.popNav(ctx, false, null);

                        if (location!.value == '' && !kIsWeb) {
                          return WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            await AlertDialogMsg.showCupertinoDialogSimple(
                                ctx,
                                'Peringatan!',
                                'Location Cant Detect, Please Clear Cache Apps',
                                [
                                  ElevatedButton(
                                    onPressed: () async {
                                      SystemNavigator.pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                                hp);
                          });
                        }

                        if (gpsController!.isMockLoc!.value ||
                            isMocked!.value ||
                            safeDeviceMocLoc!.value ||
                            safeDeviceDevMod!.value) {
                          return WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            await AlertDialogMsg.showCupertinoDialogSimple(
                                ctx,
                                'Peringatan!',
                                'Matikan Fake GPS...',
                                [
                                  ElevatedButton(
                                    onPressed: () async {
                                      isLoading!(false);
                                      Get.delete<GpsController>(force: true);
                                      Get.delete<AbsensiController>(
                                          force: true);
                                      Platform.isAndroid
                                          ? SystemNavigator.pop()
                                          : exit(0);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                                hp);
                          });
                        }

                        final serviceGps = await gpsController!
                            .handleCheckServiceGps(context, hp);
                        if (!serviceGps) {
                          gpsController!.handleCheckGps(context, hp);
                        } else {
                          hasilBarcode!(await handleScanBarcode());
                          // if (kDebugMode) {
                          //   print('choose WFO');
                          //   print(
                          //       'hasil barcode: ${hasilBarcode!.value['id'].toString()}');
                          //   print('hasil distance max: ${maxDistance!.value}');
                          // }
                          if (hasilBarcode?.value != null) {
                            if (!((totalDistanceAbsen!.value -
                                    maxDistance!.value) <=
                                0)) {
                              return WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                await AlertDialogMsg.showCupertinoDialogSimple(
                                    ctx,
                                    'Peringatan!',
                                    'Maximal Jarak Absensi ${maxDistance!.value.toStringAsFixed(0)} meter dari Lokasi absen...',
                                    [
                                      ElevatedButton(
                                        onPressed: () async {
                                          AllNavigation.popNav(
                                              ctx, false, null);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                    hp);
                              });
                            }

                            hasilCamera!(await handleCamera());
                            if (hasilCamera?.value != null) {
                              SharedPreferences session =
                                  await SharedPreferences.getInstance();
                              final Map<String, dynamic> bodyData = {
                                'date': DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()),
                                'id_dept': dataProfile!['id_parent_department']
                                    .toString(),
                                'check_in': DateFormat('HH:mm:ss')
                                    .format(DateTime.now()),
                                'longitude': long?.value,
                                'latitude': lat?.value,
                                'type': 'true',
                                'device': authController?.deviceData?.value,
                                'picture': hasilCamera?.value?.path,
                                'is_wfh': 'false',
                                'id_barcode':
                                    hasilBarcode!.value['id'].toString()
                              };
                              final ApiModel apiModel = ApiModel(
                                  url: Api.apiUrl,
                                  path: Path.checkinoffice,
                                  body: bodyData,
                                  token: session.getString('token'),
                                  isToken: true);

                              isLoading!(true);
                              final Map<String, dynamic> res = await PostData()
                                  .postFormData(apiModel, 'POST');
                              isLoading!(false);

                              if (res['success']) {
                                getDataScheduleEmpPerDay();
                              } else {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  await AlertDialogMsg
                                      .showCupertinoDialogSimple(
                                          ctx,
                                          'Informasi!',
                                          '${res['message']}',
                                          [
                                            ElevatedButton(
                                              onPressed: () async {
                                                AllNavigation.popNav(
                                                    ctx, false, null);
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                          hp);
                                });
                              }
                            }
                          }
                          // if (kDebugMode) {
                          //   print('choose WFO');
                          //   print(
                          //       'hasil barcode: ${hasilBarcode!.value['id'].toString()}');
                          //   print('hasil camera: ${hasilCamera?.value?.path}');
                          //   print('hasil distance absen: $totalDistanceAbsen');
                          // }
                        }
                      },
                      child: Container(
                        width: wp * 30,
                        height: hp * 15,
                        decoration: BoxDecoration(
                          color: GlobalColor.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconGlobal.iconoffice,
                              size: hp * 7,
                              color: GlobalColor.light,
                            ),
                            SizedBox(
                              height: hp * 1,
                            ),
                            Text(
                              'WFO',
                              style: TextStyle(
                                fontSize: hp * 1.6,
                                color: GlobalColor.light,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  handleWebCheckinOffice(ctx, wp, hp) async {
    if (checkPresentBefore!['schedule'] == true &&
        checkPresentBefore!['check_activity'] == false &&
        (checkPresentBefore!['check_in'] == false ||
            checkPresentBefore!['check_out'] == null)) {
      return WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AlertDialogMsg.showCupertinoDialogSimple(
            ctx,
            'Peringatan!',
            'Harap Isi Form Mangkir (Tidak In/Out)',
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
      await showDialog<String>(
        context: ctx,
        builder: (BuildContext context) => Center(
          child: Container(
            padding: EdgeInsets.only(top: hp * 2),
            width: wp * 80,
            height: hp * 26,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(hp * 2),
            ),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Choose Work',
                    style: TextStyle(
                      fontSize: hp * 1.8,
                      color: GlobalColor.blue,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IconGlobal',
                    ),
                  ),
                ),
                SizedBox(
                  height: hp * 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // WFH
                    GestureDetector(
                      onTap: () async {
                        null;
                        // AllNavigation.popNav(ctx, false, null);
                        // SharedPreferences session =
                        //     await SharedPreferences.getInstance();
                        // final Map<String, dynamic> bodyData = {
                        //   'date':
                        //       DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        //   'id_dept': dataProfile!['id_department'].toString(),
                        //   'check_in':
                        //       DateFormat('HH:mm:ss').format(DateTime.now()),
                        //   'type': 'true',
                        //   'is_wfh': 'true'
                        // };
                        // final ApiModel apiModel = ApiModel(
                        //     url: Api.apiUrl,
                        //     path: Path.checkinoffice,
                        //     body: bodyData,
                        //     token: session.getString('token'),
                        //     isToken: true);

                        // final Map<String, dynamic> res =
                        //     await PostData().postFormData(apiModel, 'POST');
                        // isLoading!(false);

                        // if (res['success']) {
                        //   getDataScheduleEmpPerDay();
                        // } else {
                        //   WidgetsBinding.instance
                        //       .addPostFrameCallback((_) async {
                        //     await AlertDialogMsg.showCupertinoDialogSimple(
                        //         ctx,
                        //         'Informasi!',
                        //         '${res['message']}',
                        //         [
                        //           ElevatedButton(
                        //             onPressed: () async {
                        //               AllNavigation.popNav(ctx, false, null);
                        //             },
                        //             child: const Text('OK'),
                        //           ),
                        //         ],
                        //         hp);
                        //   });
                        // }
                      },
                      child: Container(
                        width: wp * 30,
                        height: hp * 15,
                        decoration: BoxDecoration(
                          color: GlobalColor.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesome5.home,
                              size: hp * 7,
                              color: GlobalColor.light,
                            ),
                            SizedBox(
                              height: hp * 1,
                            ),
                            Text(
                              'WFH',
                              style: TextStyle(
                                fontSize: hp * 1.6,
                                color: GlobalColor.light,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // WFO
                    GestureDetector(
                      onTap: () async {
                        AllNavigation.popNav(ctx, false, null);

                        if (kIsWeb && dataProfile!['flag_android']) {
                          return WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            await AlertDialogMsg.showCupertinoDialogSimple(
                                ctx,
                                'Peringatan!',
                                'Hanya untuk pengguna Apple!!!',
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

                        if (authController?.ipLocalClient?.value == null) {
                          return WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            await AlertDialogMsg.showCupertinoDialogSimple(
                                ctx,
                                'Informasi!',
                                'Ip anda tidak terdeteksi, silakan lakukan reload',
                                [
                                  ElevatedButton(
                                    onPressed: () async {
                                      authController!
                                          .handleRedirectGetIpLocal();
                                      AllNavigation.popNav(ctx, false, null);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                                hp);
                          });
                        }

                        SharedPreferences session =
                            await SharedPreferences.getInstance();
                        final Map<String, dynamic> bodyData = {
                          'date':
                              DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          'id_dept':
                              dataProfile!['id_parent_department'].toString(),
                          'check_in':
                              DateFormat('HH:mm:ss').format(DateTime.now()),
                          'type': false,
                          'is_wfh': false,
                          'ipabsenin': authController!.ipLocalClient!.value
                        };

                        final ApiModel apiModel = ApiModel(
                            url: Api.apiUrl,
                            path: Path.checkinoffice,
                            body: bodyData,
                            token: session.getString('token'),
                            isToken: true);

                        final Map<String, dynamic> res =
                            await PostData().postData(apiModel);
                        isLoading!(false);
                        if (kDebugMode) {
                          print('res $res');
                        }

                        if (res['success']) {
                          getDataScheduleEmpPerDay();
                        } else {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            await AlertDialogMsg.showCupertinoDialogSimple(
                                ctx,
                                'Informasi!',
                                '${res['message']}',
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
                      },
                      child: Container(
                        width: wp * 30,
                        height: hp * 15,
                        decoration: BoxDecoration(
                          color: GlobalColor.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconGlobal.iconoffice,
                              size: hp * 7,
                              color: GlobalColor.light,
                            ),
                            SizedBox(
                              height: hp * 1,
                            ),
                            Text(
                              'WFO',
                              style: TextStyle(
                                fontSize: hp * 1.6,
                                color: GlobalColor.light,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  handleCheckoutOffice(ctx, wp, hp) async {
    SharedPreferences session = await SharedPreferences.getInstance();

    final Map<String, dynamic> bodyData = {
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'check_out': DateFormat('HH:mm:ss').format(DateTime.now()),
      'longitude_out': long?.value,
      'latitude_out': lat?.value,
      'id_barcode': hasilBarcode!.value['id'].toString(),
    };

    final ApiModel apiModel = ApiModel(
      url: Api.apiUrl,
      path: Path.checkoutoffice,
      body: bodyData,
      token: session.getString('token'),
      isToken: true,
    );

    if (location!.value == '' && !kIsWeb) {
      return WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AlertDialogMsg.showCupertinoDialogSimple(
            ctx,
            'Peringatan!',
            'Location Cant Detect, Please Clear Cache Apps',
            [
              ElevatedButton(
                onPressed: () async {
                  SystemNavigator.pop();
                },
                child: const Text('OK'),
              ),
            ],
            hp);
      });
    }

    if (gpsController!.isMockLoc!.value ||
        isMocked!.value ||
        safeDeviceMocLoc!.value ||
        safeDeviceDevMod!.value) {
      return WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AlertDialogMsg.showCupertinoDialogSimple(
            ctx,
            'Peringatan!',
            'Matikan Fake GPS...',
            [
              ElevatedButton(
                onPressed: () async {
                  isLoading!(false);
                  Get.delete<GpsController>(force: true);
                  Get.delete<AbsensiController>(force: true);
                  Platform.isAndroid ? SystemNavigator.pop() : exit(0);
                },
                child: const Text('OK'),
              ),
            ],
            hp);
      });
    }

    final Map<String, dynamic> res = await PostData().putData(apiModel);

    if (res['success']) {
      getDataScheduleEmpPerDay();
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
  }

  handleCheckOut(ctx, hp, wp) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AlertDialogMsg.showCupertinoDialogSimple(
        ctx,
        'Peringatan!',
        'Anda Yakin Ingin Check Out ?.',
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
              // final checkHoursBeforeCheckOut = await handleBeforeCheckout();
              final serviceGps = await gpsController!
                  .handleCheckServiceGps(ctx, GlobalSize.blockSizeVertical);
              isLoading!(true);
              if (!serviceGps) {
                gpsController!
                    .handleCheckGps(ctx, GlobalSize.blockSizeVertical);
              } else {
                // if (!checkHoursBeforeCheckOut) {
                //   isLoading!(false);
                //   AllNavigation.popNav(ctx, false, null);
                //   return AlertDialogMsg.showCupertinoDialogSimple(
                //     ctx,
                //     'Infomasi!',
                //     'Maaf, anda tidak bisa checkout karena belum 9 jam kerja',
                //     [
                //       ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //           foregroundColor: GlobalColor.light,
                //           elevation: 2,
                //           backgroundColor: GlobalColor.grey,
                //           shadowColor: GlobalColor.light.withOpacity(0.8),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(
                //               hp! * 1,
                //             ),
                //           ),
                //           minimumSize: Size(
                //             wp! * 10,
                //             hp! * 4,
                //           ),
                //         ),
                //         onPressed: () {
                //           AllNavigation.popNav(ctx, false, null);
                //         },
                //         child: const Text('OK'),
                //       ),
                //     ],
                //     hp,
                //   );
                // }
                hasilBarcode!(await handleScanBarcode());
                if (hasilBarcode?.value != null) {
                  if (dataProfile!['department'] == 'SP Operational') {
                    handleCheckoutStockfile(ctx, wp, hp);
                  } else {
                    handleCheckoutOffice(ctx, wp, hp);
                  }
                }
              }

              isLoading!(false);
              AllNavigation.popNav(ctx, false, null);
            },
            child: const Text('OK'),
          ),
        ],
        hp,
      );
    });
  }

  handleWebCheckoutOffice(ctx, hp, wp) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AlertDialogMsg.showCupertinoDialogSimple(
        ctx,
        'Peringatan!',
        'Anda Yakin Ingin Check Out ?.',
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
              if (authController?.ipLocalClient?.value == null) {
                return WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await AlertDialogMsg.showCupertinoDialogSimple(
                      ctx,
                      'Peringatan!',
                      'Ip anda tidak terdeteksi, silakan lakukan reload',
                      [
                        ElevatedButton(
                          onPressed: () async {
                            // await authController!.handleRedirectGetIpLocal();
                            // if (html.window.location.href.split("=")[1] != '') {
                            //   _authController?.ipLocalClient = Rx<String>(
                            //       html.window.location.href.split("=")[1]);
                            // }
                            AllNavigation.popNav(ctx, false, null);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                      hp);
                });
              }

              // final checkHoursBeforeCheckOut = await handleBeforeCheckout();
              // if (!checkHoursBeforeCheckOut) {
              //   isLoading!(false);
              //   AllNavigation.popNav(ctx, false, null);
              //   return AlertDialogMsg.showCupertinoDialogSimple(
              //     ctx,
              //     'Infomasi!',
              //     'Maaf, anda tidak bisa checkout karena belum 9 jam kerja',
              //     [
              //       ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           foregroundColor: GlobalColor.light,
              //           elevation: 2,
              //           backgroundColor: GlobalColor.grey,
              //           shadowColor: GlobalColor.light.withOpacity(0.8),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(
              //               hp! * 1,
              //             ),
              //           ),
              //           minimumSize: Size(
              //             wp! * 10,
              //             hp! * 4,
              //           ),
              //         ),
              //         onPressed: () {
              //           AllNavigation.popNav(ctx, false, null);
              //         },
              //         child: const Text('OK'),
              //       ),
              //     ],
              //     hp,
              //   );
              // }

              isLoading!(true);
              SharedPreferences session = await SharedPreferences.getInstance();
              final Map<String, dynamic> bodyData = {
                'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
                'check_out': DateFormat('HH:mm:ss').format(DateTime.now()),
                'ipabsenout': authController!.ipLocalClient!.value
              };

              final ApiModel apiModel = ApiModel(
                url: Api.apiUrl,
                path: Path.checkoutoffice,
                body: bodyData,
                token: session.getString('token'),
                isToken: true,
              );

              final Map<String, dynamic> res =
                  await PostData().putData(apiModel);

              if (res['success']) {
                getDataScheduleEmpPerDay();
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

              isLoading!(false);
              AllNavigation.popNav(ctx, false, null);
            },
            child: const Text('OK'),
          ),
        ],
        hp,
      );
    });
  }

  handleGetLogAttandance({String? start = '', String? end = ''}) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    DateTime dateNow = DateTime.now();
    late String startDate;
    late String endDate;
    startDate = start == ''
        ? DateFormat('yyyy-MM-dd')
            .format(dateNow.add(const Duration(days: -30)))
        : start!;
    endDate = end == '' ? DateFormat('yyyy-MM-dd').format(dateNow) : end!;
    isLoading!(true);

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl,
        path:
            '${Path.logAttandance}?start=$startDate&end=$endDate&id_dept=${dataProfile!['id_parent_department']}',
        isToken: true,
        token: session.getString('token'));

    final Map<String, dynamic> res = await GetData().getData(apiModel);
    isLoading!(false);
    listLogAtt!(res['data']);
  }
}
