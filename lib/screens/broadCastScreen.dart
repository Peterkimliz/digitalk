import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:digitalk/controller/auth_controller.dart';
import 'package:digitalk/controller/room_controller.dart';
import 'package:digitalk/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/const.dart';

class BroadCastScreen extends StatefulWidget {
  final isBroadCaster;
  final channelId;

  BroadCastScreen(
      {Key? key, required this.isBroadCaster, required this.channelId})
      : super(key: key);

  @override
  State<BroadCastScreen> createState() => _BroadCastScreenState();
}

class _BroadCastScreenState extends State<BroadCastScreen> {
  late RtcEngine _engine;
  List<int> remoteUid = [];
  AuthController authController = Get.find<AuthController>();
  RoomController roomController = Get.find<RoomController>();
  bool switchedCamera = false;
  bool isMuted = false;

  @override
  void initState() {
    initEngine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _leaveChamnnel();
        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              _renderVideo(),
              if ("${authController.currentUser.value!.uid}${authController.currentUser.value!.username}" ==
                  widget.channelId)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child:_toolbar(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _addListeners();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.enableAudioVolumeIndication(250, 10, true);
    await _engine.setDefaultAudioRouteToSpeakerphone(true);
    await _engine.enableVideo();
    await _engine.enableAudio();
    await _engine.startPreview();

    if (widget.isBroadCaster) {
      _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      _engine.setClientRole(ClientRole.Audience);
    }
    _joinChannel();
  }

  void _addListeners() {
    _engine.setEventHandler(
      RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
        debugPrint("joinChannelSuccess$channel,$uid,$elapsed");
      }, userJoined: (uid, elapsed) {
        debugPrint("userJoined$elapsed,$uid,");
        setState(() {
          remoteUid.add(uid);
        });
      }, userOffline: (uid, reason) {
        debugPrint("userJoined$reason,$uid,");
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });
      }, leaveChannel: (stats) {
        setState(() {
          remoteUid.clear();
        });
      }),
    );
  }

  void _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _engine.joinChannelWithUserAccount(
        token, "trial", FirebaseAuth.instance.currentUser!.uid);
  }

  _leaveChamnnel() async {
    await _engine.leaveChannel();
    if ("${authController.currentUser.value!.uid}${authController.currentUser.value!.username}" ==
        widget.channelId) {
      await roomController.endLiveStream(widget.channelId);
    } else {
      await roomController.updateViewCount(widget.channelId, false);
    }
    Get.off(() => HomeScreen());
  }

  _renderVideo() {
    return Container(
      height: double.infinity,
      child: "${authController.currentUser.value!.uid}${authController.currentUser.value!.username}" ==
                  widget.channelId
              ? RtcLocalView.SurfaceView(
                  zOrderMediaOverlay: true,
                  zOrderOnTop: true,
                )
              : remoteUid.isNotEmpty
                  ? RtcRemoteView.SurfaceView(
                      channelId: widget.channelId,
                      uid: remoteUid[0],
                    )
                  : Container(),
    );
  }

  void _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchedCamera = !switchedCamera;
      });
    });
  }

  void _muteMic() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine.muteLocalAudioStream(isMuted);
  }


  Widget _toolbar() {
    return widget.isBroadCaster
        ? Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: RawMaterialButton(
              onPressed: _muteMic,
              child: Icon(
                isMuted ? Icons.mic_off : Icons.mic,
                color: isMuted ? Colors.white : Colors.blueAccent,
                size: 20.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: isMuted ? Colors.blueAccent : Colors.white,
              padding: const EdgeInsets.all(12.0),
            ),
          ),
          Expanded(child: RawMaterialButton(
            onPressed: () => _leaveChamnnel(),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          )),
          Expanded(child: RawMaterialButton(
            onPressed: _switchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )),
         Expanded(child:  RawMaterialButton(
           onPressed: (){},
           child: Icon(
             Icons.message_rounded,
             color: Colors.blueAccent,
             size: 20.0,
           ),
           shape: CircleBorder(),
           elevation: 2.0,
           fillColor: Colors.white,
           padding: const EdgeInsets.all(12.0),
         )),
        ],
      ),
    ) : Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 48),
      child: RawMaterialButton(
        onPressed: (){},
        child: Icon(
          Icons.message_rounded,
          color: Colors.blueAccent,
          size: 20.0,
        ),
        shape: CircleBorder(),
        elevation: 2.0,
        fillColor: Colors.white,
        padding: const EdgeInsets.all(12.0),
      ),
    );
  }





}
