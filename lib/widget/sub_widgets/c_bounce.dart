import 'package:flutter/cupertino.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:new_friends_date_app/utils/const.dart';

Bounce cBounce(
    {required Widget child, Duration? duration, void Function()? onPressed}) {
  return Bounce(
      duration: duration ?? const Duration(milliseconds: bounceDuration),
      onPressed: onPressed ?? () {},
      child: child);
}
