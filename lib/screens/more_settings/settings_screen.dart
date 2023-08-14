import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/screens/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:jpj_hrm_mobile/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final AbsensiController absensiController = Get.find<AbsensiController>();

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    // check mode light or dark
    // var brightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      backgroundColor: GlobalColor.light,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(GlobalSize.blockSizeVertical! * 5.5),
        child: CustomAppBar(
          textJudul: 'SETTINGS',
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
          Container(
            color: GlobalColor.grey.withOpacity(0.02),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: GlobalSize.safeBlockHorizontal! * 2),
                        child: Text(
                          'App Settings',
                          style: TextStyle(
                            fontSize: GlobalSize.blockSizeVertical! * 1.8,
                            fontWeight: FontWeight.w600,
                            color: GlobalColor.blue,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: GlobalSize.blockSizeVertical! * 5,
                      ),
                      GestureDetector(
                        child: Container(
                          color: GlobalColor.light,
                          height: GlobalSize.blockSizeVertical! * 7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                  left: GlobalSize.blockSizeHorizontal! * 5,
                                ),
                                child: Center(
                                  child: Text(
                                    'Change Password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          GlobalSize.blockSizeVertical! * 2,
                                      color: GlobalColor.blue,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  right: GlobalSize.blockSizeHorizontal! * 5,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: GlobalColor.blue,
                                  size: GlobalSize.blockSizeVertical! * 2,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          AllNavigation.pushNav(
                              context, FormChangePassword(), (_) {});
                        },
                      ),
                      SizedBox(
                        height: GlobalSize.blockSizeVertical! * 2,
                      ),
                      GestureDetector(
                        child: Container(
                          color: GlobalColor.light,
                          height: GlobalSize.blockSizeVertical! * 7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                  left: GlobalSize.blockSizeHorizontal! * 5,
                                ),
                                child: Center(
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          GlobalSize.blockSizeVertical! * 2,
                                      color: GlobalColor.blue,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  right: GlobalSize.blockSizeHorizontal! * 5,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: GlobalColor.blue,
                                  size: GlobalSize.blockSizeVertical! * 2,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () async {
                          SharedPreferences session =
                              await SharedPreferences.getInstance();
                          await session.remove('token');
                          Get.delete<AbsensiController>(force: true);
                          Get.delete<GpsController>(force: true);
                          Get.delete<LeaveController>(force: true);
                          // await Get.deleteAll(force: true);
                          AllNavigation.pushRemoveUntilNav(
                              context, Login(), (_) => null);
                        },
                      ),
                      SizedBox(
                        height: GlobalSize.blockSizeVertical! * 2,
                      ),
                      Container(
                        color: GlobalColor.light,
                        height: GlobalSize.blockSizeVertical! * 7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                left: GlobalSize.blockSizeHorizontal! * 5,
                              ),
                              child: Center(
                                child: Text(
                                  'Version',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: GlobalSize.blockSizeVertical! * 2,
                                    color: GlobalColor.blue,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                right: GlobalSize.blockSizeHorizontal! * 5,
                              ),
                              child: Text(
                                '2.1.0',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: GlobalSize.blockSizeVertical! * 2,
                                  color: GlobalColor.blue,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
