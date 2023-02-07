import 'dart:typed_data';

import 'package:digitalk/screens/feeds.dart';
import 'package:digitalk/screens/go_live.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt tabIndex = RxInt(0);
  TextEditingController textEditingControllerTitle=TextEditingController();
  List pages = [
    FeedsScreen(),
    GoLive(),
    Center(child: Text("browse"),)
  ];

}