import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../screens/home/weather_model.dart';
import '../../helper/api_base_helper.dart';
import '../../helper/getx_helper.dart';
import '../../helper/global_variables.dart';
import '../../helper/urls.dart';

class HomeViewModel extends GetxController {
  final TextEditingController cityTextController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  Rx<WeatherModel> weatherModel = WeatherModel().obs;
  RxString location = 'Searching...'.obs;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    if (GetStorage().hasData('lastLocation')) {
      getLastLocationAndUpdate();
    } else {
      _fetchWeatherByLocation();
    }
  }

  Future<void> _fetchWeatherByLocation() async {
    print('Fetching weather by location');
    final locationPermissionStatus = await Permission.location.request();
    if (locationPermissionStatus.isGranted) {
      LocationData? locationData = await _getLocation();
      if (locationData != null) {
        final weather = await getWeatherByLocation(
          locationData.latitude!,
          locationData.longitude!,
        );
        location.value = weather;
      } else {
        Get.snackbar('Error', 'Failed to retrieve location data');
      }
    } else {
      Get.snackbar('Error', 'Location permission denied');
    }
  }

  Future<String> getWeatherByLocation(double latitude, double longitude) async {
    String url = '${Urls.getWeatherData}lat=$latitude&lon=$longitude';
    GlobalVariables.showLoader.value = true;
    final parsedJson = await ApiBaseHelper().getMethod(url: url);
    GlobalVariables.showLoader.value = false;
    if (parsedJson['cod'] == 200) {
      weatherModel.value = WeatherModel.fromJson(parsedJson);
      GetStorage().write('lastLocation', parsedJson['name']);
      GetXHelper.showSnackBar(message: 'Weather updated successfully');
      return parsedJson['name'];
    } else {
      GetXHelper.showSnackBar(message: parsedJson['message']);
      return '';
    }
  }

  Future<LocationData?> _getLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  getLastLocationAndUpdate() {
    location.value = GetStorage().read('lastLocation') ?? 'Islamabad, Pakistan';

    var data = GetStorage().read(location.value) ?? <String, dynamic>{};
    weatherModel.value = WeatherModel.fromJson(data);

    print(weatherModel.toJson());

    getWeatherUpdate(location.value);
  }

  getWeatherUpdate(String newLocation) {
    location.value = newLocation;
    cityTextController.clear();
    String url = '${Urls.getWeatherData}q=${location.value}';
    GlobalVariables.showLoader.value = true;
    ApiBaseHelper().getMethod(url: url).then((parsedJson) {
      GlobalVariables.showLoader.value = false;
      if (parsedJson['cod'] == 200) {
        weatherModel.value = WeatherModel.fromJson(parsedJson);
        GetStorage().write('lastLocation', location.value);
        GetXHelper.showSnackBar(message: 'Weather updated successfully');
      } else {
        GetXHelper.showSnackBar(message: parsedJson['message']);
      }
    }).catchError((e) {
      print(e);
    });
  }

  String convertTimeStampToTime(int? timeStamp) {
    String time = 'N/A';
    if (timeStamp != null) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
      time = DateFormat("hh:mm a").format(dateTime);
    }

    return time;
  }

  String getCurrentDate() {
    String date = '';
    DateTime dateTime = DateTime.now();

    date = DateFormat("EEEE | MMM dd").format(dateTime);

    return date;
  }

  takeScreenShot() {
    screenshotController.capture().then((Uint8List? image) {
      if (image != null) {
        previewAndSaveScreenShot(image);
      }
    }).catchError((onError) {
      GetXHelper.showSnackBar(message: onError.toString());
    });
  }

  previewAndSaveScreenShot(Uint8List image) async {
    try {
      final tempDirectory = await getTemporaryDirectory(); //path_provider
      final imagePath =
          await File('${tempDirectory.path}/captured.png').writeAsBytes(image);
      final croppedImage = await ImageCropper()
          .cropImage(sourcePath: imagePath.path, aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ], uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          cropGridColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Images'),
      ]);

      if (croppedImage != null) {
        final croppedBytes = await croppedImage.readAsBytes();
        await saveScreenShot(croppedBytes);
        await shareScreenshot(croppedImage.path);
      }
    } catch (e) {
      GetXHelper.showSnackBar(message: 'Failed to save screenshot');
    }
  }

  saveScreenShot(Uint8List image) async {
    final result = await ImageGallerySaver.saveImage(image);
    if (result['isSuccess']) {
      GetXHelper.showSnackBar(message: 'Screenshot saved successfully');
    } else {
      GetXHelper.showSnackBar(message: 'Failed to save screenshot');
    }
  }

  shareScreenshot(String imagePath) {
    Share.shareXFiles([XFile(imagePath)], text: 'Weather screenshot');
  }
}
