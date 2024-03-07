import 'package:flutter/material.dart';
import 'package:eee/utils/data.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallPage extends StatefulWidget {
  final String callId;
  const CallPage({super.key, required this.callId});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: AppString.appId,
      appSign: AppString.appSign,
      userID: auth.currentUser!.uid,
      userName: auth.currentUser!.displayName!,
      callID: widget.callId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }
}
