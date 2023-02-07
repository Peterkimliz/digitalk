import 'dart:ui';

import 'package:digitalk/controller/room_controller.dart';
import 'package:digitalk/utils/colors.dart';
import 'package:digitalk/widgets/custom_button.dart';
import 'package:digitalk/widgets/custom_text_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoLive extends StatelessWidget {
  GoLive({Key? key}) : super(key: key);
  RoomController roomController = Get.put<RoomController>(RoomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Obx(() {
                return roomController.imagePath.value.isEmpty
                    ? InkWell(
                        onTap: () {
                          roomController.getImage();
                        },
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          strokeCap: StrokeCap.round,
                          radius: Radius.circular(10),
                          dashPattern: [10, 4],
                          color: buttonColor,
                          child: Container(
                            width: double.infinity,
                            height: 140,
                            decoration: BoxDecoration(
                                color: buttonColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  color: buttonColor,
                                  size: 40,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Select your thumbnail",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.file(roomController.image!,fit: BoxFit.cover,),
                      );
              }),
              SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                        controller: roomController.textEditingControllerTitle,
                        type: "text"),
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: CustomButton(text: "Go live", onTap: () {
              roomController.startLiveStream(context: context);
            }),
          )
        ],
      ),
    )));
  }
}
