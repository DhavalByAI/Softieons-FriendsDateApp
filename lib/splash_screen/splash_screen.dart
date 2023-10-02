import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/auth/login_screen.dart';
import 'package:new_friends_date_app/auth/signup_screen.dart';
import 'package:new_friends_date_app/splash_screen/splash_controller.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/widget/cachedImageNetwork.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:dots_indicator/dots_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List get pages => [page1(), page2()];

  final SplashController _ = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: page1());
  }

  Widget page1() {
    return GetBuilder<SplashController>(
      initState: (_) {},
      builder: (_) {
        return _.SplashBanner.isNotEmpty
            ? Stack(
                children: [
                  Positioned(
                    top: 40,
                    child: cImage(
                      _.SplashBanner[0]['image'],
                      width: dwidth,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      height: dheight,
                      width: dwidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Spacer(),
                          ctext(
                              'It’s Easy To Find A\nSoul Mate Nearby &\nAround You',
                              fontSize: 28,
                              maxLines: 3,
                              fontWeight: FontWeight.w800,
                              textAlign: TextAlign.center,
                              color: AppColors.splashText),
                          const SizedBox(
                            height: 6,
                          ),
                          ctext(
                              'Interact with people with the same\ninterest like you',
                              fontSize: 16,
                              maxLines: 2,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                              color: AppColors.splashText),
                          const SizedBox(
                            height: 12,
                          ),
                          Obx(() => DotsIndicator(
                                dotsCount: 3,
                                position: _.currPage.value,
                                decorator: DotsDecorator(
                                  activeColor: AppColors.mainColor,
                                  size: const Size.square(9.0),
                                  activeSize: const Size(28.0, 9.0),
                                  activeShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: cButton('Next', onTap: () {
                              _.currPage.value++;
                              Get.offAll(
                                () => page2(),
                                transition: Transition.rightToLeft,
                              );
                            },
                                radius: 30,
                                padding: const EdgeInsets.all(14),
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : const SizedBox();
      },
    );
  }

  Widget page2() {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40,
            child: cImage(
              _.SplashBanner[1]['image'],
              width: dwidth,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              height: dheight,
              width: dwidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  ctext('Navigate the \nRealm of Love',
                      fontSize: 28,
                      maxLines: 3,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      color: AppColors.splashText),
                  const SizedBox(
                    height: 6,
                  ),
                  ctext('Seek Your Soul Mate \nNearby and Beyond.',
                      fontSize: 16,
                      maxLines: 2,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      color: AppColors.splashText),
                  const SizedBox(
                    height: 12,
                  ),
                  Obx(() => DotsIndicator(
                        dotsCount: 3,
                        position: _.currPage.value,
                        decorator: DotsDecorator(
                          activeColor: AppColors.mainColor,
                          size: const Size.square(9.0),
                          activeSize: const Size(28.0, 9.0),
                          activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: cButton('Next', onTap: () {
                      _.currPage.value++;
                      Get.offAll(
                        () => page3(),
                        transition: Transition.rightToLeft,
                      );
                    },
                        radius: 30,
                        padding: const EdgeInsets.all(14),
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget page3() {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40,
            child: Container(
              child: cImage(
                _.SplashBanner[2]['image'],
                width: dwidth,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              height: dheight,
              width: dwidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  ctext('Discover Your \nPerfect Match \nNearby & Around You',
                      fontSize: 28,
                      maxLines: 3,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      color: AppColors.splashText),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, bottom: 12, top: 24),
                    child: cBounce(
                      onPressed: () {
                        Get.offAll(() => const LoginScreen(),
                            curve: Curves.bounceInOut);
                      },
                      child: cCard(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: Image.asset(
                                    'assets/icons/call.png',
                                    height: 20,
                                  ),
                                ),
                                const Spacer(),
                                ctext('Login With Email/Mobile',
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                const Spacer(),
                                const SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 24, right: 24, bottom: 12),
                  //   child: cCard(
                  //       color: AppColors.mainColor,
                  //       borderRadius: BorderRadius.circular(30),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(6),
                  //         child: Row(
                  //           children: [
                  //             CircleAvatar(
                  //               backgroundColor: Colors.white,
                  //               radius: 20,
                  //               child: Image.asset(
                  //                 'assets/icons/gmail.png',
                  //                 height: 20,
                  //               ),
                  //             ),
                  //             const Spacer(),
                  //             ctext('Login With Google',
                  //                 color: Colors.white,
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.w600),
                  //             const Spacer(),
                  //             const SizedBox(
                  //               width: 20,
                  //             )
                  //           ],
                  //         ),
                  //       )),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ctext('Don\'t have any account ? ',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.splashText),
                      cBounce(
                        onPressed: () {
                          Get.to(() => const SignupScreen(),
                              curve: Curves.bounceInOut);
                        },
                        child: ctext(
                          'sign up ',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
