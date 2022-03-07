import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSettingApi {
  static Map appSetting = {};
  static List availableConfigs = [
    {
      "label": "Vendor Approval",
      "field_name": "vendor_approval",
      "readonly": true,
    },
    {
      "label": "Enable Payment Gateway",
      "field_name": "payment_gateway",
      "readonly": true,
    },
    {
      "label": "Enable Multivendor",
      "field_name": "multi_vendor",
    },
    {
      "label": "Enable Credit Card Dummy",
      "field_name": "credit_card_dummy",
    },
  ];

  static initialize() async {
    await FirebaseFirestore.instance
        .collection(collection.adminSettingCollection)
        .doc("app_setting")
        .set({});

    await availableConfigs.forEach((config) async {
      await FirebaseFirestore.instance
          .collection(collection.adminSettingCollection)
          .doc("app_setting")
          .update({
        config["field_name"]: true,
      });
    });
  }

  static loadAppSetting() async {
    var appSettingSnapshot = await FirebaseFirestore.instance
        .collection(collection.adminSettingCollection)
        .doc("app_setting")
        .get();

    var d = appSettingSnapshot.data();
    AdminSettingApi?.appSetting = d ?? {};
    print(">>> ${AdminSettingApi?.appSetting}");
  }

  static getAppThemeIndex({
    defaultThemeIndex,
  }) async {
    var themeSettingSnapshot = await FirebaseFirestore.instance
        .collection(collection.adminSettingCollection)
        .doc("theme_setting")
        .get();

    if (themeSettingSnapshot.exists) {
      var d = themeSettingSnapshot.data();
      return d["theme_index"] ?? 0;
    } else {
      return defaultThemeIndex ?? 0;
    }
  }

  static setAppThemeIndex(int index) async {
    //Only Admin can set it permanently
    if (!AppSession.isAdmin) return;
    await FirebaseFirestore.instance
        .collection(collection.adminSettingCollection)
        .doc("theme_setting")
        .set({
      "theme_index": index,
    });
  }
}
