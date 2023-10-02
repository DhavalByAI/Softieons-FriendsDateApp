import 'package:flutter/material.dart';
import 'package:new_friends_date_app/utils/const.dart';
import 'c_card.dart';

Future<dynamic> bottomSheet(
    {required BuildContext context,
    required String title,
    required Widget child,
    ScrollController? controller}) {
  return showModalBottomSheet(
    enableDrag: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        controller: controller,
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: cCard(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: kPadding - 4,
                  ),
                  cCard(color: Colors.grey, height: 4, width: 45),
                  SizedBox(
                    height: kPadding,
                  ),
                  child
                ],
              )),
        ),
      );
    },
  );
}
