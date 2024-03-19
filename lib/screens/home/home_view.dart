import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '../../screens/home/home_viewmodel.dart';
import '../../widgets/loader_view.dart';
import '../../widgets/custom_textfields.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeViewModel viewModel = Get.put(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: viewModel.screenshotController,
      child: Scaffold(
        appBar: appBar(),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xff3c6fd1), Color(0xff7ca9ff)],
            stops: [0.25, 0.87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    searchTxtField(),
                    iconAndTemp(),
                    divider(),
                    weatherValues(),
                    divider(),
                  ],
                ),
              ),
              const LoaderView(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            viewModel.takeScreenShot();
          },
          child: const Icon(Icons.camera_alt),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: Colors.white,
          ),
          Obx(
            () => Text(viewModel.location.value),
          ),
        ],
      ),
    );
  }

  Widget searchTxtField() {
    return CustomTextField(
      hint: 'Search Location...',
      prefixIcon: Icons.search,
      controller: viewModel.cityTextController,
      onSubmitted: (value) {
        viewModel.getWeatherUpdate(value);
      },
    );
  }

  Widget iconAndTemp() {
    return Column(
      children: [
        weatherIcon(),
        Text(
          viewModel.getCurrentDate(),
          style: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 17, color: Colors.white),
        ),
        Wrap(
          children: [
            Obx(
              () => Text(
                (viewModel.weatherModel.value.main?.temp ?? 00)
                    .toStringAsFixed(0),
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 45,
                    color: Colors.white),
              ),
            ),
            const Text(
              ' o',
              style: TextStyle(
                color: Colors.white,
                fontFeatures: [FontFeature.superscripts()],
                fontSize: 14,
              ),
            ),
          ],
        ),
        Obx(
          () => Text(
            viewModel.weatherModel.value.weather?.first.main ?? 'N/A',
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget weatherIcon() {
    return Obx(
      () => CachedNetworkImage(
        height: 120,
        width: 120,
        imageUrl:
            'https://openweathermap.org/img/wn/${viewModel.weatherModel.value.weather?.first.icon ?? ''}@4x.png',
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            height: 120,
            width: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Image.asset('assets/images/clouds.png'),
          );
        },
        placeholder: (context, url) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Divider(),
    );
  }

  Widget weatherValues() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => detailItem(
                title: 'Minimum',
                value: '${viewModel.weatherModel.value.main?.tempMin ?? 'N/A'}',
                unit: '',
                icon: CupertinoIcons.down_arrow,
              ),
            ),
            SizedBox(width: 10),
            Obx(
              () => detailItem(
                title: 'Maximum',
                value: '${viewModel.weatherModel.value.main?.tempMax ?? 'N/A'}',
                unit: '',
                icon: CupertinoIcons.up_arrow,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => detailItem(
                title: 'Wind',
                value: '${viewModel.weatherModel.value.wind?.speed ?? 'N/A'}',
                unit: 'm/s',
                icon: Icons.wind_power,
              ),
            ),
            SizedBox(width: 10),
            Obx(
              () => detailItem(
                title: 'Feel like ',
                value:
                    '${viewModel.weatherModel.value.main?.feelsLike ?? 'N/A'}',
                unit: '',
                icon: Icons.cloudy_snowing,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget detailItem(
      {required String title,
      required String value,
      required IconData icon,
      required String unit}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.17),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value != 'N/A' ? '$value $unit' : value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
