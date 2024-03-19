import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/seven_day_forecast/sevenday_forecast_viewmodel.dart';
import '../../widgets/custom_textfields.dart';
import '../../widgets/loader_view.dart';

class SevenDayForecastView extends StatelessWidget {
  final SevenDayForecastViewModel viewModel =
      Get.put(SevenDayForecastViewModel());

  SevenDayForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Column(
              children: [searchTxtField(), listView()],
            ),
            const LoaderView(),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on_outlined),
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
        viewModel.fetchSevenDayForecast(value);
      },
    );
  }

  Widget listView() {
    return Expanded(
      child: Obx(
        () => (viewModel.forecasts.isNotEmpty)
            ? ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: viewModel.forecasts.length,
                itemBuilder: (context, index) {
                  return detailItem(
                    title: viewModel.forecasts[index].weather[0].description,
                    value: '${viewModel.forecasts[index].main.tempMin}',
                    unit: '',
                    iconUrl:
                        'http://openweathermap.org/img/wn/${viewModel.forecasts[index].weather[0].icon}.png',
                    index: index,
                  );
                },
              )
            : const Center(
                child: Text(
                  'No Location Found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
      ),
    );
  }

  Widget detailItem({
    required String title,
    required String value,
    required String iconUrl,
    required String unit,
    required int index,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.17),
      ),
      child: Row(
        children: [
          Image.network(iconUrl),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Obx(
                    () => Text(
                      (viewModel.forecasts[index].main.temp).toStringAsFixed(2),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
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
    );
  }
}
