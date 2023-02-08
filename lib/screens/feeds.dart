import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalk/controller/room_controller.dart';
import 'package:digitalk/models/livestream.dart';
import 'package:digitalk/screens/broadCastScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedsScreen extends StatelessWidget {
  FeedsScreen({Key? key}) : super(key: key);
  RoomController roomController = Get.find<RoomController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Live Users",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("liveStream")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Livestream livestream = Livestream.fromJson(
                                snapshot.data!.docs[index].data());
                            return InkWell(
                              onTap: () async {
                                await roomController.updateViewCount(
                                    livestream.channelId, true);
                                Get.to(() => BroadCastScreen(
                                    isBroadCaster: false,
                                    channelId: livestream.channelId));
                              },
                              child: Container(
                                height: size.height * 0.1,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image.network(livestream.image),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          livestream.username,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          livestream.title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${livestream.viewers} watching",
                                        ),
                                        Text(
                                          "Started ${timeago.format(livestream.startedtAt.toDate())} ",
                                        )
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.more_vert))
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                            );
                          }),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
