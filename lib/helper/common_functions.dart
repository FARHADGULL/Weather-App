import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonFunctions {
  static void closeKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }
}
