import 'package:digitalk/bindings.dart';
import 'package:digitalk/controller/auth_controller.dart';
import 'package:digitalk/screens/onboard.dart';
import 'package:digitalk/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  AuthController authController=Get.put<AuthController>(AuthController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Digi Talk',
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: backgroundColor,
            iconTheme: IconThemeData(color: primaryColor),
            appBarTheme: AppBarTheme().copyWith(
                backgroundColor: backgroundColor,
                elevation: 0.0,
                titleTextStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600))),
        initialBinding: AppBindings(),
        home: Onboard());
  }
}
