import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RoomController extends GetxController{


  File? image;
  String ?imagePath;
  final _picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      imagePath = pickedFile.path;
      print(imagePath);
      update();
    } else {
      print('No image selected.');
    }
  }


}