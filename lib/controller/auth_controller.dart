import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalk/models/user.dart' as model;
import 'package:digitalk/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();
  TextEditingController textEditingControllerUsername = TextEditingController();
  RxBool creatingUser = RxBool(false);
  Rxn<model.User> currentUser = Rxn(null);

  final _auth = FirebaseAuth.instance;
  final _userRef = FirebaseFirestore.instance.collection("users");

  createUser({required context}) async {
    try {
      creatingUser.value = true;
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: textEditingControllerEmail.text.trim(),
          password: textEditingControllerPassword.text.trim());
      if (cred != null) {
        model.User user = model.User(
            username: textEditingControllerUsername.text.trim(),
            uid: cred.user!.uid,
            email: textEditingControllerEmail.text.trim());
        await _userRef.doc(cred.user!.uid).set(user.toJson());
        currentUser.value = user;
      }
      creatingUser.value = false;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      creatingUser.value = false;
    }
  }
}
