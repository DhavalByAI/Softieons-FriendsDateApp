import 'package:get/get.dart';

class SelectedInterestController extends GetxController {
  RxList<String> selectedInterest = <String>[].obs;
  init(String interest) {
    interest.split(',').forEach((element) {
      selectedInterest.add(element);
    });
  }
}
