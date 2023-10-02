import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import '../../../widget/sub_widgets/c_bounce.dart';
import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/my_date_util.dart';
import '../models/message.dart';

// for showing single message details
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = userData!.id.toString() == widget.message.fromId;
    return InkWell(
        enableFeedback: false,
        autofocus: false,
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

  // sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: widget.message.type == Type.image
                ? EdgeInsets.all(dwidth! * .02)
                : EdgeInsets.symmetric(
                    horizontal: dwidth! * 0.03, vertical: dwidth! * 0.02),
            margin: EdgeInsets.symmetric(
                horizontal: dwidth! * .04, vertical: dheight! * .005),
            decoration: BoxDecoration(
                color: AppColors.subColor.withOpacity(0.5),
                // border: Border.all(color: Colors.lightBlue),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(
                        fontSize: 15, color: AppColors.mainColor),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: cBounce(
                      onPressed: () {
                        final imageProvider =
                            Image.network(widget.message.msg).image;
                        showImageViewer(context, imageProvider,
                            onViewerDismissed: () {});
                      },
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(12),
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image, size: 70),
                      ),
                    ),
                  ),
          ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: dwidth! * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(
                fontSize: 10, color: Color.fromARGB(137, 19, 8, 8)),
          ),
        ),
      ],
    );
  }

  // our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        // SizedBox(
        //   width: dwidth! * 0.03,
        // ),
        Row(
          children: [
            //for adding some space
            SizedBox(width: dwidth! * .04),

            // double tick blue icon for message read
            // if (widget.message.read.isNotEmpty)
            //   const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            // //for adding some space
            // const SizedBox(width: 2),

            // //sent time
            // Text(
            //   MyDateUtil.getFormattedTime(
            //       context: context, time: widget.message.sent),
            //   style: const TextStyle(fontSize: 13, color: Colors.black54),
            // ),
          ],
        ),

        //message content
        Flexible(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: widget.message.type == Type.image
                    ? EdgeInsets.all(dwidth! * .02)
                    : EdgeInsets.symmetric(
                        horizontal: dwidth! * 0.03, vertical: dwidth! * 0.02),
                margin: EdgeInsets.symmetric(
                    horizontal: dwidth! * .04, vertical: dheight! * .005),
                decoration: const BoxDecoration(
                    color: AppColors.mainColor,
                    // border: Border.all(color: Colors.lightGreen),
                    //making borders curved
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                child: widget.message.type == Type.text
                    ?
                    //show text
                    Text(
                        widget.message.msg,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      )
                    :
                    //show image
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: cBounce(
                          onPressed: () {
                            final imageProvider =
                                Image.network(widget.message.msg).image;
                            showImageViewer(context, imageProvider,
                                doubleTapZoomable: true,
                                swipeDismissible: true,
                                closeButtonTooltip: 'close',
                                onViewerDismissed: () {});
                          },
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image, size: 70),
                          ),
                        ),
                      ),
              ),
              Row(
                children: [
                  //for adding some space
                  // SizedBox(width: dwidth! * .04),
                  const Spacer(),
                  // double tick blue icon for message read
                  if (widget.message.read.isNotEmpty)
                    const Icon(Icons.done_all_rounded,
                        color: Colors.blue, size: 12),

                  //for adding some space
                  const SizedBox(width: 2),

                  //sent time
                  Text(
                    MyDateUtil.getFormattedTime(
                        context: context, time: widget.message.sent),
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: dheight! * .015, horizontal: dwidth! * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              widget.message.type == Type.text
                  ?
                  //copy option
                  _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);

                          Dialogs.showSnackbar(context, 'Text Copied!');
                        });
                      })
                  :
                  //save option
                  _OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          [Permission.manageExternalStorage].request();
                          log('Image Url: ${widget.message.msg}');
                          var response = await Dio().get(widget.message.msg,
                              options:
                                  Options(responseType: ResponseType.bytes));
                          await ImageGallerySaver.saveImage(
                              Uint8List.fromList(response.data),
                              quality: 60,
                              name: "Saved Image");
                          Navigator.pop(context);
                          // if (success != null && success) {
                          Dialogs.showSnackbar(
                              context, 'Image Successfully Saved!');
                          // }
                        } catch (e) {
                          log('ErrorWhileSavingImg: $e');
                        }
                      }),

              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: dwidth! * .04,
                  indent: dwidth! * .04,
                ),

              //edit option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.pop(context);

                      _showMessageUpdateDialog();
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.black54,
                endIndent: dwidth! * .04,
                indent: dwidth! * .04,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message')
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                      APIs.updateMessage(widget.message, updatedMsg);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: dwidth! * .05,
              top: dheight! * .015,
              bottom: dheight! * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}
