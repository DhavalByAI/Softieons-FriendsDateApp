import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/screens/wallets/wallet_controller.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctextfield_common.dart';

class OfferPage extends StatelessWidget {
  const OfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Offers> offers = [
      Offers(
          coinCount: 165000,
          price: 49999,
          freeCoins: 7000,
          offerPercentage: 60),
      Offers(
          coinCount: 33000, price: 9999, freeCoins: 1200, offerPercentage: 60),
      Offers(
          coinCount: 15000, price: 4999, freeCoins: 400, offerPercentage: 40),
      Offers(coinCount: 5500, price: 1999, offerPercentage: 33),
      Offers(coinCount: 2500, price: 999, offerPercentage: 30),
      Offers(coinCount: 1200, price: 499, offerPercentage: 25),
      Offers(coinCount: 440, price: 199, offerPercentage: 20),
      Offers(coinCount: 200, price: 99, offerPercentage: 10),
      Offers(coinCount: 90, price: 49),
      Offers(coinCount: 40, price: 25),
    ];

    return Scaffold(
        backgroundColor: AppColors.scafflodBackground,
        body: SingleChildScrollView(
          child: GetBuilder<WalletController>(
            initState: (_) {},
            builder: (_) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12 + 24, left: 24, right: 24),
                    child: Row(
                      children: [
                        cBounce(
                          onPressed: () {
                            Get.back();
                          },
                          child: CircleAvatar(
                            radius: 20,
                            // backgroundColor: AppColors.mainColor,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.scafflodBackground,
                              child: Image.asset(
                                'assets/icons/back.png',
                                width: 18,
                                color: AppColors.mainColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Spacer(),
                        ctext(
                          'Offers',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: AppColors.mainColor,
                        ),
                        const SizedBox(
                          width: 36,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: List.generate(
                          offers.length,
                          // _.seeAll ? offers.length : 4,
                          (index) => cBounce(
                                onPressed: () {
                                  _.selectedOffer == index
                                      ? _.selectedOffer = null
                                      : _.selectedOffer = index;

                                  _.selectedOffer != null
                                      ? _.offerPrice.text =
                                          offers[_.selectedOffer!]
                                              .price
                                              .toString()
                                      : _.offerPrice.text = 0.toString();

                                  _.update();
                                },
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: cCard(
                                          width: double.maxFinite,
                                          shadow: false,
                                          border: true,
                                          color: AppColors.subBoxColor,
                                          borderColor: _.selectedOffer == index
                                              ? AppColors.mainColor
                                              : Colors.grey.withOpacity(0.5),
                                          borderWidth:
                                              _.selectedOffer == index ? 3 : 2,
                                          child: Column(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Image.asset(
                                                'assets/icons/coins.png',
                                                height: 45,
                                                width: 45,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              ctext(
                                                  '${offers[index].coinCount}',
                                                  fontSize: 16,
                                                  textAlign: TextAlign.center,
                                                  fontWeight: FontWeight.w700),
                                              offers[index].freeCoins != null
                                                  ? ctext(
                                                      '+ ${offers[index].freeCoins.toString()} Free',
                                                      fontSize: 12,
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontWeight:
                                                          FontWeight.w400)
                                                  : const SizedBox(),
                                              // ctext('+',
                                              //     fontSize: 16,
                                              //     fontWeight: FontWeight.w700),
                                              // ctext('${offers[index].freeCoins}',
                                              //     fontSize: 16,
                                              //     fontWeight: FontWeight.w700),
                                              ctext('Coins',
                                                  color: Colors.black54,
                                                  fontSize: 14)
                                            ],
                                          )),
                                    ),
                                    offers[index].offerPercentage != null
                                        ? cCard(
                                            shadow: false,
                                            color: Colors.transparent,
                                            height: 55,
                                            width: 60,
                                            image: const DecorationImage(
                                                image: AssetImage(
                                              'assets/icons/offer.png',
                                            )),
                                            child: Center(
                                              child: ctext(
                                                  '${offers[index].offerPercentage} %',
                                                  color: AppColors.subBoxColor),
                                            ))
                                        : const SizedBox(),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: cCard(
                                            color: AppColors.mainColor,
                                            radius: 36,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 4),
                                              child: ctext(
                                                  '$kRupee ${offers[index].price}',
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 12,
                  // ),
                  // Row(
                  //   children: [
                  //     const Spacer(),
                  //     cBounce(
                  //       onPressed: () {
                  //         _.seeAll = !_.seeAll;
                  //         _.update();
                  //       },
                  //       child: ctext(_.seeAll ? 'See Less' : 'See All Offers',
                  //           color: AppColors.mainColor),
                  //     ),
                  //     const SizedBox(
                  //       width: 24,
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, bottom: 12),
                    child: ctext('Note',
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.start,
                        fontSize: 16,
                        color: AppColors.mainColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.mainColor,
                              radius: 4,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: ctext(
                                  'Non-Refundable Coins: Coins purchased are non-refundable.',
                                  color: Colors.grey,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.mainColor,
                              radius: 4,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: ctext(
                                  'Coin Expiry Date: Coins have an expiry date; expired coins are void.',
                                  color: Colors.grey,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.mainColor,
                              radius: 4,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: ctext(
                                  'Coin Use: Coins can only be used within the app.',
                                  color: Colors.grey,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        cButton(
                          ' + ',
                          fontSize: 20,
                          onTap: () {
                            _.offerPrice.text =
                                (int.parse(_.offerPrice.text) + 1).toString();
                            int tmpindex = offers.indexWhere((element) =>
                                element.price == int.parse(_.offerPrice.text));
                            _.selectedOffer = tmpindex != -1 ? tmpindex : null;
                            _.update();
                          },
                        ),
                        const SizedBox(width: 24),
                        SizedBox(
                            height: 100,
                            width: 200,
                            child: cTextFieldCommon(
                              textInputFormatter: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textInputType: TextInputType.phone,
                              onChanged: (val) {
                                _.offerPrice.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: _.offerPrice.text.length),
                                );
                                if (val.contains('-')) {
                                  _.offerPrice.text = val.replaceAll('-', '');
                                  val = val.replaceAll('-', '');
                                } else if (val.isEmpty) {
                                  _.offerPrice.text = '0';
                                  val = '0';
                                }
                                int tmpindex = offers.indexWhere((element) =>
                                    element.price == int.parse(val));
                                _.selectedOffer =
                                    tmpindex != -1 ? tmpindex : null;
                                _.update();
                              },
                              controller: _.offerPrice,
                              textAlign: TextAlign.center,
                              textStyle: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.mainColor),
                            )),
                        const SizedBox(width: 24),
                        cButton(
                          ' - ',
                          fontSize: 20,
                          onTap: () {
                            int.parse(_.offerPrice.text) - 1 >= 0
                                ? _.offerPrice.text =
                                    (int.parse(_.offerPrice.text) - 1)
                                        .toString()
                                : _.offerPrice.text = 0.toString();

                            int tmpindex = offers.indexWhere((element) =>
                                element.price == int.parse(_.offerPrice.text));
                            _.selectedOffer = tmpindex != -1 ? tmpindex : null;
                            _.update();
                          },
                        ),
                      ],
                    ),
                  ),
                  Center(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ctext('You Will Recieve '),
                      Image.asset(
                        'assets/icons/coin.png',
                        height: 16,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      ctext(
                          offers.firstWhereOrNull((element) =>
                                      element.price ==
                                      int.parse(_.offerPrice.text)) !=
                                  null
                              ? (offers[_.selectedOffer!].coinCount +
                                      (offers[_.selectedOffer!].freeCoins ?? 0))
                                  .toString()
                              : (int.parse(_.offerPrice.text) *
                                      int.parse(userData!.rechargeCoin!))
                                  .toString(),
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainColor),
                      ctext(' Coins '),
                    ],
                  )),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: cButton(
                      'Pay',
                      onTap: () {
                        _.totalCoin = offers.firstWhereOrNull((element) =>
                                    element.price ==
                                    int.parse(_.offerPrice.text)) !=
                                null
                            ? (offers[_.selectedOffer!].coinCount +
                                    (offers[_.selectedOffer!].freeCoins ?? 0))
                                .toString()
                            : (int.parse(_.offerPrice.text) *
                                    int.parse(userData!.rechargeCoin!))
                                .toString();
                        String payCoin = _.offerPrice.text;
                        if (payCoin == '0' || payCoin.isEmpty) {
                          EasyLoading.showError('Please Enter Valid Amount');
                        } else {
                          var options = {
                            // 'key': 'rzp_test_r8DXVjp5iJHLkM',
                            'key': 'rzp_live_U8qPfSkECpc1q2',
                            'amount': int.parse(payCoin) * 100,
                            'name': 'Coin Buy - Soft Love',
                            'description': 'Coin Payments',
                            'retry': {'enabled': true, 'max_count': 1},
                            'send_sms_hash': true,
                            'prefill': {
                              'contact': userData!.phoneNumber.toString(),
                              'email': userData!.email.toString(),
                            }
                          };
                          _.razorpay.open(options);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  )
                ],
              );
            },
          ),
        ));
  }
}

class Offers {
  int coinCount;
  int? offerPercentage;
  int? freeCoins;
  int price;
  Offers(
      {required this.coinCount,
      this.offerPercentage,
      required this.price,
      this.freeCoins});
}
