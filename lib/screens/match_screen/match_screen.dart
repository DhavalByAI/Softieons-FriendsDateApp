import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/home_controller.dart';
import 'package:new_friends_date_app/screens/profile_screen/other_profile.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/widget/cachedImageNetwork.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';

import 'view_all.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafflodBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                ),
                child: Center(
                  child: ctext('Match',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: AppColors.mainColor),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              GetBuilder<HomeController>(
                initState: (_) {},
                builder: (_) {
                  return _.matchData != null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _.matchData
                              .map(
                                (element) => element.list.isNotEmpty
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              cImage(
                                                lsData
                                                    .firstWhere((e) =>
                                                        element.id.toString() ==
                                                        e.id)
                                                    .icon!,
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
                                                    Get.to(() =>
                                                        MatchScreenViewAll(
                                                          element: element.list,
                                                          icon: lsData
                                                              .firstWhere((e) =>
                                                                  element.id
                                                                      .toString() ==
                                                                  e.id)
                                                              .icon!,
                                                          name: element.name!,
                                                        ));
                                                  },
                                                  child: ctext('View All',
                                                      color:
                                                          AppColors.mainColor,
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
                                            child: ListView.separated(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, i) {
                                                  return cBounce(
                                                    onPressed: () {
                                                      Get.to(() => OtherProfile(
                                                            id: element
                                                                .list[i].id
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
                                                                element.list[i]
                                                                        .profileUrl ??
                                                                    '')),
                                                        child: Stack(
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Container(
                                                                  height: 120,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: const BorderRadius.only(
                                                                              bottomLeft: Radius.circular(
                                                                                  12),
                                                                              bottomRight: Radius.circular(
                                                                                  12)),
                                                                          gradient: LinearGradient(
                                                                              begin: Alignment.bottomCenter,
                                                                              end: Alignment.topCenter,
                                                                              colors: [
                                                                                AppColors.mainColor,
                                                                                AppColors.mainColor.withOpacity(0.1),
                                                                                Colors.transparent
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
                                                                        const EdgeInsets
                                                                            .all(7),
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius: 4,
                                                                      backgroundColor: (element.list[i].online ??
                                                                              false)
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Column(
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
                                                                            child: ctext('${element.list[i].name},',
                                                                                color: Colors.white,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600),
                                                                          ),
                                                                          ctext(
                                                                              element.list[i].age ?? '',
                                                                              textAlign: TextAlign.start,
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            'assets/icons/listener.png',
                                                                            color:
                                                                                Colors.yellow,
                                                                            height:
                                                                                12,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                6,
                                                                          ),
                                                                          ctext(
                                                                              'listner',
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
                                                itemCount: element.list.length),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          )
                                        ],
                                      )
                                    : const SizedBox(),
                              )
                              .toList(),
                        )
                      : const SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
