import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RoomController extends GetxController{
  TextEditingController textEditingControllerTitle=TextEditingController();

  File? image;
  RxString imagePath=RxString("");
  final _picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      imagePath.value = pickedFile.path;
      print(imagePath);
      update();
    } else {
      print('No image selected.');
    }
  }


}