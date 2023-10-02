import 'package:flutter/material.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';
import 'package:new_friends_date_app/widget/sub_widgets/ctext.dart';

class CommingSoon extends StatelessWidget {
  const CommingSoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      // decoration: const BoxDecoration(
      //     image: DecorationImage(
      //         image: AssetImage(
      //           'assets/images/home_bg.png',
      //         ),
      //         fit: BoxFit.cover)),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/coming-soon.png",
            height: 150,
          ),
          const SizedBox(
            height: 36,
          ),
          Flexible(
            child: ctext('Live Streaming is \nComing Soon',
                textAlign: TextAlign.center,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.mainColor),
          )
        ],
      )),
    );
  }
}
