import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zekab_weather/helper/theme_helper.dart';

class GetXHelper {
  static showSnackBar({required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.white,
        message: message,
        messageText: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        mainButton: backButton(),
      ),
    );
  }

  static Widget backButton() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, top: 5, right: 7),
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: ThemeHelper.primaryColor,
          borderRadius: BorderRadius.circular(33),
        ),
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}
