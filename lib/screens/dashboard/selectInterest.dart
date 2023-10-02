import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/screens/dashboard/selectedInterestController.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:new_friends_date_app/widget/cachedImageNetwork.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';

class SelectInterest extends StatelessWidget {
  String interest;
  SelectInterest({super.key, required this.interest});
  final ScrollController _sc = ScrollController();
  final SelectedInterestController _ = Get.put(SelectedInterestController());
  @override
  Widget build(BuildContext context) {
    _.init(interest);
    return Scaffold(
      backgroundColor: AppColors.scafflodBackground,
      bottomSheet: Container(
        height: 24 + 50,
        color: AppColors.scafflodBackground,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 0,
            bottom: 24,
            left: 24,
            right: 24,
          ),
          child: cButton('Select', onTap: () {
            if (_.selectedInterest.length == 3) {
              String interest = '';
              for (var element in _.selectedInterest) {
                interest = '$interest$element,';
              }
              FirebaseFirestore.instance
                  .collection("user")
                  .doc(userData!.phoneNumber!)
                  .update({'interest': interest});
              fetchApi(url: 'update_single_data', isloaderShow: false, params: {
                'user_id': box.get('userId').toString(),
                'industry_id': interest,
              }).then((value) => Get.back());
            } else {
              EasyLoading.showToast('Please Select Any 3 Interest',
                  dismissOnTap: true,
                  toastPosition: EasyLoadingToastPosition.bottom);
            }
          },
              radius: 30,
              padding: const EdgeInsets.all(14),
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24, right: 24, left: 24),
        child: SingleChildScrollView(
          controller: _sc,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                ),
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
                    const SizedBox(
                      width: 12,
                    ),
                    ctext('Select Your Interest',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: AppColors.mainColor),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
              Obx(() => interestData.isNotEmpty
                  ? GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      controller: _sc,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 24,
                      children: List.generate(
                        interestData.length,
                        (index) => cBounce(
                          onPressed: () {
                            _.selectedInterest
                                    .contains(interestData[index].id.toString())
                                ? _.selectedInterest
                                    .remove(interestData[index].id.toString())
                                : _.selectedInterest
                                    .add(interestData[index].id.toString());
                          },
                          child: cCard(
                            radius: 16,
                            height: 50,
                            borderWidth: _.selectedInterest
                                    .contains(interestData[index].id)
                                ? 3
                                : 2,
                            borderColor: _.selectedInterest
                                    .contains(interestData[index].id)
                                ? AppColors.mainColor
                                : AppColors.subColor.withOpacity(0.4),
                            border: true,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ctext(interestData[index].name!,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColors.splashText),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: cImage(interestData[index].icon!),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}
