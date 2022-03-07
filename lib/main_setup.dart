import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';



class MainSetup {
  static setup({
    @required DummyApi dummyApi,
  }) async {
    AppSession.dummyApi = dummyApi;

    print("Enter MainSetup");
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }
    if (!kIsWeb) await NotificationApi.initialize();

    if (!kIsWeb) {
      var appDocDir = await getApplicationDocumentsDirectory();
      localdb = await Hive.openBox("myBox", path: appDocDir.path);
    } else {
      localdb = await Hive.openBox("myBox");
    }

    localdb = await Hive.openBox("myBox");

    await Firebase.initializeApp();

    if (kIsWeb) {
      // FirebaseFirestore.instance.enablePersistence();
    } else {
      FirebaseFirestore.instance.settings = Settings(
        persistenceEnabled: true,
      );
    }

    Stripe.publishableKey =
        "pk_test_51It2LfEovG5yA4kNRshWoo2vENOoBpGK37WAynWwuxGeaMHQUIuTQ3eyT49SKkBHzB4yb6MqoQj7q60XVQByTC6Z00mVzNL3rp";
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    Stripe.urlScheme = 'flutterstripe';
    await Stripe.instance.applySettings();
    
    print("Exit MainSetup");
  }
}
