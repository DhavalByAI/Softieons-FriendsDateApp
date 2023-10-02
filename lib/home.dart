import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/auth/login_screen.dart';
import 'package:new_friends_date_app/home_controller.dart';
import 'package:new_friends_date_app/screens/blocked_users.dart';
import 'package:new_friends_date_app/screens/coming_soon.dart';
import 'package:new_friends_date_app/screens/dashboard/dashboard_screen.dart';
import 'package:new_friends_date_app/screens/dashboard/move_to_listener.dart';
import 'package:new_friends_date_app/screens/match_screen/match_screen.dart';
import 'package:new_friends_date_app/screens/wallets/common_wallet.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/change_status.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/chat/screens/home_screen.dart';
import 'screens/profile_screen/my_profile.dart';
import 'screens/session/session_screen.dart';
import 'screens/trendings/trendings.dart';
import 'utils/const.dart';
import 'widget/sub_widgets/cbutton.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final HomeController _ = Get.put(HomeController());
  final InAppReview inAppReview = InAppReview.instance;
  List<Widget> pages = [
    DashboardScreen(),
    const Trendings(),
    const HomeScreen(),
    const SessionScreen(),
    const CommingSoon(),
    const MyProfile(),
    const MatchScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.exit_to_app_rounded,
                      color: AppColors.mainColor,
                      size: 48,
                    ),
                    ctext('Exit App',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mainColor),
                    const SizedBox(
                      height: 24,
                    ),
                    ctext(
                      'Are You Sure Wants to Exit The App?',
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        cButton('Exit',
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8), onTap: () {
                          SystemNavigator.pop();
                          return true;
                        },
                            txtColor: Colors.black,
                            btnColor: Colors.grey.withOpacity(0.5)),
                        cButton(
                          'Cancel',
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
        return false;
      },
      child: AdvancedDrawer(
        backdropColor: AppColors.mainColor,
        controller: _.drawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 36, left: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<HomeController>(
                  init: HomeController(),
                  initState: (_) {},
                  builder: (_) {
                    return Row(
                      children: [
                        cBounce(
                          onPressed: () {
                            _.drawerController.hideDrawer();
                            _.currpageIndex = 5;
                            _.update();
                          },
                          child: cCard(
                              shadow: false,
                              radius: 16,
                              height: 100,
                              width: 100,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(_.fbData.profileUrl ??
                                      'https://softieons.in/dating-fdl/storage/profile/user_image.png'))),
                        ),
                        const Spacer(),
                        FlutterSwitch(
                          height: 30,
                          width: 60,
                          onToggle: (value) {
                            changeStatus((_.fbData.online != null
                                    ? _.fbData.online!
                                    : false)
                                ? 0
                                : 1);
                          },
                          activeColor: AppColors.subColor,
                          activeToggleColor: Colors.white,
                          inactiveColor: Colors.white,
                          inactiveToggleColor: AppColors.mainColor,
                          value: _.fbData.online != null
                              ? _.fbData.online!
                              : false,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                ctext('Hey,',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
                GetBuilder<HomeController>(
                  initState: (_) {},
                  builder: (_) {
                    return ctext(_.fbData.name ?? '',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600);
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                cBounce(
                  onPressed: () {
                    _.drawerController.hideDrawer();
                    if (_.fbData.role == 'speaker') {
                      Get.to(() => const MoveToListner());
                    } else {
                      FirebaseFirestore.instance
                          .collection("user")
                          .doc(userData!.phoneNumber!)
                          .update({
                        'role': 'speaker',
                      });
                      userData!.role = 'speaker';
                      fetchApi(
                          url: 'update_single_data',
                          isloaderShow: false,
                          params: {
                            'user_id': userData!.id,
                            'role': 'speaker'
                          }).then((value) => Get.back());
                    }
                  },
                  child: cCard(
                    shadow: false,
                    color: Colors.white12,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/move_to.png',
                            height: 30,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          GetBuilder<HomeController>(
                            initState: (_) {},
                            builder: (_) {
                              return ctext(
                                  _.fbData.role == 'speaker'
                                      ? 'Earn / Move To Listener'
                                      : 'Move To Speaker',
                                  color: Colors.white,
                                  fontSize: 14);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                cBounce(
                  onPressed: () {
                    _.drawerController.hideDrawer();
                    _.currpageIndex = 5;
                    _.update();
                    // Get.to(() => const MyProfile());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/edit_profile.png',
                        height: 30,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      ctext('Edit Profile', color: Colors.white, fontSize: 14)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                cBounce(
                  onPressed: () {
                    _.drawerController.hideDrawer();
                    Get.to(() => const CommonWallet());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/wallet.png',
                        height: 30,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      ctext('Wallet', color: Colors.white, fontSize: 14)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                cBounce(
                  onPressed: () async {
                    _.drawerController.hideDrawer();
                    if (await inAppReview.isAvailable()) {
                      inAppReview.requestReview();
                    } else {
                      inAppReview.openStoreListing();
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/rate_us.png',
                        height: 30,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      ctext('Rate Us', color: Colors.white, fontSize: 14)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                cBounce(
                  onPressed: () async {
                    _.drawerController.hideDrawer();
                    Get.to(() => const Trendings());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/trendings.png',
                        height: 30,
                      ),
                      const SizedBox(
                      ),
                      ctext('Trendings', color: Colors.white, fontSize: 14)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                cBounce(
                  onPressed: () {
                    _.drawerController.hideDrawer();
                    _launchURL(userData!.privacyPageLink ??
                        'https://softieons.com/privacy-policy');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/privacy_policy.png',
                        height: 30,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      ctext('Privacy Policy', color: Colors.white, fontSize: 14)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                cBounce(
                  onPressed: () {
                    _.drawerController.hideDrawer();
                    _launchURL(userData!.termsPageLink ??
                        'https://softieons.com/terms-of-services');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/terms.png',
                        height: 30,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      ctext('Terms & Use', color: Colors.white, fontSize: 14)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                cBounce(
                  onPressed: () {
                    _.drawerController.hideDrawer();
                    Get.to(() => const BlockedUsers());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/block.png',
                        height: 30,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      ctext('Blocked Users', color: Colors.white, fontSize: 14)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                cBounce(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.logout_rounded,
                                  color: AppColors.mainColor,
                                  size: 48,
                                ),
                                ctext('Logout',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.mainColor),
                                const SizedBox(
                                  height: 24,
                                ),
                                ctext(
                                  'Are You Sure Wants to Log Out From The App?',
                                  fontSize: 14,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    cButton('Logout',
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8), onTap: () {
                                      _.drawerController.hideDrawer();
                                      changeStatus(0).then((value) {
                                        box.clear();
                                        Get.offAll(() => const LoginScreen());
                                      });
                                    },
                                        txtColor: Colors.black,
                                        btnColor: Colors.grey.withOpacity(0.5)),
                                    cButton(
                                      'Cancel',
                                      onTap: () {
                                        Get.back();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/logout.png',
                        height: 30,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      ctext('Logout', color: Colors.white, fontSize: 14)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
              ],
            ),
          ),
        ),
        child: GetBuilder<HomeController>(
          initState: (_) {},
          builder: (_) {
            return Scaffold(
              floatingActionButton: GetBuilder<HomeController>(
                initState: (_) {},
                builder: (_) {
                  return _.fbData.role == 'speaker'
                      ? FloatingActionButton(
                          backgroundColor: AppColors.mainColor,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/icons/hlo_logo.png',
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            _.currpageIndex = 6;
                            _.update();
                          },
                        )
                      : const SizedBox();
                },
              ),
              floatingActionButtonLocation: _.fbData.role == 'speaker'
                  ? FloatingActionButtonLocation.centerDocked
                  : null,
              bottomNavigationBar: GetBuilder<HomeController>(
                initState: (_) {},
                builder: (_) {
                  return AnimatedBottomNavigationBar(
                      icons: const [
                        Icons.home_rounded,
                        Icons.newspaper_rounded,
                        Icons.chat,
                        Icons.history_outlined,
                        Icons.live_tv_rounded,
                        Icons.person_3_rounded,
                      ],
                      inactiveColor: Colors.white.withOpacity(0.4),
                      activeColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      blurEffect: true,
                      elevation: 35,
                      iconSize: 28,
                      leftCornerRadius: kPadding,
                      rightCornerRadius: kPadding,
                      gapLocation: _.fbData.role == 'speaker'
                          ? GapLocation.center
                          : GapLocation.none,
                      activeIndex: _.currpageIndex,
                      notchSmoothness: NotchSmoothness.smoothEdge,
                      onTap: (index) {
                        _.currpageIndex = index;
                        _.update();
                      });
                },
              ),
              body: GetBuilder<HomeController>(
                initState: (_) {},
                builder: (_) {
                  return pages[_.currpageIndex];
                },
              ),
            );
          },
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
