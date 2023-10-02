import 'package:flutter/material.dart';
import 'package:new_friends_date_app/user/interest_model.dart';
import 'package:new_friends_date_app/widget/cachedImageNetwork.dart';

import '../../utils/app_colors.dart';
import 'c_bounce.dart';
import 'c_card.dart';
import 'ctext.dart';

Widget InterestWidget(InterestData element, {double? height, double? width}) {
  return Flexible(
    child: cBounce(
      onPressed: () {},
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: cCard(
          height: height ?? 100,
          width: width ?? 100,
          shadow: false,
          borderColor: AppColors.subColor.withOpacity(0.4),
          border: true,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                cImage(
                  element.icon ?? '',
                  height: 40,
                ),
                const SizedBox(
                  height: 8,
                ),
                ctext(element.name ?? '',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.splashText),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
