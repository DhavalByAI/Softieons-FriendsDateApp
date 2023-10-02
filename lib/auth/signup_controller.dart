import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController {
  RxInt selectedGender = 0.obs;
  RxList<XFile?> photos = <XFile?>[null, null, null, null].obs;
  RxList<String> selectedInterest = RxList.empty();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cnfmPassword = TextEditingController();
}
