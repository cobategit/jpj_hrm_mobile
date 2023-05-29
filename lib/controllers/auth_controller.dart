import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/models/index.dart';
import 'package:jpj_hrm_mobile/screens/index.dart';
import 'package:jpj_hrm_mobile/services/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:html' as html;

class AuthController extends GetxController {
  TextEditingController? emailText;
  TextEditingController? passText;
  GlobalKey<FormState>? formKey;
  TextEditingController? oldPassTxt;
  TextEditingController? newPassTxt;
  TextEditingController? rePassTxt;
  RxBool? isLoading;
  RxBool? hidePass;
  RxBool? hideOldPass;
  RxBool? hideNewPass;
  RxBool? hideRePass;
  RxBool? autoValidate;
  RxString? deviceData;
  RxBool? checkConnection;
  RxMap? readDataDeviceAndro;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  late StreamSubscription<ConnectivityResult> networkConnectivitySubscription;
  final Connectivity networkConnectivity = Connectivity();
  // DbController? dbController;

  @override
  void onInit() {
    emailText = TextEditingController();
    passText = TextEditingController();
    oldPassTxt = TextEditingController();
    newPassTxt = TextEditingController();
    rePassTxt = TextEditingController();
    formKey = GlobalKey<FormState>();
    deviceData = "".obs;
    isLoading = false.obs;
    hidePass = true.obs;
    hideOldPass = true.obs;
    hideRePass = true.obs;
    hideNewPass = true.obs;
    autoValidate = false.obs;
    checkConnection = false.obs;
    final hostname = html.window.location.hostname;
    if (kDebugMode) {
      print('hostname web $hostname');
    }
    // dbController = Get.put(DbController());
    super.onInit();
  }

  @override
  void onReady() async {
    if (!kIsWeb) {
      await handleGetDevice();
    }
    if (!kIsWeb) {
      await handleCheckConnection();
    } else {
      checkConnection!(true);
    }
    super.onReady();
  }

  @override
  void onClose() {
    autoValidate = false.obs;
    isLoading = false.obs;
    hidePass = true.obs;
    hideOldPass = true.obs;
    hideRePass = true.obs;
    hideNewPass = true.obs;
    emailText?.clear();
    passText?.clear();
    networkConnectivitySubscription.cancel();
    super.onClose();
  }

  handleHideShowPass() {
    hidePass!.value = !hidePass!.value;
  }

  handleHideShowOldPass() {
    hideOldPass!.value = !hideOldPass!.value;
  }

  handleHideShowNewPass() {
    hideNewPass!.value = !hideNewPass!.value;
  }

  handleHideShowRePass() {
    hideRePass!.value = !hideRePass!.value;
  }

  handleGetDevice() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        deviceData!(androidInfo.model);
      }
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceData!(iosInfo.model);
      }
    } on PlatformException {
      const error = "Error Failed to get platform version";
      deviceData!(error);
    }
  }

  handleCheckConnection() async {
    try {
      // final rs = await InternetAddress.lookup('www.google.com');
      // if (rs.isNotEmpty && rs[0].rawAddress.isNotEmpty) {
      //   checkConnection!(true);
      // }
      networkConnectivitySubscription =
          networkConnectivity.onConnectivityChanged.listen((event) {
        if (event == ConnectivityResult.mobile ||
            event == ConnectivityResult.wifi) {
          checkConnection!(true);
        } else {
          checkConnection!(false);
        }
      });
    } on SocketException catch (_) {
      checkConnection!(false);
    }
  }

  handleLogin(context, hp, wp) async {
    SharedPreferences session = await SharedPreferences.getInstance();
    final Map<String, dynamic> bodyData = {
      'email': emailText!.text,
      'password': passText!.text
    };

    final ApiModel apiModel = ApiModel(
        url: Api.apiUrl, path: Path.login, body: bodyData, isToken: false);

    final Map<String, dynamic> res = await PostData().postData(apiModel);
    isLoading!(false);

    if (res['success']) {
      await session.setString('token', res['data']['token']);
      // final Users dataMap = Users(
      //   email: emailText!.text,
      //   password: passText!.text,
      //   token: res['data']['token'],
      // );
      // await DbController?.createData('tb_users', dataMap.toMap());
      AllNavigation.pushReplaceNav(
          context,
          const BottomNavScreen(
            selectedIdx: 0,
            selectedIdxAbsen: 0,
          ),
          (_) => null);
    } else {
      AlertDialogMsg.showCupertinoDialogSimple(
        context,
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
              AllNavigation.popNav(context, false, null);
            },
            child: const Text('OK'),
          ),
        ],
        hp,
      );
    }
    emailText?.clear();
    passText?.clear();
  }

  handleLoginSqflite(context, hp, wp) async {
    SharedPreferences session = await SharedPreferences.getInstance();

    final data = await DbController.rawQuery(
        "SELECT * FROM tb_users WHERE email = 'JPJ-19011@gmail.com' AND password = '12345678'");

    final dataAll = await DbController.rawQuery("SELECT * FROM tb_users ");

    if (kDebugMode) {
      print('data sqflite login: $data dan $dataAll');
    }

    isLoading!(false);

    if (data.isNotEmpty) {
      await session.setString('token', data[0]['token']);
      final Map<String, dynamic> dataMap = {
        'email': emailText!.text,
        'password': passText!.text,
        'token': data[0]['token'],
      };
      await DbController.createData('tb_users', dataMap);
      AllNavigation.pushReplaceNav(
          context,
          const BottomNavScreen(
            selectedIdx: 0,
            selectedIdxAbsen: 0,
          ),
          (_) => null);
    } else {
      AlertDialogMsg.showCupertinoDialogSimple(
        context,
        'Infomasi!',
        'Gagal Login Sqflite',
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
              AllNavigation.popNav(context, false, null);
            },
            child: const Text('OK'),
          ),
        ],
        hp,
      );
    }
    emailText?.clear();
    passText?.clear();
  }
}
