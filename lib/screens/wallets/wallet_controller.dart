import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/home_controller.dart';
import 'package:new_friends_date_app/user/userData_model.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletController extends GetxController {
  @override
  void onInit() {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    fetchApi(
      url: 'get_profile/${userData!.id.toString()}',
      get: true,
      onSucess: (val) {
        userData = UserData.fromJson(val).data;
      },
    ).then((val) async {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userData!.phoneNumber)
          .update({
        'wallet': val['data']['wallet_credit_amount'].toString(),
        'earn_wallet': val['data']['earn_wallet_credit'].toString(),
        'on_call': false
      });
    });
    super.onInit();
  }

  onSuccess(PaymentSuccessResponse response) {
    log(response.toString());
    EasyLoading.showSuccess(
        'Payment Successful! Your coins will be credited as soon as the payment is verified.');
    fetchApi(url: 'walletRecharge', params: {
      'user_id': userData!.id.toString(),
      'wallet_credit': totalCoin ?? '',
      'amount': offerPrice.text,
      'payment_type': 'RazorPay',
      'transaction_id': response.paymentId,
    }).then((value) async {
      HomeController getC = Get.find();
      // getC.fbData.wallet =
      //     (int.parse(getC.fbData.wallet!) + int.parse(totalCoin!)).toString();

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userData!.phoneNumber)
          .update({
        'wallet':
            (int.parse(getC.fbData.wallet!) + int.parse(totalCoin!)).toString(),
      }).then((value) {
        getC.update();
        Get.back();
      });
    });
  }

  onError(PaymentFailureResponse response) {
    log(response.message.toString());
    EasyLoading.showError(
      dismissOnTap: true,
      'Payment Failed! We assured that any deducted amount will be promptly refunded.',
      duration: const Duration(seconds: 3),
    );
  }

  Razorpay razorpay = Razorpay();
  int? customCoin;
  TextEditingController offerPrice = TextEditingController(text: '0');
  TextEditingController redeemCoinController = TextEditingController();
  TextEditingController upiIDController = TextEditingController();
  int? selectedOffer;
  List banner = [];
  String? totalCoin;
  int redeemCoin = 0;
  String upiID = '';
  double? redeemRupees;
}
