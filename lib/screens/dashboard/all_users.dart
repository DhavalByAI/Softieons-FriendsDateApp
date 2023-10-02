import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/screens/profile_screen/other_profile.dart';
import 'package:new_friends_date_app/user/interest_model.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/widget/cachedImageNetwork.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';

class AllUsers extends StatelessWidget {
  InterestData element;
  AllUsers({super.key, required this.element});
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
                      element.icon!,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    ctext(element.name!,
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
                      element.list.length,
                      (i) => cBounce(
                            onPressed: () {
                              Get.to(() => OtherProfile(
                                    id: element.list[i].id.toString(),
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
                                        element.list[i].profileUrl.toString())),
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
                                                  (element.list[i].online ??
                                                          false)
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
                                                        '${element.list[i].name},',
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  ctext(
                                                      element.list[i].age
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.start,
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  element.list[i].role ==
                                                          'listner'
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
                                                  ctext(
                                                      element.list[i].role
                                                          .toString(),
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                          ))),
            ],
          ),
        ),
      ),
    );
  }
}
