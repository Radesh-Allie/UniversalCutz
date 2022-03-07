import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';


import 'package:flutter_credit_card/flutter_credit_card.dart';



class AddCreditCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddCreditCardState();
  }
}

class AddCreditCardState extends State<AddCreditCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  OutlineInputBorder border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credit Card Number"),
      ),
      bottomNavigationBar: Container(
        height: 80.0,
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (formKey.currentState.validate()) {
              print('valid!');

              userCollection.collection("payment_account").add({
                "account_type": "credit_card",
                "account_title": "Credit Card",
                "account_number": cardNumber.replaceAll(" ", ""),
                "cvc": cvvCode,
                "expiration_month": int.parse(expiryDate.split("/")[0]),
                "expiration_year": int.parse(expiryDate.split("/")[1]),
                "memo": "-",
              });
              Get.back();
            } else {
              print('invalid!');
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("Add This Card")),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  cardNumber = "4242 4242 4242 4242";
                  expiryDate = "04/24";
                  cvvCode = "323";
                  formKey.currentState.setState(() {});
                  setState(() {});
                },
                child: Text(
                  "Use Stripe Demo Card",
                ),
              ),
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cvvCode: cvvCode,
                cardHolderName: "",
                showBackView: isCvvFocused,
                obscureCardNumber: false,
                obscureCardCvv: false,
                cardBgColor: Colors.blue,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                // customCardTypeIcons: <CustomCardTypeIcon>[
                //   CustomCardTypeIcon(
                //     cardType: CardType.mastercard,
                //     cardImage: Image.asset(
                //       'assets/mastercard.png',
                //       height: 48,
                //       width: 48,
                //     ),
                //   ),
                // ],
              ),
              CreditCardForm(
                formKey: formKey,
                obscureCvv: false,
                obscureNumber: false,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                cardHolderName: "",
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                isHolderNameVisible: false,
                expiryDate: expiryDate,
                themeColor: Colors.blue,
                textColor: Colors.white,
                cardNumberDecoration: InputDecoration(
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                expiryDateDecoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: border,
                  enabledBorder: border,
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: border,
                  enabledBorder: border,
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: border,
                  enabledBorder: border,
                  labelText: 'Card Holder',
                ),
                onCreditCardModelChange: onCreditCardModelChange,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
