import 'package:zekab_weather/helper/global_variables.dart';

class Urls {
  static String baseURL = 'https://api.openweathermap.org/';
  static String getWeatherData =
      'data/2.5/weather?APPID=${GlobalVariables.weatherAppId}&units=metric&';
  static String getWeatherForecast =
      'data/2.5/forecast?APPID=${GlobalVariables.weatherAppId}&units=metric&cnt=7&';
}
