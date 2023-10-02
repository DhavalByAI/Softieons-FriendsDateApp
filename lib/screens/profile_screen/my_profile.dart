import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_friends_date_app/home_controller.dart';
import 'package:new_friends_date_app/screens/profile_screen/my_profile_controller.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctextfield_common.dart';
import 'package:new_friends_date_app/widget/sub_widgets/interest.dart';
import 'package:http/http.dart' as http;

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final TextEditingController _tx =
      TextEditingController(text: userData!.about);

  final ScrollController _sc = ScrollController();

  final MyProfileController _ = Get.put(MyProfileController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: dheight! + 150,
        child: Scaffold(
          backgroundColor: AppColors.scafflodBackground,
          body: Stack(
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/profile_bg.png',
                  ),
                ],
              ),
              Positioned(
                top: 60,
                child: SingleChildScrollView(
                  controller: _sc,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: dwidth,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 60,
                              ),
                              cCard(
                                  width: dwidth,
                                  radius: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 70,
                                        bottom: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: ctext(userData!.fullName!,
                                              color: AppColors.splashText,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                ctext(
                                                    userData!.photos!.length
                                                        .toString(),
                                                    color: AppColors.mainColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                ctext('Photos',
                                                    color: AppColors.gText
                                                        .withOpacity(0.6),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24),
                                              child: Container(
                                                height: 60,
                                                width: 1,
                                                color: AppColors.mainColor
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                userData!.role!.toString() ==
                                                        'speaker'
                                                    ? Image.asset(
                                                        'assets/icons/speaker.png',
                                                        height: 20,
                                                        color: Colors.orange,
                                                      )
                                                    : Image.asset(
                                                        'assets/icons/listener.png',
                                                        height: 20,
                                                        color: Colors.yellow,
                                                      ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                ctext(
                                                    userData!.role!.toString(),
                                                    color: AppColors.gText
                                                        .withOpacity(0.6),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ctext('Bio',
                                                color: AppColors.splashText,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                            GetBuilder<MyProfileController>(
                                              initState: (_) {},
                                              builder: (_) {
                                                return !_.bioEditing
                                                    ? cButton('Edit',
                                                        onTap: () {
                                                        _.bioEditing =
                                                            !_.bioEditing;
                                                        _.update();
                                                      },
                                                        icon:
                                                            'assets/icons/edit.png',
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 4,
                                                                bottom: 4,
                                                                left: 8,
                                                                right: 8))
                                                    : cButton('Done',
                                                        btnColor: AppColors
                                                            .gText
                                                            .withOpacity(0.4),
                                                        txtColor: Colors.white,
                                                        onTap: () {
                                                        _.bioEditing =
                                                            !_.bioEditing;
                                                        fetchApi(
                                                            url:
                                                                'update_single_data',
                                                            params: {
                                                              'user_id': userData!
                                                                  .id
                                                                  .toString(),
                                                              'about': _tx.text
                                                                  .toString()
                                                            }).then((value) {
                                                          userData!.about = _tx
                                                              .text
                                                              .toString();
                                                          _.update();
                                                        });
                                                      },
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 4,
                                                                bottom: 4,
                                                                left: 8,
                                                                right: 8));
                                              },
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          color: AppColors.mainColor,
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        GetBuilder<MyProfileController>(
                                          initState: (_) {},
                                          builder: (_) {
                                            return cCard(
                                              border: true,
                                              borderColor: _.bioEditing
                                                  ? AppColors.mainColor
                                                  : Colors.grey
                                                      .withOpacity(0.5),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: cTextFieldCommon(
                                                  autoFocus: _.bioEditing,
                                                  enabled: _.bioEditing,
                                                  controller: _tx,
                                                  maxLines: 4,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        ctext('Interests',
                                            color: AppColors.splashText,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                        const Divider(
                                          color: AppColors.mainColor,
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        GetBuilder<HomeController>(
                                          initState: (_) {},
                                          builder: (_) {
                                            return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: _.intData
                                                    .map((element) =>
                                                        InterestWidget(element,
                                                            height: 90,
                                                            width: 90))
                                                    .toList());
                                          },
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                height: 24,
                              ),
                              cCard(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20, right: 20, bottom: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ctext('Photos',
                                              color: AppColors.splashText,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                          // GetBuilder<MyProfileController>(
                                          //   initState: (_) {},
                                          //   builder: (_) {
                                          //     return cButton('More', onTap: () {
                                          //       _.bioEditing = !_.bioEditing;
                                          //       _.update();
                                          //     },
                                          //         padding:
                                          //             const EdgeInsets.only(
                                          //                 top: 4,
                                          //                 bottom: 4,
                                          //                 left: 8,
                                          //                 right: 8));
                                          //   },
                                          // ),
                                        ],
                                      ),
                                      const Divider(
                                        color: AppColors.mainColor,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      SizedBox(
                                        height: 120,
                                        child: ListView.separated(
                                            controller: _sc,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return GetBuilder<
                                                  MyProfileController>(
                                                initState: (_) {},
                                                builder: (_) {
                                                  return Stack(
                                                    children: [
                                                      (index !=
                                                              (userData!.photos!
                                                                  .length))
                                                          ? cCard(
                                                              radius: 16,
                                                              height: 110,
                                                              width: 90,
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: NetworkImage(
                                                                      userData!
                                                                              .photos![
                                                                          index])))
                                                          : cBounce(
                                                              onPressed:
                                                                  () async {
                                                                _.photos[0] =
                                                                    await ImagePicker()
                                                                        .pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .gallery,
                                                                );
                                                                _.update();
                                                                await registerAPI();
                                                              },
                                                              child: cCard(
                                                                  border: true,
                                                                  borderColor: AppColors
                                                                      .mainColor
                                                                      .withOpacity(
                                                                          0.6),
                                                                  radius: 16,
                                                                  height: 110,
                                                                  width: 90,
                                                                  child: Icon(
                                                                    Icons
                                                                        .add_a_photo_rounded,
                                                                    color: AppColors
                                                                        .mainColor
                                                                        .withOpacity(
                                                                            0.6),
                                                                  )),
                                                            ),
                                                      index !=
                                                                  userData!
                                                                      .photos!
                                                                      .length &&
                                                              userData!.photos!
                                                                      .length !=
                                                                  1
                                                          ? Positioned(
                                                              right: 4,
                                                              top: 4,
                                                              child: cBounce(
                                                                onPressed: () {
                                                                  fetchApi(
                                                                          get:
                                                                              true,
                                                                          url:
                                                                              'delete_photo/${userData!.id}/$index')
                                                                      .then(
                                                                          (value) {
                                                                    userData!
                                                                        .photos!
                                                                        .removeAt(
                                                                            index);
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                },
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 10,
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .gText,
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 12,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox()
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                                      width: 12,
                                                    ),
                                            itemCount:
                                                userData!.photos!.length + 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: dwidth,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            cBounce(
                              onPressed: () async {
                                _.photos[0] = await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                );
                                _.update();
                                await uploadProfile();
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 56,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(userData!.profileImage!),
                                    ),
                                  ),
                                  Positioned(
                                    top: 05,
                                    right: 05,
                                    child: Image.asset(
                                      'assets/icons/edit_circle.png',
                                      height: 25,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> registerAPI() async {
    EasyLoading.show();
    // try {
    var request = http.MultipartRequest(
        "POST", Uri.parse('${AppConst.baseUrl}update_single_data'));
    final List<http.MultipartFile> newList = [];

    if (_.photos[0] != null) {
      final multiImages =
          http.MultipartFile.fromPath('photos[]', _.photos[0]!.path);
      newList.add(await multiImages);
    }

    request.files.addAll(newList);
    request.headers['Authorization'] = 'Bearer ${box.get('t')}';
    request.fields['user_id'] = userData!.id!.toString();
    var response = await request.send();
    Map<String, dynamic> val =
        json.decode(await response.stream.bytesToString());
    log(val.toString());
    if (val['success'].toString() == 'true' ||
        val['success'].toString() == 'success') {
      fetchApi(url: 'user_photos_list/${userData!.id.toString()}', get: true)
          .then((value) {
        List tmpList = (value['data'] as List);
        userData!.photos?.clear();
        for (var element in tmpList) {
          userData!.photos?.add(element);
          setState(() {});
        }
      });
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.showError(val['message'].toString());
      return false;
    }

    // } catch (e) {
    //   EasyLoading.showError('Something Went Wrong, Please Try Again');
    //   return false;
    //   // Navigator.pop(context);
    //   // setState(() {
    //   //   Navigator.of(context);
    //   //   ErrorDialouge.showErrorDialogue(context, _keyError, e.toString());
    //   //   print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    //   //   print("Exeption $e");
    //   // });
    // }
  }

  Future<bool> uploadProfile() async {
    EasyLoading.show();
    // try {
    var request = http.MultipartRequest(
        "POST", Uri.parse('${AppConst.baseUrl}update_profile'));
    final List<http.MultipartFile> newList = [];
    if (_.photos[0] != null) {
      final multiImages =
          http.MultipartFile.fromPath('image', _.photos[0]!.path);
      newList.add(await multiImages);
    }

    request.files.addAll(newList);
    request.headers['Authorization'] = 'Bearer ${box.get('t')}';
    request.fields['user_id'] = userData!.id!.toString();
    var response = await request.send();
    Map<String, dynamic> val =
        json.decode(await response.stream.bytesToString());
    log(val.toString());
    if (val['success'].toString() == 'true' ||
        val['success'].toString() == 'success') {
      userData!.profileImage = val['data']['image'];
      FirebaseFirestore.instance
          .collection('user')
          .doc(userData!.phoneNumber)
          .update({
        'profileUrl': val['data']['image'].toString(),
      });
      setState(() {});
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.showError(val['message'].toString());
      return false;
    }

    // } catch (e) {
    //   EasyLoading.showError('Something Went Wrong, Please Try Again');
    //   return false;
    //   // Navigator.pop(context);
    //   // setState(() {
    //   //   Navigator.of(context);
    //   //   ErrorDialouge.showErrorDialogue(context, _keyError, e.toString());
    //   //   print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    //   //   print("Exeption $e");
    //   // });
    // }
  }
}
