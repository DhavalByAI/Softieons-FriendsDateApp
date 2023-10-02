import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/home_controller.dart';
import 'package:new_friends_date_app/screens/dashboard/all_users.dart';
import 'package:new_friends_date_app/screens/dashboard/move_to_listener.dart';
import 'package:new_friends_date_app/screens/profile_screen/other_profile.dart';
import 'package:new_friends_date_app/screens/wallets/common_wallet.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/widget/cachedImageNetwork.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:new_friends_date_app/widget/sub_widgets/interest.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'selectInterest.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final HomeController _ = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.scafflodBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            bottomOpacity: 0,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  cBounce(
                    onPressed: () {
                      _.drawerController.showDrawer();
                    },
                    child: Image.asset(
                      'assets/icons/hlo_logo.png',
                      height: 32,
                    ),
                  ),
                  const Spacer(),
                  cBounce(
                    onPressed: () {
                      Get.to(() => const CommonWallet());
                    },
                    child: cCard(
                      radius: 20,
                      border: true,
                      borderColor: AppColors.mainColor,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 4),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/coin.png',
                              height: 22,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            ctext(
                                _.fbData.role == 'speaker'
                                    ? _.fbData.wallet
                                        .toString()
                                        .replaceAll(".00", "")
                                    : _.fbData.earnWallet
                                        .toString()
                                        .replaceAll(".00", ""),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.splashText),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  cBounce(
                    onPressed: () {
                      _.currpageIndex = 5;
                      _.update();
                      // Get.to(() => const MyProfile());
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: _.fbData.profileUrl != null
                          ? NetworkImage(_.fbData.profileUrl!)
                          : null,
                    ),
                  )
                ],
              ),
            ),
            titleSpacing: 0,
          ),
          body: LiquidPullToRefresh(
            // backgroundColor: AppColors.mainColor,
            color: AppColors.mainColor,
            onRefresh: () async {
              _.updateData();
              _.update();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    CarouselSlider(
                        items: List.generate(_.banner.length,
                            (index) => cImage(_.banner[index])),
                        options: CarouselOptions(
                          autoPlay: true,
                          viewportFraction: 0.8,
                          enlargeCenterPage: true,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ctext('Interest',
                                  fontWeight: FontWeight.w700, fontSize: 16),
                              cBounce(
                                  onPressed: () {
                                    if (_.fbData.role! == 'speaker') {
                                      String interest = '';
                                      for (var element in _.intData) {
                                        interest = '$interest${element.id},';
                                      }
                                      Get.to(() => SelectInterest(
                                            interest: interest.substring(
                                                0, interest.length - 1),
                                          ));
                                    } else {
                                      Get.to(() => const MoveToListner());
                                    }
                                  },
                                  child: ctext('Edit',
                                      color: AppColors.mainColor, fontSize: 14))
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          _.fbData.role == 'speaker'
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: _.intData
                                      .map((element) => InterestWidget(element))
                                      .toList())
                              : _.listnerIntData.id != null
                                  ? Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        InterestWidget(_.listnerIntData),
                                      ],
                                    )
                                  : const SizedBox(),
                          const SizedBox(
                            height: 24,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _.intData
                                .map((element) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            cImage(
                                              element.icon ?? '',
                                              height: 24,
                                              width: 24,
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            ctext(element.name ?? '',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: AppColors.splashText),
                                            const Spacer(),
                                            cBounce(
                                                onPressed: () {
                                                  Get.to(() => AllUsers(
                                                      element: element));
                                                },
                                                child: ctext('View All',
                                                    color: AppColors.mainColor,
                                                    fontSize: 14))
                                          ],
                                        ),
                                        const Divider(
                                          color: AppColors.subColor,
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        SizedBox(
                                          height: 150,
                                          child: _
                                                  .intData[_.intData
                                                      .indexOf(element)]
                                                  .list
                                                  .isNotEmpty
                                              ? ListView.separated(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (context, i) {
                                                    return cBounce(
                                                      onPressed: () {
                                                        Get.to(
                                                            () => OtherProfile(
                                                                  id: element
                                                                      .list[i]
                                                                      .id
                                                                      .toString(),
                                                                ));
                                                      },
                                                      child: cCard(
                                                          radius: 12,
                                                          shadow: false,
                                                          height: 80,
                                                          width: 140,
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  element
                                                                      .list[i]
                                                                      .profileUrl
                                                                      .toString())),
                                                          child: Stack(
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Container(
                                                                    height: 120,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                                                        gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
                                                                          AppColors
                                                                              .mainColor,
                                                                          AppColors
                                                                              .mainColor
                                                                              .withOpacity(0.1),
                                                                          Colors
                                                                              .transparent
                                                                          // Colors
                                                                          //     .transparent
                                                                        ])),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              7),
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            4,
                                                                        backgroundColor: (element.list[i].online ??
                                                                                false)
                                                                            ? Colors.green
                                                                            : Colors.red,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const Spacer(),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Flexible(
                                                                              child: ctext('${element.list[i].name},', color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                                                            ),
                                                                            ctext(element.list[i].age.toString(),
                                                                                textAlign: TextAlign.start,
                                                                                color: Colors.white,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            element.list[i].role == 'listner'
                                                                                ? Image.asset(
                                                                                    'assets/icons/listener.png',
                                                                                    color: Colors.yellow,
                                                                                    height: 12,
                                                                                  )
                                                                                : Image.asset(
                                                                                    'assets/icons/speaker.png',
                                                                                    color: Colors.orange,
                                                                                    height: 12,
                                                                                  ),
                                                                            const SizedBox(
                                                                              width: 6,
                                                                            ),
                                                                            ctext(element.list[i].role.toString(),
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Colors.white60),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const SizedBox(
                                                      width: 12,
                                                    );
                                                  },
                                                  itemCount: _
                                                      .intData[_.intData
                                                          .indexOf(element)]
                                                      .list
                                                      .length)
                                              : Center(
                                                  child: ctext('No Users Found',
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        )
                                      ],
                                    ))
                                .toList(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
