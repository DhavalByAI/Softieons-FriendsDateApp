import 'dart:developer';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/utils/fatch_api.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_bounce.dart';
import 'package:new_friends_date_app/widget/sub_widgets/c_card.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:any_link_preview/any_link_preview.dart';

class Trendings extends StatefulWidget {
  const Trendings({super.key});

  @override
  State<Trendings> createState() => _TrendingsState();
}

class _TrendingsState extends State<Trendings> {
  List? trendsData;
  final ScrollController _sc = ScrollController();
  bool isVideo = false;
  List<bool> isExpanded = [];

  @override
  void initState() {
    fetchApi(url: 'get_tranding_data', get: true).then((value) {
      trendsData = value['data'];

      if (trendsData != null) {
        isExpanded.clear();
        for (var element in trendsData!) {
          isExpanded.add(false);
          List<String> tmpLink = [];
          element['tranding_type'] == 'Video'
              ? tmpLink.add(element['image_val'].toString().split('v=').last)
              : null;
        }
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafflodBackground,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12 + 24, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ctext(
                    'Trendings',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: AppColors.mainColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
              child: cCard(
                  child: Padding(
                padding: const EdgeInsets.all(12).copyWith(left: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: cBounce(
                        onPressed: () {
                          setState(() {
                            isVideo = false;
                          });
                        },
                        child: Column(
                          children: [
                            ctext('Posts/Images',
                                fontSize: 14,
                                fontWeight: !isVideo
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: !isVideo
                                    ? AppColors.mainColor
                                    : AppColors.gText),
                            SizedBox(
                              height: !isVideo ? 5 : 0,
                            ),
                            !isVideo
                                ? cCard(
                                    height: 4,
                                    width: 80,
                                    color: AppColors.mainColor)
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: cBounce(
                        onPressed: () {
                          setState(() {
                            isVideo = true;
                          });
                        },
                        child: Column(
                          children: [
                            ctext('Videos',
                                fontSize: 14,
                                fontWeight:
                                    isVideo ? FontWeight.w800 : FontWeight.w600,
                                color: isVideo
                                    ? AppColors.mainColor
                                    : AppColors.gText),
                            SizedBox(
                              height: isVideo ? 5 : 0,
                            ),
                            isVideo
                                ? cCard(
                                    height: 4,
                                    width: 40,
                                    color: AppColors.mainColor)
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ),
            trendsData != null
                ? (trendsData!.isNotEmpty)
                    ? !isVideo
                        ? Padding(
                            padding: const EdgeInsets.all(24).copyWith(top: 8),
                            child: ListView.separated(
                                controller: _sc,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return trendsData![index]['tranding_type'] ==
                                          'Image'
                                      ? cCard(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  trendsData![index]
                                                              ['image_val'] !=
                                                          'https://softieons.in/dating-fdl/storage/tranding'
                                                      ? cBounce(
                                                          onPressed: () {
                                                            final imageProvider =
                                                                Image.network(trendsData![
                                                                            index]
                                                                        [
                                                                        'image_val'])
                                                                    .image;
                                                            showImageViewer(
                                                                context,
                                                                imageProvider,
                                                                onViewerDismissed:
                                                                    () {});
                                                          },
                                                          child: cCard(
                                                            height: 200,
                                                            width: double
                                                                .maxFinite,
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: NetworkImage(
                                                                    trendsData![
                                                                            index]
                                                                        [
                                                                        'image_val'])),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  LinkifyText(
                                                    trendsData![index]
                                                            ['tranding_title']
                                                        .toString(),
                                                    linkStyle: const TextStyle(
                                                      color: Colors.blue,
                                                    ),
                                                    maxLines: !isExpanded[index]
                                                        ? 3
                                                        : null,
                                                    // softWrap: true,
                                                    // overflow:
                                                    //     TextOverflow.ellipsis,

                                                    onTap: (link) {
                                                      log(link.value
                                                          .toString());
                                                      _launchURL(link.value
                                                          .toString());
                                                    },
                                                  ),
                                                  trendsData![index][
                                                                  'tranding_title']
                                                              .toString()
                                                              .length >
                                                          130
                                                      ? cBounce(
                                                          onPressed: () {
                                                            setState(() {
                                                              isExpanded[
                                                                      index] =
                                                                  !isExpanded[
                                                                      index];
                                                            });
                                                          },
                                                          child: ctext(
                                                              isExpanded[index]
                                                                  ? 'Show Less'
                                                                  : 'Show More',
                                                              color:
                                                                  Colors.blue),
                                                        )
                                                      : const SizedBox(),
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      const Spacer(),
                                                      Icon(
                                                        Icons.timelapse_sharp,
                                                        size: 15,
                                                        color: AppColors.gText,
                                                      ),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),
                                                      ctext(
                                                          DateFormat(
                                                                  'HH:mm dd-MM-yyyy')
                                                              .format(DateTime.parse(
                                                                  trendsData![
                                                                          index]
                                                                      [
                                                                      'created_at'])),
                                                          fontSize: 12,
                                                          color:
                                                              AppColors.gText,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ],
                                                  ),
                                                ],
                                              )))
                                      : trendsData![index]['tranding_type'] ==
                                              'Link'
                                          ? cCard(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AnyLinkPreview(
                                                          link: trendsData![
                                                                      index]
                                                                  ['image_val']
                                                              .toString()),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      LinkifyText(
                                                        trendsData![index][
                                                                'tranding_title']
                                                            .toString(),
                                                        linkStyle:
                                                            const TextStyle(
                                                          color: Colors.blue,
                                                        ),
                                                        maxLines:
                                                            !isExpanded[index]
                                                                ? 3
                                                                : null,
                                                        // softWrap: true,
                                                        // overflow:
                                                        //     TextOverflow.ellipsis,

                                                        onTap: (link) {
                                                          log(link.value
                                                              .toString());
                                                          _launchURL(link.value
                                                              .toString());
                                                        },
                                                      ),
                                                      trendsData![index][
                                                                      'tranding_title']
                                                                  .toString()
                                                                  .length >
                                                              130
                                                          ? cBounce(
                                                              onPressed: () {
                                                                setState(() {
                                                                  isExpanded[
                                                                          index] =
                                                                      !isExpanded[
                                                                          index];
                                                                });
                                                              },
                                                              child: ctext(
                                                                  isExpanded[
                                                                          index]
                                                                      ? 'Show Less'
                                                                      : 'Show More',
                                                                  color: Colors
                                                                      .blue),
                                                            )
                                                          : const SizedBox(),
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons
                                                                .timelapse_sharp,
                                                            size: 15,
                                                            color:
                                                                AppColors.gText,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          ctext(
                                                              DateFormat(
                                                                      'HH:mm dd-MM-yyyy')
                                                                  .format(DateTime.parse(
                                                                      trendsData![
                                                                              index]
                                                                          [
                                                                          'created_at'])),
                                                              fontSize: 12,
                                                              color: AppColors
                                                                  .gText,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ],
                                                      ),
                                                    ],
                                                  )))
                                          : const SizedBox();
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: trendsData![index]
                                                    ['tranding_type'] ==
                                                'Image' ||
                                            trendsData![index]
                                                    ['tranding_type'] ==
                                                'Link'
                                        ? 12
                                        : 0,
                                  );
                                },
                                itemCount: trendsData!.length),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(24).copyWith(top: 8),
                            child: ListView.separated(
                                controller: _sc,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return trendsData![index]['tranding_type'] ==
                                          'Video'
                                      ? cCard(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  YoutubePlayer(
                                                    controller:
                                                        YoutubePlayerController(
                                                      initialVideoId:
                                                          trendsData![index]
                                                                  ['image_val']
                                                              .toString()
                                                              .split('v=')
                                                              .last,
                                                      flags:
                                                          const YoutubePlayerFlags(
                                                        autoPlay: false,
                                                        mute: false,
                                                      ),
                                                    ),
                                                    showVideoProgressIndicator:
                                                        true,
                                                    progressIndicatorColor:
                                                        AppColors.mainColor,
                                                    // progressColors: ProgressColors(
                                                    //     playedColor: Colors.amber,
                                                    //     handleColor: Colors.amberAccent,
                                                    // ),
                                                    onReady: () {
                                                      // _controller.addListener(listener);
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  LinkifyText(
                                                    trendsData![index]
                                                            ['tranding_title']
                                                        .toString(),
                                                    linkStyle: const TextStyle(
                                                      color: Colors.blue,
                                                    ),
                                                    maxLines: !isExpanded[index]
                                                        ? 3
                                                        : null,
                                                    onTap: (link) {
                                                      _launchURL(
                                                          link.toString());
                                                    },
                                                  ),
                                                  trendsData![index][
                                                                  'tranding_title']
                                                              .toString()
                                                              .length >
                                                          130
                                                      ? cBounce(
                                                          onPressed: () {
                                                            setState(() {
                                                              isExpanded[
                                                                      index] =
                                                                  !isExpanded[
                                                                      index];
                                                            });
                                                          },
                                                          child: ctext(
                                                              isExpanded[index]
                                                                  ? 'Show Less'
                                                                  : 'Show More',
                                                              color:
                                                                  Colors.blue),
                                                        )
                                                      : const SizedBox(),
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      const Spacer(),
                                                      Icon(
                                                        Icons.timelapse_sharp,
                                                        size: 15,
                                                        color: AppColors.gText,
                                                      ),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),
                                                      ctext(
                                                          DateFormat(
                                                                  'HH:mm dd-MM-yyyy')
                                                              .format(DateTime.parse(
                                                                  trendsData![
                                                                          index]
                                                                      [
                                                                      'created_at'])),
                                                          fontSize: 10,
                                                          color:
                                                              AppColors.gText,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ],
                                                  ),
                                                ],
                                              )))
                                      : const SizedBox();
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: trendsData![index]
                                                ['tranding_type'] ==
                                            'Video'
                                        ? 12
                                        : 0,
                                  );
                                },
                                itemCount: trendsData!.length),
                          )
                    : Center(
                        child: ctext('No History Found',
                            fontSize: 14, fontWeight: FontWeight.w600))
                : const SizedBox()
          ],
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
