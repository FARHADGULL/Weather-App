import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zekab_weather/screens/seven_day_forecast/sevenday_forecast_model.dart';

import '../../helper/api_base_helper.dart';
import '../../helper/getx_helper.dart';
import '../../helper/global_variables.dart';
import '../../helper/urls.dart';
import '../home/weather_model.dart';

class SevenDayForecastViewModel extends GetxController {
  final TextEditingController cityTextController = TextEditingController();

  RxList<Forecast> forecasts = <Forecast>[].obs;
  RxString location = 'Location'.obs;
  Rx<WeatherModel> weatherModel = WeatherModel().obs;

  fetchSevenDayForecast(String city) async {
    cityTextController.clear();
    location.value = city;
    String url = '${Urls.getWeatherForecast}q=${city}';
    GlobalVariables.showLoader.value = true;
    ApiBaseHelper().getMethod(url: url).then((parsedJson) {
      GlobalVariables.showLoader.value = false;
      if (parsedJson['cod'] == '200') {
        final sevenDayForecast = SevenDayForecast.fromJson(parsedJson);
        forecasts.clear();
        forecasts.addAll(sevenDayForecast.list);
      } else {
        GetXHelper.showSnackBar(message: parsedJson['message']);
      }
    });
  }

  String getFormattedDate(String date) {
    var dateTime = DateTime.parse(date);
    var formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(dateTime);
  }
}
