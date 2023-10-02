import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/screens/profile_screen/other_profile.dart';
import 'package:new_friends_date_app/user/userData_model.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/widget/cachedImageNetwork.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';

class MatchScreenViewAll extends StatelessWidget {
  List<FbUserData> element;
  String icon;
  String name;
  MatchScreenViewAll(
      {super.key,
      required this.element,
      required this.icon,
      required this.name});

  ScrollController sc = ScrollController();
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
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: Row(
                  children: [
                    cBounce(
                      onPressed: () {
                        Get.back();
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black26,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.scafflodBackground,
                          child: Image.asset(
                            'assets/icons/back.png',
                            width: 18,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 24,
                    ),
                    cImage(
                      icon,
                      height: 24,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ctext(name,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: AppColors.mainColor),
                    const Spacer(),
                    const SizedBox(
                      width: 36,
                    ),
                  ],
                ),
              ),
              GridView.count(
                controller: sc,
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                shrinkWrap: true,
                children: List.generate(
                    element.length,
                    (i) => cBounce(
                          onPressed: () {
                            Get.to(() => OtherProfile(
                                  id: element[i].id.toString(),
                                ));
                          },
                          child: cCard(
                              radius: 12,
                              shadow: false,
                              height: 80,
                              width: 140,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(element[i].profileUrl!)),
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(12),
                                                    bottomRight:
                                                        Radius.circular(12)),
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  AppColors.mainColor,
                                                  AppColors.mainColor
                                                      .withOpacity(0.1),
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
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: CircleAvatar(
                                            radius: 4,
                                            backgroundColor:
                                                (element[i].online ?? false)
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: ctext(
                                                      '${element[i].name},',
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                ctext(element[i].age ?? '',
                                                    textAlign: TextAlign.start,
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/icons/speaker.png',
                                                  color: Colors.orange,
                                                  height: 12,
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                ctext('spekaer',
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
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
