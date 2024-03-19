import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zekab_weather/helper/global_variables.dart';
import 'package:zekab_weather/screens/bottom_navigation/bottom_navigation_viewmodel.dart';

class BottomNavigationView extends StatelessWidget {
  const BottomNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarViewModel viewModel =
        Get.put(BottomNavigationBarViewModel());

    return Scaffold(
      body:
          Obx(() => viewModel.changeIndex(GlobalVariables.selectedIndex.value)),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: GlobalVariables.selectedIndex.value,
          onTap: (index) {
            GlobalVariables.selectedIndex.value = index;
            viewModel.changeIndex(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.today),
              label: 'Today',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Seven Days',
            ),
          ],
        ),
      ),
    );
  }
}
