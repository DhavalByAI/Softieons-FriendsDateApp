import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/screens/chat/api/apis.dart';
import 'package:new_friends_date_app/screens/chat/helper/my_date_util.dart';
import 'package:new_friends_date_app/screens/chat/screens/chat_screen.dart';
import 'package:new_friends_date_app/screens/profile_screen/other_profile.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import '../models/chat_user.dart';
import '../models/message.dart';

//card to represent a single user in home screen
class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: cCard(
        // margin: EdgeInsets.symmetric(horizontal: dwidth! * .04, vertical: 4),
        // // color: Colors.blue.shade100,
        // elevation: 0.5,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        radius: 20,
        child: cBounce(
            onPressed: () {
              Get.to(() => ChatScreen(user: widget.user));
            },
            child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) _message = list[0];

                return ListTile(
                    //user profile picture
                    leading: cBounce(
                      onPressed: () {
                        Get.to(() => OtherProfile(id: widget.user.id));
                        // showDialog(
                        //     context: context,
                        //     builder: (_) => ProfileDialog(user: widget.user));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(dheight! * .03),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: dheight! * .055,
                          height: dheight! * .055,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                    ),

                    //user name
                    title: Text(widget.user.name),

                    //last message
                    subtitle: Text(
                        _message != null
                            ? _message!.type == Type.image
                                ? 'image'
                                : _message!.msg
                            : widget.user.about,
                        maxLines: 1),

                    //last message time
                    trailing: _message == null
                        ? null //show nothing when no message is sent
                        : _message!.read.isEmpty &&
                                _message!.fromId != userData!.id.toString()
                            ?
                            //show for unread message
                            Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: AppColors.mainColor.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            :
                            //message sent time
                            ctext(
                                MyDateUtil.getLastMessageTime(
                                    context: context, time: _message!.sent),
                                color: Colors.black54));
              },
            )),
      ),
    );
  }
}
