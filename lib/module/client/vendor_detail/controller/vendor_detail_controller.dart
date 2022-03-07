import 'package:barber_app/core.dart';


class VendorDetailController extends GetxController {
  VendorDetailView view;
  bool loading = true;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    print("#############");
    print(view.item["id"]);
    print("#############");
    loadData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  loadData() async {
    loading = false;
    update();
  }
}
