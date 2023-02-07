import 'package:digitalk/controller/home_controller.dart';
import 'package:digitalk/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: homeController.pages[homeController.tabIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: buttonColor,
            unselectedItemColor: primaryColor,
            backgroundColor: backgroundColor,
            onTap: (value) {
              homeController.tabIndex.value = value;
            },
            currentIndex: homeController.tabIndex.value,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: "Favourite"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_rounded), label: "Go live"),
              BottomNavigationBarItem(icon: Icon(Icons.copy), label: "Browse")
            ],
          ),
        ));
  }
}
