import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/screens/profile_screen/other_profile.dart';
import 'package:new_friends_date_app/screens/session/session_model.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  SessionModel? sessionData;
  final ScrollController _sc = ScrollController();
  @override
  void initState() {
    fetchApi(
            url: userData!.role == 'speaker'
                ? 'callListnerSessionHistory/${userData!.id}'
                : 'callSpeakerSessionHistory/${userData!.id}',
            get: true)
        .then((value) {
      setState(() {
        sessionData = SessionModel.fromJson(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafflodBackground,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          controller: _sc,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 24),
                child: Center(
                  child: ctext('Session History',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: AppColors.mainColor),
                ),
              ),
              sessionData != null
                  ? (sessionData!.data != null && sessionData!.data!.isNotEmpty)
                      ? ListView.separated(
                          controller: _sc,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return cBounce(
                              onPressed: () {
                                Get.to(() => OtherProfile(
                                    id: sessionData!.data![index].userId
                                        .toString()));
                              },
                              child: cCard(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: NetworkImage(
                                        sessionData!.data![index].imageurl!,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ctext(
                                            sessionData!.data![index].fullName!,
                                            color: AppColors.splashText,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              sessionData!.data![index].type ==
                                                      '0'
                                                  ? 'assets/icons/audio_call.png'
                                                  : 'assets/icons/video_call.png',
                                              height: 12,
                                              color: AppColors.mainColor,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            ctext(
                                                sessionData!.data![index]
                                                            .type ==
                                                        '0'
                                                    ? 'Audio Call'
                                                    : 'Video Call',
                                                color: AppColors.gText,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            // SizedBox(
                                            //   height: 16,
                                            //   width: 16,
                                            //   child: Center(
                                            //     child: Icon(Icons.circle,
                                            //         size: 6,
                                            //         color: AppColors.gText
                                            //             .withOpacity(0.5)),
                                            //   ),
                                            // ),
                                            Image.asset(
                                              'assets/icons/session_s.png',
                                              color: AppColors.mainColor,
                                              height: 12,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            ctext(
                                                '${sessionData!.data![index].totalMinutes} Min',
                                                color: AppColors.gText,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.date_range_rounded,
                                              size: 12,
                                              color: AppColors.subColor,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            ctext(
                                                '${sessionData!.data![index].uniqueCall!.split('.')[0].toString()} ',
                                                color: AppColors.gText,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400),
                                          ],
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    ctext(
                                        userData!.role == 'speaker'
                                            ? '- ${sessionData!.data![index].totalCredit!}'
                                            : '+ ${sessionData!.data![index].totalCredit!}',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Image.asset(
                                      'assets/icons/coin.png',
                                      height: 24,
                                    )
                                  ],
                                ),
                              )),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 12,
                            );
                          },
                          itemCount: sessionData!.data!.length)
                      : Center(
                          child: ctext('No History Found',
                              fontSize: 14, fontWeight: FontWeight.w600))
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
