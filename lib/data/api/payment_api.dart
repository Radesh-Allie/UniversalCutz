import 'dart:convert';
import 'dart:developer';

import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentApi {
  /*
  ? This Stripe backend is just a sample. 
  ! You have to host your own backend to handle stripe to make it more secure.
  */
  static String kApiUrl =
      'https://us-central1-codekaze-stripe.cloudfunctions.net/api';
  // static String kApiUrl = "http://192.168.1.6:4242";

  static Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
    @required List<Map<String, dynamic>> items,
    @required String accountNumber,
    @required String cvc,
    @required int expirationMonth,
    @required int expirationYear,
  }) async {
    var card = CardDetails(
      number: accountNumber,
      cvc: cvc,
      expirationMonth: expirationMonth,
      expirationYear: expirationYear,
    );
    await Stripe.instance.dangerouslyUpdateCardDetails(card);

    // 1. Gather customer billing information (ex. email)
    final billingDetails = BillingDetails(
      email: AppSession.currentUser.email,
      phone: AppSession.currentUser.phoneNumber ?? "+6282146787099",
      address: Address(
        city: 'Houston',
        country: 'US',
        line1: '1459  Circle Drive',
        line2: '',
        state: 'Texas',
        postalCode: '77063',
        // city: '-',
        // country: '-',
        // line1: '-',
        // line2: '-',
        // state: '-',
        // postalCode: '-',
      ),
    ); // mocked data for tests

    // 2. Create payment method
    final paymentMethod =
        await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(
      billingDetails: billingDetails,
    ));

    String url = '$kApiUrl/pay-without-webhooks';

    final response = await GetConnect().post(
      url,
      jsonEncode({
        'useStripeSdk': true,
        'paymentMethodId': paymentMethod.id,
        'currency': 'usd',
        'items': items
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print("===========================");
    print("Stripe Payment Response:");
    print("Status: ${response.status.code}");
    print("Response Body: ${response.bodyString}");
    print("===========================");

    return response.body;
  }

  static refund(String chargeId) async {
    String url = '$kApiUrl/refund/$chargeId';
    final response = await GetConnect().get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    log("Refund Response: $response");
  }
}
