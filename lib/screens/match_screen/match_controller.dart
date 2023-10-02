import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MatchController extends GetxController {
  @override
  void onInit() {
    FirebaseFirestore.instance.collection("user").snapshots().listen(
      (event) {
        // userListWithStatus = event.docs.map((e) => e.data()).toList();
        // for (var data in userListWithStatus) {
        //   for (var element in intData) {
        //     for (var e in element.list) {
        //       if ((e['phone_number'] == data['phone'])) {
        //         if (e['status'] != (data['online'] ? '1' : '0')) {
        //           e['status'] = data['online'] ? '1' : '0';
        //           changeStatus(e['status'], userID: e['id'].toString());
        //         }
        //         update();
        //       }
        //     }
        //   }
        // }
      },
    );

    super.onInit();
  }
}
