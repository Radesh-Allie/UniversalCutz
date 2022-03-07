import 'package:barber_app/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



void main() async {
  var dummyApi = MainDummyApi();
  await MainSetup.setup(
    dummyApi: dummyApi,
  );

  // await FirebaseAuth.instance.signOut();
  await FirebaseAuth.instance.wait();

  int appThemeIndex = dummyApi.appConfig.defaultThemeIndex;
  // if (FirebaseAuth.instance.currentUser != null) {
  //   appThemeIndex = await AdminSettingApi.getAppThemeIndex(
  //     defaultThemeIndex: 1,
  //   );
  // }
  await AdminSettingApi?.loadAppSetting();

  Widget mainView = await LoginSessionHandler.getMainView();
  // mainView = AdmThemeView();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    // theme: theme.appThemeData,
    theme: ThemeData().getCustomTheme(
      customColorSet: colorPalettes[appThemeIndex],
    ),
    defaultTransition: Transition.fade,
    home: mainView,
  ));
}
