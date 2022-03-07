import 'package:barber_app/core.dart';


class BookDetailController extends GetxController {
  BookDetailView view;
  Map selectedCreditCard;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setPaymentMethodTo(Map paymentCard) {
    selectedCreditCard = paymentCard;
    update();
  }
}
