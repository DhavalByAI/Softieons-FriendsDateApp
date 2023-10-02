import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';

import '../api/apis.dart';

import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';

//home screen -- where all available contacts are shown
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for storing all users
  List<ChatUser> _list = [];

  // for storing searched items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (userData!.userId != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scafflodBackground,
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ctext('Chat',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: AppColors.mainColor),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: APIs.getMyUsersId(),

                  //get id of only known users
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(child: CircularProgressIndicator());

                      //if some or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        return StreamBuilder(
                          stream: APIs.getAllUsers(
                              snapshot.data?.docs.map((e) => e.id).toList() ??
                                  []),

                          //get only those user, who's ids are provided
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              //if data is loading
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                              // return const Center(
                              //     child: CircularProgressIndicator());

                              //if some or all data is loaded then show it
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data?.docs;
                                _list = data
                                        ?.map(
                                            (e) => ChatUser.fromJson(e.data()))
                                        .toList()
                                        .reversed
                                        .toList() ??
                                    [];
                                if (_list.isNotEmpty) {
                                  return ListView.separated(
                                      shrinkWrap: true,
                                      controller: scrollController,
                                      itemCount: _isSearching
                                          ? _searchList.length
                                          : _list.length,
                                      // padding:
                                      //     EdgeInsets.only(top: dheight! * .01),
                                      physics: const BouncingScrollPhysics(),
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: _list[index]
                                                  .blockedBy
                                                  .contains(
                                                      userData!.id.toString())
                                              ? 0
                                              : 12,
                                        );
                                      },
                                      itemBuilder: (context, index) {
                                        // log(_list[index].blockedBy.toString());
                                        return _list[index].blockedBy.contains(
                                                userData!.id.toString())
                                            ? const SizedBox()
                                            : ChatUserCard(
                                                user: _isSearching
                                                    ? _searchList[index]
                                                    : _list[index]);
                                      });
                                } else {
                                  return const Center(
                                    child: Text('No Connections Found!',
                                        style: TextStyle(fontSize: 20)),
                                  );
                                }
                            }
                          },
                        );
                    }
                  },
                ),
                const SizedBox(
                  height: 36,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
