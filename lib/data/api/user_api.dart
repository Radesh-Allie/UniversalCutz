import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserApi {
  static initialize() async {
    await FirebaseFirestore.instance
        .collection(collection.userDataCollection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(
      {
        "profile": {
          "uid": AppSession.currentUser.uid,
          "email": AppSession.currentUser.email,
          "email_verified": AppSession.currentUser.emailVerified,
          "photo_url": AppSession.currentUser.photoURL,
          "display_name": AppSession.currentUser.displayName,
        },
      },
      SetOptions(
        merge: true,
      ),
    );

    if (AdminSettingApi?.appSetting["credit_card_dummy"] == true) {
      var paymentAccountSnapshot =
          await userCollection.collection("payment_account").limit(1).get();

      if (paymentAccountSnapshot.docs.isEmpty) {
        await userCollection.collection("payment_account").add({
          "account_type": "credit_card",
          "account_title": "Credit Card",
          "account_number": "4242424242424242",
          "cvc": "323",
          "expiration_month": 12,
          "expiration_year": 30,
          "memo": "Dummy Credit Card (for Testing)",
        });
      }
    }
  }
}
