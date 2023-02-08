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

import '../widgets/loading_widget.dart';

class RoomController extends GetxController {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
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
        LoadingDialog.showLoadingDialog(
            context: context, title: "Creating Liveshow", key: _keyLoader);
        if (!((await _firebaseFirestore
                .collection("liveStream")
                .doc(
                    "${authController.currentUser.value!.uid!}${authController.currentUser.value!.username!}")
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

          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          clearInputs();
        } else {
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          showSnackBar(
              context, "two livestreams cannot start at the same time");
        }
      }
    } on FirebaseException catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      showSnackBar(context, e.message.toString());
      print(e);
    }
    return channelId;
  }

  Future<void> endLiveStream(String channelId) async {
    try {
      await _firebaseFirestore.collection("liveStream").doc(channelId).delete();
    } catch (e) {
      print(e);
    }
  }

  updateViewCount(String id, bool isIncreased) async {
    try {
      await _firebaseFirestore
          .collection("liveStream")
          .doc(id)
          .update({"viewers": FieldValue.increment(isIncreased ? 1 : -1)});
    } catch (e) {
      print(e);
    }
  }

  clearInputs() {
    textEditingControllerTitle.clear();
    image = null;
    imagePath.value = "";
  }
}
