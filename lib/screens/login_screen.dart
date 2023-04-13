import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jpj_hrm_mobile/configs/colors.dart';
import 'package:jpj_hrm_mobile/controllers/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';
import 'package:jpj_hrm_mobile/widgets/index.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return Scaffold(
      backgroundColor: GlobalColor.light,
      body: CloseKeyboardTapAnyWhr(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: GlobalColor.grey,
                    width: GlobalSize.blockSizeHorizontal! * 100,
                    height: GlobalSize.blockSizeVertical! * 3.94,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: GlobalSize.blockSizeVertical! * 20,
                    ),
                    child: Image.asset(
                      'assets/img/logo.png',
                      fit: BoxFit.cover,
                      width: GlobalSize.blockSizeHorizontal! * 60.26,
                      height: GlobalSize.blockSizeVertical! * 26.16,
                    ),
                  ),
                  Container(
                      width: GlobalSize.blockSizeHorizontal! * 100,
                      padding: EdgeInsets.only(
                        left: GlobalSize.blockSizeHorizontal! * 16,
                        right: GlobalSize.blockSizeHorizontal! * 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              GlobalSize.blockSizeVertical! * 4.5),
                          topRight: Radius.circular(
                              GlobalSize.blockSizeVertical! * 4.5),
                        ),
                      ),
                      child: Obx(() {
                        return Form(
                          key: authController.formKey,
                          autovalidateMode: authController.autoValidate!.value
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          child: Column(
                            children: [
                              Container(
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Email',
                                        style: TextStyle(
                                            fontSize:
                                                GlobalSize.blockSizeVertical! *
                                                    1.8,
                                            color: GlobalColor.blue,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top:
                                            GlobalSize.blockSizeVertical! * 0.5,
                                      ),
                                      width: GlobalSize.blockSizeHorizontal! *
                                          68.2,
                                      height: GlobalSize.blockSizeVertical! * 5,
                                      child: TextFormField(
                                        controller: authController.emailText,
                                        style: TextStyle(
                                            fontSize:
                                                GlobalSize.blockSizeVertical! *
                                                    2,
                                            fontStyle: FontStyle.normal,
                                            color: GlobalColor.light),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: GlobalSize
                                                    .blockSizeHorizontal! *
                                                3.3,
                                          ),
                                          filled: true,
                                          fillColor: GlobalColor.blue
                                              .withOpacity(0.97),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.circular(
                                              GlobalSize.blockSizeVertical! *
                                                  1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  top: GlobalSize.blockSizeVertical! * 2.5,
                                ),
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Password',
                                        style: TextStyle(
                                            fontSize:
                                                GlobalSize.blockSizeVertical! *
                                                    1.8,
                                            color: GlobalColor.blue,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top:
                                            GlobalSize.blockSizeVertical! * 0.5,
                                      ),
                                      width: GlobalSize.blockSizeHorizontal! *
                                          68.2,
                                      height: GlobalSize.blockSizeVertical! * 5,
                                      child: TextFormField(
                                        controller: authController.passText,
                                        style: TextStyle(
                                            fontSize:
                                                GlobalSize.blockSizeVertical! *
                                                    2,
                                            fontStyle: FontStyle.normal,
                                            color: GlobalColor.light),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        obscureText:
                                            authController.hidePass!.value,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: GlobalSize
                                                    .blockSizeHorizontal! *
                                                3.3,
                                          ),
                                          filled: true,
                                          fillColor: GlobalColor.blue
                                              .withOpacity(0.97),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.circular(
                                              GlobalSize.blockSizeVertical! *
                                                  1.5,
                                            ),
                                          ),
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              authController
                                                  .handleHideShowPass();
                                            },
                                            child: Icon(
                                              authController.hidePass!.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              size: GlobalSize
                                                      .blockSizeVertical! *
                                                  2.5,
                                              color: GlobalColor.light,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: GlobalSize.blockSizeVertical! * 3,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GlobalButtonElevated(
                                  onPressed: () async {
                                    await authController
                                        .handleCheckConnection();
                                    if (authController
                                            .emailText!.text.isNotEmpty &&
                                        authController
                                            .passText!.text.isNotEmpty) {
                                      authController.isLoading!(true);
                                      if (authController
                                          .checkConnection!.value) {
                                        authController.handleLogin(
                                            context,
                                            GlobalSize.blockSizeVertical!,
                                            GlobalSize.safeBlockHorizontal!);
                                      }
                                      // else {
                                      //   authController.handleLoginSqflite(
                                      //       context,
                                      //       GlobalSize.blockSizeVertical!,
                                      //       GlobalSize.safeBlockHorizontal!);
                                      // }
                                    } else {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) async {
                                        await AlertDialogMsg
                                            .showCupertinoDialogSimple(
                                                context,
                                                'Informasi!',
                                                'Mohon Isi Field Yang Kosong',
                                                [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      AllNavigation.popNav(
                                                          context, false, null);
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                                GlobalSize.blockSizeVertical!);
                                      });
                                    }
                                  },
                                  tittle: 'SIGN IN',
                                  fontSize: GlobalSize.blockSizeVertical! * 2,
                                  color: GlobalColor.light,
                                  colorPrim: GlobalColor.blue,
                                  colorOnPrim: Colors.white.withOpacity(0.9),
                                  colorShadowPrim: Colors.white,
                                  borderRadius:
                                      GlobalSize.blockSizeVertical! * 1,
                                  sizeH: GlobalSize.safeBlockVertical! * 4.5,
                                  sizeW: GlobalSize.safeBlockHorizontal! * 22,
                                ),
                              ),
                            ],
                          ),
                        );
                      }))
                ],
              ),
            ),
            Obx(() {
              if (authController.isLoading!.value) {
                return const ProgressBar();
              } else {
                return Container();
              }
            })
          ],
        ),
      ),
    );
  }
}
