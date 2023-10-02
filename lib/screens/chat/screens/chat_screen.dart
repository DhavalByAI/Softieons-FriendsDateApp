import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_friends_date_app/home.dart';
import 'package:new_friends_date_app/home_controller.dart';
import 'package:new_friends_date_app/screens/profile_screen/other_profile.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_dropdown.dart';
import 'package:new_friends_date_app/widget/sub_widgets/cbutton.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctextfield_common.dart';
import '../api/apis.dart';

import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? selectedReason;
  //for storing all messages
  List<Message> _list = [];

  //for handling message text changes
  final _textController = TextEditingController();
  final reportText = TextEditingController();

  //showEmoji -- for storing value of showing or hiding emoji
  //isUploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if emojis are shown & back button is pressed then hide emojis
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_showEmoji) {
            setState(() => _showEmoji = !_showEmoji);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scafflodBackground,
          //body
          body: Column(
            children: [
              cCard(
                  height: 100,
                  color: AppColors.mainColor,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _appBar(),
                  )),
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();

                      //if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: dheight! * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(message: _list[index]);
                              });
                        } else {
                          return const Center(
                            child: Text('Say Hii! 👋',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  },
                ),
              ),

              //progress indicator for showing uploading
              if (_isUploading)
                const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: CircularProgressIndicator(strokeWidth: 2))),

              //chat input filed
              _chatInput(),

              //show emojis on keyboard emoji button click & vice versa
              if (_showEmoji)
                SizedBox(
                  height: dheight! * .35,
                  child: EmojiPicker(
                    textEditingController: _textController,
                    config: Config(
                      bgColor: const Color.fromARGB(255, 234, 248, 255),
                      columns: 8,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    return cBounce(
        onPressed: () {
          Get.to(() => OtherProfile(id: widget.user.id));
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              // HomeController _ = Get.find();
              // FbUserData? status = _.listOfUser.firstWhereOrNull(
              //   (element) {
              //     return element.phone.toString() ==
              //         widget.user.email.toString();
              //   },
              // );
              return Row(
                children: [
                  //back button
                  const SizedBox(
                    width: 12,
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white)),
                  const SizedBox(
                    width: 12,
                  ),
                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(dheight! * .03),
                    child: CachedNetworkImage(
                      width: dheight! * .05,
                      height: dheight! * .05,
                      fit: BoxFit.cover,
                      imageUrl:
                          list.isNotEmpty ? list[0].image : widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  //for adding some space
                  const SizedBox(width: 10),

                  //user name & last seen time
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //user name
                      Text(list.isNotEmpty ? list[0].name : widget.user.name,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),

                      //for adding some space
                      const SizedBox(height: 2),

                      //last seen time of user
                      GetBuilder<HomeController>(
                        builder: (_) {
                          return Text(
                              _.listOfUser.firstWhereOrNull(
                                        (element) {
                                          return element.phone.toString() ==
                                              widget.user.email.toString();
                                        },
                                      ) !=
                                      null
                                  ? _.listOfUser.firstWhereOrNull(
                                      (element) {
                                        return element.phone.toString() ==
                                            widget.user.email.toString();
                                      },
                                    )!.online!
                                      ? 'Online'
                                      : 'Offline'
                                  : 'Offline',
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.subColor));
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  PopupMenuButton<int>(
                    color: Colors.white,
                    onSelected: (item) {
                      if (item == 0) {
                        fetchApi(url: 'block_user', params: {
                          'user_id': userData!.id.toString(),
                          'block_user_id': widget.user.id
                        }).then((value) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.user.id)
                              .update({
                            'blockedBy':
                                FieldValue.arrayUnion([userData!.id.toString()])
                          }).then((value) => Get.offAll(() => Home()));
                        });
                      } else {
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
                                      Icons.report_problem_rounded,
                                      color: AppColors.mainColor,
                                      size: 48,
                                    ),
                                    ctext('Report User',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    cDropDown(
                                      hintText: "   Select Reason",
                                      items: [
                                        'It\'s Spam',
                                        'Nudity or sexual activity',
                                        'Hate speech or symbols',
                                        'False information',
                                        'Bullying or harassment',
                                        'Scam or fraud',
                                        'Violence or dangerous organisations',
                                        'Intellectual property violation',
                                        'Sale or illegal or regulated goods'
                                      ],
                                      onChanged: (val) {
                                        List tmpList = [
                                          'It\'s Spam',
                                          'Nudity or sexual activity',
                                          'Hate speech or symbols',
                                          'False information',
                                          'Bullying or harassment',
                                          'Scam or fraud',
                                          'Violence or dangerous organisations',
                                          'Intellectual property violation',
                                          'Sale or illegal or regulated goods'
                                        ];
                                        selectedReason = tmpList[val!];
                                        setState(() {});
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    cCard(
                                      border: true,
                                      borderColor: AppColors.mainColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: cTextFieldCommon(
                                          controller: reportText,
                                          hint: 'Reason for Report',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        cButton('Report', onTap: () {
                                          selectedReason != null
                                              ? fetchApi(
                                                  url: 'report_user',
                                                  params: {
                                                      'user_id': userData!.id,
                                                      'report_user_id':
                                                          widget.user.id,
                                                      'text':
                                                          'Chat --> ${selectedReason!} : ${reportText.text}'
                                                    }).then((value) {
                                                  Get.back();
                                                  Get.offAll(() => Home());
                                                })
                                              : EasyLoading.showError(
                                                  'Please Select Appropriate Reason for Reporting User');
                                        },
                                            txtColor: Colors.black,
                                            btnColor:
                                                Colors.grey.withOpacity(0.5)),
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
                      }
                    },
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context) => [
                      const PopupMenuItem<int>(
                          enabled: true,
                          value: 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.block_rounded,
                                size: 20,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text('Block'),
                            ],
                          )),
                      const PopupMenuItem<int>(
                          value: 1,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.report_gmailerrorred_rounded,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text('Report'),
                            ],
                          )),
                    ],
                  ),
                ],
              );
            }));
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: dheight! * .01, horizontal: dwidth! * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: cCard(
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(15)),
              radius: 14,
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: AppColors.mainColor, size: 25)),

                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(
                            color: AppColors.mainColor.withOpacity(0.5)),
                        border: InputBorder.none),
                  )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Picking multiple images
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);

                        // uploading & sending image one by one
                        for (var i in images) {
                          log('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.image,
                          color: AppColors.mainColor, size: 26)),

                  //take image from camera button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);

                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: AppColors.mainColor, size: 26)),

                  //adding some space
                  SizedBox(width: dwidth! * .02),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          //send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  //simply send message
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: AppColors.subColor,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
