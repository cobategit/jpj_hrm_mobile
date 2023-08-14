import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/screens/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthController authController = Get.put(AuthController());
  await authController.handleCheckConnection();
  // await initialBackgroundService();
  setPathUrlStrategy();
  runApp(const MyApp());
}

Future<void> initialBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStartBackgroundService,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStartBackgroundService,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
  );
  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    print('FLUTTER BACKGROUND FETCH - IOS');
  }

  return true;
}

void onStartBackgroundService(ServiceInstance service) async {
  AuthController authController = Get.put(AuthController());

  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  if (service is AndroidServiceInstance) {
    service.on('setAsBackground').listen((event) async {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      await authController.handleCheckConnection();
    } else {
      await authController.handleCheckConnection();
    }

    if (authController.checkConnection!.value) {
      // TODO
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();

    // if (authController.checkConnection!.value) {
    //   FlutterBackgroundService().invoke("setAsBackground");
    // }
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JPJ HRM',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? _visible;

  @override
  void initState() {
    _visible = true;
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _visible = !_visible!;
      });
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {});
      AllNavigation.pushReplaceNav(context, const AuthScreen(), (val) => {});
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedOpacity(
              opacity: _visible! ? 0.0 : 1.0,
              duration: const Duration(microseconds: 900),
              child: Image.asset(
                'assets/img/logo.png',
                fit: BoxFit.cover,
                width: GlobalSize.blockSizeHorizontal! * 64.26,
                height: GlobalSize.blockSizeVertical! * 30.16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
