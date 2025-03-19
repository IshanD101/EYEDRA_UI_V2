import 'package:flutter/material.dart';
import '../../screens/virtual_campfire/video_session.dart';

class DirectVideoAccess {
  static void launchVideoSession(BuildContext context, {String? sessionId, String? userName}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return VideoConferencePage(
          conferenceID: sessionId ?? "default_session",
          userName: userName ?? "",
        );
      }),
    );
  }
}