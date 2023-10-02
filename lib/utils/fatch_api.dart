import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'const.dart';

Future<dynamic> fetchApi(
    {required String url,
    bool? get,
    Object? params,
    Function(dynamic)? onSucess,
    bool? isloaderShow,
    bool errorLogShow = false}) async {
  try {
    (isloaderShow ?? true) ? EasyLoading.show() : null;
    log("API Calling ${AppConst.baseUrl + url} --> ${params.toString()}");

    var response = get == null
        ? await dio.post(
            AppConst.baseUrl + url,
            data: params,
          )
        : await dio.get(
            AppConst.baseUrl + url,
          );
    if (kDebugMode) {
      print(response.data.toString());
    }
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      if (response.data['success'].toString() == 'true' ||
          response.data['success'].toString() == 'success') {
        log("Got Data Successfully");

        onSucess != null ? onSucess(response.data) : null;
        return response.data;
      } else {
        EasyLoading.showError(response.data['message']);
        return null;
      }
    } else if (response.statusCode == 500) {
      EasyLoading.showError("Something Went Wrong");
      return null;
    } else {
      EasyLoading.showError("Didn't Get Data From API");
      if (kDebugMode) {
        print(response.data.toString());
      }
      log(response.toString());
      return null;
    }
  } catch (e) {
    EasyLoading.dismiss();
    errorLogShow ? EasyLoading.showError(e.toString()) : null;
    errorLogShow ? log(e.toString()) : null;
    return 'error';
  }
}
