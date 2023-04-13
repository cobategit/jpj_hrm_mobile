import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:jpj_hrm_mobile/widgets/index.dart';

class FormChangePassword extends StatelessWidget {
  FormChangePassword({Key? key}) : super(key: key);

  final AuthController authController = Get.put(AuthController());
  final AbsensiController absensiController = Get.put(AbsensiController());

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return WillPopScope(
      onWillPop: () {
        AllNavigation.popNav(context, false, null);
        authController.oldPassTxt?.clear();
        authController.newPassTxt?.clear();
        authController.rePassTxt?.clear();
        throw true;
      },
      child: CloseKeyboardTapAnyWhr(
        child: Scaffold(
          backgroundColor: GlobalColor.light,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(GlobalSize.blockSizeVertical! * 5.5),
            child: CustomAppBar(
              automaticallyImplyLeading: false,
              textJudul: 'CHANGE PASSWORD',
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
                padding: EdgeInsets.only(
                  left: GlobalSize.blockSizeHorizontal! * 5,
                  right: GlobalSize.blockSizeHorizontal! * 5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                              bottom: GlobalSize.safeBlockVertical! * 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Obx(
                                () => CustomTextInput(
                                  margin: EdgeInsets.only(
                                    top: GlobalSize.blockSizeVertical! * 1,
                                  ),
                                  labelText: "Old Password",
                                  hp: GlobalSize.blockSizeVertical! * 5.5,
                                  textController: authController.oldPassTxt,
                                  obscureText:
                                      authController.hideOldPass?.value,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        GlobalSize.blockSizeHorizontal! * 2,
                                  ),
                                  maxLines: 1,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      authController.handleHideShowOldPass();
                                    },
                                    child: Icon(
                                      authController.hideOldPass!.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: GlobalSize.blockSizeVertical! * 2.5,
                                      color: GlobalColor.dark,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: GlobalSize.blockSizeVertical! * 2,
                              ),
                              Obx(
                                () => CustomTextInput(
                                  margin: EdgeInsets.only(
                                    top: GlobalSize.blockSizeVertical! * 1,
                                  ),
                                  labelText: "New Password",
                                  hp: GlobalSize.blockSizeVertical! * 5.5,
                                  textController: authController.newPassTxt,
                                  obscureText:
                                      authController.hideNewPass?.value,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        GlobalSize.blockSizeHorizontal! * 2,
                                  ),
                                  maxLines: 1,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      authController.handleHideShowNewPass();
                                    },
                                    child: Icon(
                                      authController.hideNewPass!.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: GlobalSize.blockSizeVertical! * 2.5,
                                      color: GlobalColor.dark,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: GlobalSize.blockSizeVertical! * 2,
                              ),
                              Obx(
                                () => CustomTextInput(
                                  margin: EdgeInsets.only(
                                    top: GlobalSize.blockSizeVertical! * 1,
                                  ),
                                  labelText: "Retype New Password",
                                  hp: GlobalSize.blockSizeVertical! * 5.5,
                                  textController: authController.rePassTxt,
                                  obscureText: authController.hideRePass?.value,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        GlobalSize.blockSizeHorizontal! * 2,
                                  ),
                                  maxLines: 1,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      authController.handleHideShowRePass();
                                    },
                                    child: Icon(
                                      authController.hideRePass!.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: GlobalSize.blockSizeVertical! * 2.5,
                                      color: GlobalColor.dark,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: GlobalSize.blockSizeVertical! * 2,
                              ),
                              GlobalButtonElevated(
                                onPressed: () {},
                                tittle: 'CHANGE',
                                fontSize: GlobalSize.blockSizeVertical! * 1.8,
                                color: GlobalColor.light,
                                colorPrim: GlobalColor.green,
                                colorOnPrim: Colors.white.withOpacity(0.9),
                                colorShadowPrim: Colors.white,
                                borderRadius: GlobalSize.blockSizeVertical! * 1,
                                sizeH: GlobalSize.safeBlockVertical! * 4.5,
                                sizeW: GlobalSize.safeBlockHorizontal! * 18,
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
