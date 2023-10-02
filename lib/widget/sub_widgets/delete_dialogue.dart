import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_friends_date_app/utils/const.dart';

Future<dynamic> deleteDialogue(
    {required BuildContext context, required Function() onPressed}) {
  return showDialog(
    barrierColor: Colors.black.withOpacity(0.7),
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Are you sure you want to delete?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Cancel',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onPressed();
              Get.back();
            },
            child: const Text('Delete'),
          ),
          SizedBox(
            width: kPadding / 2,
          )
        ],
      );
    },
  );
}
