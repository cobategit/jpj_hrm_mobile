import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:trust_location/trust_location.dart';

class GpsController extends GetxController {
  RxBool? servGpsEnable;
  LocationPermission? permission;
  Rx<bool>? isMockLoc;
  Rx<bool>? isMocked;
  Rx<String>? latitude;
  Rx<String>? longitude;
  Rx<String>? location;
  StreamSubscription<Position>? positionStream;

  @override
  void onInit() {
    isMockLoc = Rx<bool>(false);
    isMocked = Rx<bool>(false);
    latitude = Rx<String>('');
    longitude = Rx<String>('');
    location = Rx<String>('');
    servGpsEnable = false.obs;
    if (!kIsWeb) {
      TrustLocation.start(3);
      // handleGetLoc();
    }
    super.onInit();
  }

  @override
  void onClose() {
    servGpsEnable = false.obs;
    if (positionStream != null) {
      positionStream?.cancel();
      positionStream = null;
    }
    super.onClose();
  }

  handleLocationPermission() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  handleGetLoc() async {
    await handleLocationPermission();
    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    )).listen((Position position) async {
      longitude!(position.longitude.toString());
      latitude!(position.latitude.toString());
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      location!(placemarks[0].locality);
    }).onError((e) {
      return Future.error('Get Location Stream Error $e.');
    });
  }

  handleCheckGps(ctx, hp) async {
    if (!servGpsEnable!.isTrue) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AlertDialogMsg.showCupertinoDialogSimple(
            ctx,
            'Informasi',
            'Aktifkan GPS...',
            [
              ElevatedButton(
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                  Platform.isAndroid ? SystemNavigator.pop() : exit(0);
                },
                child: const Text('OK'),
              ),
            ],
            hp);
      });
    }
    await handleLocationPermission();
  }

  Future<bool> handleCheckServiceGps(ctx, hp) async {
    servGpsEnable!(await Geolocator.isLocationServiceEnabled());
    await handleLocationPermission();

    if (!servGpsEnable!.isTrue) {
      handleCheckGps(ctx, hp);
      return false;
    } else {
      handleGetLoc();
      return true;
    }
  }

  handleTrustLocation() async {
    try {
      TrustLocation.onChange.listen((values) {
        isMockLoc!(values.isMockLocation);
        // if (kDebugMode) {
        //   print('is moclocation $isMockLoc');
        // }
        // if (isMockLoc!.value) {
        //   return WidgetsBinding.instance.addPostFrameCallback((_) async {
        //     await AlertDialogMsg.showCupertinoDialogSimple(
        //         ctx,
        //         'Peringatan!',
        //         'Matikan Fake GPS...',
        //         [
        //           ElevatedButton(
        //             onPressed: () async {
        //               Get.delete<GpsController>(force: true);
        //               Platform.isAndroid ? SystemNavigator.pop() : exit(0);
        //             },
        //             child: const Text('OK'),
        //           ),
        //         ],
        //         hp);
        //   });
        // }
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error Trust Location $e');
      }
    }
  }
}
