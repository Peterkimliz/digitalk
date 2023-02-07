import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalk/controller/auth_controller.dart';
import 'package:digitalk/models/livestream.dart';
import 'package:digitalk/utils/functions.dart';
import 'package:digitalk/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RoomController extends GetxController {
  TextEditingController textEditingControllerTitle = TextEditingController();
  Functions _functions = Functions();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  File? image;
  RxString imagePath = RxString("");
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

  Future<String> startLiveStream({required context}) async {
    AuthController authController = Get.find<AuthController>();
    String channelId = "";
    try {
      if (textEditingControllerTitle.text.isEmpty || image == null) {
        showSnackBar(context, "Please enter all fields");
      } else {
        if (!((await _firebaseFirestore
                .collection("liveStream")
                .doc("${authController.currentUser.value!.uid!}${authController.currentUser.value!.username!}")
                .get())
            .exists)) {
          String downloadUrl = await _functions.uploadImage(
              childName: "livestreamThumbnails",
              image: image!,
              uid: _firebaseAuth.currentUser!.uid);
          channelId =
              "${authController.currentUser.value!.uid!}${authController.currentUser.value!.username!}";
          Livestream livestream = Livestream(
              uid: authController.currentUser.value!.uid!,
              image: downloadUrl,
              username: authController.currentUser.value!.username!,
              title: textEditingControllerTitle.text,
              channelId: channelId,
              startedtAt: DateTime.now(),
              viewers: 0);

          _firebaseFirestore
              .collection("liveStream")
              .doc(channelId)
              .set(livestream.toJson());
        } else {
          showSnackBar(
              context, "two livestreams cannot start at the same time");
        }
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message.toString());
      print(e);
    }
    return channelId;
  }
}
