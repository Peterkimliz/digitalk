import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    initEngine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  void initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _addListeners();
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
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
}
