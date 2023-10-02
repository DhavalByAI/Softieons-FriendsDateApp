import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/screens/profile_screen/other_profile.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';

class BlockedUsers extends StatefulWidget {
  const BlockedUsers({super.key});

  @override
  State<BlockedUsers> createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  BlockedModel? blockedUsersData;
  final ScrollController _sc = ScrollController();
  @override
  void initState() {
    fetchApi(url: 'block_user_list/${userData!.id}', get: true).then((value) {
      setState(() {
        blockedUsersData = BlockedModel.fromJson(value);
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
                    ctext('Blocked Users',
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
              blockedUsersData != null
                  ? (blockedUsersData!.data != null &&
                          blockedUsersData!.data!.isNotEmpty)
                      ? ListView.separated(
                          controller: _sc,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return cBounce(
                              onPressed: () {
                                Get.to(() => OtherProfile(
                                    id: blockedUsersData!.data![index].id
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
                                        blockedUsersData!.data![index].image!,
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
                                            blockedUsersData!
                                                .data![index].name!,
                                            color: AppColors.splashText,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    cButton(
                                      'Unblock',
                                      onTap: () {
                                        fetchApi(url: 'unblock_user', params: {
                                          'user_id': userData!.id.toString(),
                                          'block_user_id': blockedUsersData!
                                              .data![index].id
                                              .toString()
                                        }).then((value) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(blockedUsersData!
                                                  .data![index].id
                                                  .toString())
                                              .update({
                                            'blockedBy': FieldValue.arrayRemove(
                                                [userData!.id.toString()])
                                          });
                                          FirebaseFirestore.instance
                                              .collection('user')
                                              .doc(userData!.phoneNumber
                                                  .toString())
                                              .update({
                                            'blockedByMe':
                                                FieldValue.arrayRemove([
                                              blockedUsersData!.data![index].id
                                                  .toString()
                                            ])
                                          });
                                          blockedUsersData!.data!.remove(
                                              blockedUsersData!.data!
                                                  .firstWhere((element) =>
                                                      element.id ==
                                                      blockedUsersData!
                                                          .data![index].id));
                                          setState(() {});
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                      width: 4,
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
                          itemCount: blockedUsersData!.data!.length)
                      : Center(
                          child: ctext('No Data Found',
                              fontSize: 14, fontWeight: FontWeight.w600))
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

class BlockedModel {
  bool? _success;
  List<Data>? _data;

  BlockedModel({bool? success, List<Data>? data}) {
    if (success != null) {
      _success = success;
    }
    if (data != null) {
      _data = data;
    }
  }

  bool? get success => _success;
  set success(bool? success) => _success = success;
  List<Data>? get data => _data;
  set data(List<Data>? data) => _data = data;

  BlockedModel.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = <Data>[];
      json['data'].forEach((v) {
        _data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = _success;
    if (_data != null) {
      data['data'] = _data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? _id;
  String? _name;
  int? _age;
  String? _image;

  Data({int? id, String? name, int? age, String? image}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (age != null) {
      _age = age;
    }
    if (image != null) {
      _image = image;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  int? get age => _age;
  set age(int? age) => _age = age;
  String? get image => _image;
  set image(String? image) => _image = image;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _age = json['age'];
    _image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['age'] = _age;
    data['image'] = _image;
    return data;
  }
}
