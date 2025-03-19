import 'package:flutter/material.dart';
import '../../screens/virtual_campfire/home_page_camp.dart'; // Updated import

class DirectVideoAccess {
  static void launchVideoSession(BuildContext context, {String? sessionId, String? userName}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        // Navigate to HomePage instead of directly to VideoConferencePage
        return HomePage(
          prefilledSessionId: sessionId ?? "default_session",
        );
      }),
    );
  }
}