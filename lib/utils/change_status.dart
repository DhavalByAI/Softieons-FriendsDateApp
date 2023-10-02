import 'package:cloud_firestore/cloud_firestore.dart';

import 'const.dart';

Future<void> changeStatus(var status,
    {String? userID, String? backgroundPhone}) async {
  status.toString() == '1'
      ? FirebaseFirestore.instance
          .collection("user")
          .doc(backgroundPhone ?? userData!.phoneNumber!)
          .update({'online': true})
      : FirebaseFirestore.instance
          .collection("user")
          .doc(backgroundPhone ?? userData!.phoneNumber!)
          .update({'online': false});
  // fetchApi(url: 'update_single_data', isloaderShow: false, params: {
  //   'user_id': userID ?? box.get('userId').toString(),
  //   'status': status.toString()
  // });
}
