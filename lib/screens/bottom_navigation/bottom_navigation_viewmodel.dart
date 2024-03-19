import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zekab_weather/screens/home/home_view.dart';
import 'package:zekab_weather/screens/seven_day_forecast/sevenday_forecast_view.dart';

class BottomNavigationBarViewModel extends GetxController {
  Widget changeIndex(int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return SevenDayForecastView();
      default:
        return Container(
          height: 300.0,
          width: Get.width,
          color: Colors.red,
        );
    }
  }
}
