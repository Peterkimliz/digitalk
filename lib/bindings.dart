import 'package:digitalk/controller/auth_controller.dart';
import 'package:digitalk/controller/home_controller.dart';
import 'package:digitalk/controller/room_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<RoomController>(RoomController(), permanent: true);
    // TODO: implement dependencies
  }
}
