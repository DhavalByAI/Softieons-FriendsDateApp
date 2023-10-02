import 'package:flutter/material.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'c_bounce.dart';
import 'ctext.dart';

Widget cButton(String text,
    {double? height,
    double? width,
    String? icon,
    double? iconHeight,
    double? iconWidth,
    Function()? onTap,
    double? fontSize,
    FontWeight? fontWeight,
    EdgeInsetsGeometry? padding,
    Color? btnColor,
    Color? txtColor,
    Color? iconColor,
    double? radius,
    BoxBorder? border}) {
  return cBounce(
    onPressed: onTap,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          border: border,
          color: btnColor ?? AppColors.mainColor,
          borderRadius: BorderRadius.circular(radius ?? 8)),
      child: Center(
          child: Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Image.asset(
                      icon,
                      color: iconColor,
                      height: iconHeight ?? 16,
                      width: iconWidth ?? 16,
                    ),
                  )
                : const SizedBox(),
            ctext(text,
                color: txtColor ?? Colors.white,
                fontSize: fontSize,
                fontWeight: fontWeight),
          ],
        ),
      )),
    ),
  );
}
