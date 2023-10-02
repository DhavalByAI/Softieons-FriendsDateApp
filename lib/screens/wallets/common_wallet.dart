import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/home_controller.dart';
import 'package:new_friends_date_app/screens/wallets/wallet_controller.dart';
import 'package:new_friends_date_app/user/userData_model.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:new_friends_date_app/widget/cachedImageNetwork.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctextfield_common.dart';

import 'offer_page.dart';

class CommonWallet extends StatelessWidget {
  const CommonWallet({super.key});

  @override
  Widget build(BuildContext context) {
    WalletController _ = Get.put(WalletController());
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12 + 24, left: 24, right: 24),
            child: Row(
              children: [
                cBounce(
                  onPressed: () {
                    Get.back();
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.subColor,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.mainColor,
                      child: Image.asset(
                        'assets/icons/back.png',
                        width: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                const Spacer(),
                ctext('Wallet',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white),
                const SizedBox(
                  width: 36,
                ),
                const Spacer(),
              ],
            ),
          ),
          GetBuilder<HomeController>(
            initState: (_) {},
            builder: (_) {
              return CarouselSlider(
                  items: List.generate(
                      _.banner.length, (index) => cImage(_.banner[index])),
                  options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                  ));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: cCard(
                shadow: false,
                color: Colors.white10,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    ctext(
                      'coins',
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/coin.png',
                                      height: 30,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    GetBuilder<HomeController>(
                                      initState: (_) {},
                                      builder: (_) {
                                        return ctext(_.fbData.wallet!,
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700);
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                ctext('Added Coins', color: Colors.white),
                                const SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: cButton(
                                    onTap: () {
                                      Get.to(() => const OfferPage());
                                    },
                                    'Add Coins',
                                    btnColor: AppColors.subColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          width: 0.5,
                          height: 120,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/coin.png',
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  GetBuilder<HomeController>(
                                    initState: (_) {},
                                    builder: (_) {
                                      return ctext(_.fbData.earnWallet!,
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700);
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              ctext('Earned Coins', color: Colors.white),
                              const SizedBox(
                                height: 12,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: cButton('Redeem', onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: GetBuilder<HomeController>(
                                          initState: (_) {},
                                          builder: (_) {
                                            return GetBuilder<WalletController>(
                                              initState: (c) {},
                                              builder: (c) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(24),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Image.asset(
                                                        'assets/icons/coins.png',
                                                        height: 40,
                                                      ),
                                                      ctext('Redeem Coins',
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          ctext(
                                                              userData!
                                                                  .redeemedCoin
                                                                  .toString(),
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Image.asset(
                                                            'assets/icons/coin.png',
                                                            height: 30,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          ctext('=',
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          ctext('   1 $kRupee',
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Center(
                                                          child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          ctext('You Have '),
                                                          Image.asset(
                                                            'assets/icons/coin.png',
                                                            height: 16,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          ctext(
                                                              _.fbData
                                                                  .earnWallet!,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: AppColors
                                                                  .mainColor),
                                                          ctext(
                                                              ' Earned Coins'),
                                                        ],
                                                      )),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      cCard(
                                                        border: true,
                                                        borderColor:
                                                            AppColors.mainColor,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              cTextFieldCommon(
                                                            onChanged: (val) {
                                                              c.redeemRupees = val
                                                                      .isNotEmpty
                                                                  ? int.parse(
                                                                          val) /
                                                                      int.parse(
                                                                          userData!
                                                                              .redeemedCoin!)
                                                                  : 0;
                                                              c.update();
                                                            },
                                                            controller: c
                                                                .redeemCoinController,
                                                            textInputFormatter: [
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            textInputType:
                                                                TextInputType
                                                                    .number,
                                                            hint:
                                                                'Enter No. of Coins',
                                                          ),
                                                        ),
                                                      ),
                                                      c.redeemRupees != null
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8),
                                                              child: ctext(
                                                                  'You Will Recieved $kRupee${c.redeemRupees!.toStringAsFixed(2)}',
                                                                  color: AppColors
                                                                      .mainColor),
                                                            )
                                                          : const SizedBox(),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      cCard(
                                                        border: true,
                                                        borderColor:
                                                            AppColors.mainColor,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              cTextFieldCommon(
                                                            controller: c
                                                                .upiIDController,
                                                            hint:
                                                                'Enter UPI ID',
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 24,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          cButton(
                                                            'Cancel',
                                                            txtColor:
                                                                Colors.black,
                                                            btnColor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.5),
                                                            onTap: () {
                                                              Get.back();
                                                            },
                                                          ),
                                                          cButton(
                                                            'Redeem Coins',
                                                            onTap: () {
                                                              if (c
                                                                      .redeemCoinController
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  int.parse(c
                                                                          .redeemCoinController
                                                                          .text) <=
                                                                      int.parse(_
                                                                          .fbData
                                                                          .earnWallet!)) {
                                                                if (c
                                                                    .upiIDController
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  fetchApi(
                                                                      url:
                                                                          'user_payout',
                                                                      params: {
                                                                        'user_id':
                                                                            userData!.id,
                                                                        'amount':
                                                                            c.redeemRupees,
                                                                        'upi_id': c
                                                                            .upiIDController
                                                                            .text
                                                                            .toString(),
                                                                        'email': userData!
                                                                            .email
                                                                            .toString(),
                                                                        'user_name': userData!
                                                                            .fullName
                                                                            .toString(),
                                                                        'total_credit': c
                                                                            .redeemCoinController
                                                                            .text
                                                                            .toString(),
                                                                      }).then(
                                                                      (value) {
                                                                    fetchApi(
                                                                      url:
                                                                          'get_profile/${userData!.id.toString()}',
                                                                      isloaderShow:
                                                                          false,
                                                                      get: true,
                                                                      onSucess:
                                                                          (val) {
                                                                        userData =
                                                                            UserData.fromJson(val).data;
                                                                      },
                                                                    ).then(
                                                                        (val) async {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'user')
                                                                          .doc(userData!
                                                                              .phoneNumber)
                                                                          .update({
                                                                        'wallet':
                                                                            val['data']['wallet_credit_amount'].toString(),
                                                                        'earn_wallet':
                                                                            val['data']['earn_wallet_credit'].toString(),
                                                                        'on_call':
                                                                            false
                                                                      });
                                                                      EasyLoading.showSuccess(
                                                                          duration: const Duration(
                                                                              seconds:
                                                                                  3),
                                                                          dismissOnTap:
                                                                              true,
                                                                          'Payout Request Sended Successfully, Money Will Be Credited Within 3-4 Working Days');
                                                                    });
                                                                    Get.back();
                                                                  });
                                                                } else {
                                                                  EasyLoading
                                                                      .showError(
                                                                          'Please Enter Valid UPI ID');
                                                                }
                                                              } else {
                                                                EasyLoading
                                                                    .showError(
                                                                        'Please Enter Valid Value');
                                                              }
                                                              // fetchApi(
                                                              //     url: 'report_user',
                                                              //     params: {
                                                              //       'user_id':
                                                              //           userData!.id,
                                                              //       'report_user_id': _
                                                              //           .otherUserData!
                                                              //           .id
                                                              //           .toString(),
                                                              //       'text':
                                                              //           reportText.text
                                                              //     }).then((value) {
                                                              //   Get.back();
                                                              //   Get.offAll(
                                                              //       () => Home());
                                                              // });
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                    btnColor: Colors.white,
                                    txtColor: AppColors.mainColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
