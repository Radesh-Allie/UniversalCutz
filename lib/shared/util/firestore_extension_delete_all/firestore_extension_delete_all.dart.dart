import 'package:cloud_firestore/cloud_firestore.dart';


extension FirestoreExtenxionDeleteAllExtension on CollectionReference {
  deleteAll() async {
    var snapshot = await this.get();
    await snapshot.docs.forEach((doc) async {
      await this.doc(doc.id).delete();
    });
  }

  Future addAll(
    List items, {
    bool deleteAllExistingData = true,
  }) async {
    if (deleteAllExistingData) await this.deleteAll();

    await items.forEach((item) async {
      await this.add(item);
    });
  }
}
