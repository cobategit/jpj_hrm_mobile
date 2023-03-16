import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
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

  @override
  void onInit() {
    isMockLoc = Rx<bool>(false);
    isMocked = Rx<bool>(false);
    latitude = Rx<String>('');
    longitude = Rx<String>('');
    location = Rx<String>('');
    servGpsEnable = false.obs;
    handleGetLoc();
    super.onInit();
  }

  @override
  void onClose() {
    servGpsEnable = false.obs;
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
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) async {
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      location!(placemarks[0].locality);
      latitude!(position.latitude.toString());
      longitude!(position.longitude.toString());
      isMocked!(position.isMocked);
    }).catchError((e) {
      if (kDebugMode) {
        print('error catch getlonglat $e');
      }
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

  handleTrustLocation(ctx, hp) async {
    try {
      TrustLocation.onChange.listen((values) {
        isMockLoc!(values.isMockLocation);
        if (kDebugMode) {
          print('is moclocation $isMockLoc');
        }
        if (isMockLoc!.value) {
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
        }
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error Trust Location $e');
      }
    }
  }
}
