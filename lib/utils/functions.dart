import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Functions {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future <String> uploadImage({required childName, required File image, required uid}) async {
    Reference reference = _firebaseStorage.ref().child(childName).child(uid);
    UploadTask uploadTask = reference.putFile(image, SettableMetadata(contentType: "image/jpg"));

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
