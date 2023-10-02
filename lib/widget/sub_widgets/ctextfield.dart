import 'package:flutter/material.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';

import 'c_card.dart';
import 'ctext.dart';

Widget cTextField({
  required String title,
  required Widget textField,
  EdgeInsetsGeometry? padding,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(
        height: 12,
      ),
      ctext(" $title", fontSize: 14),
      const SizedBox(
        height: 4,
      ),
      cCard(
          radius: 10,
          shadow: false,
          border: true,
          borderColor: AppColors.subColor,
          color: Colors.white,
          child: Padding(
            padding: padding ??
                const EdgeInsets.only(left: 12, top: 10, bottom: 10, right: 8),
            child: textField,
          )),
    ],
  );
}
