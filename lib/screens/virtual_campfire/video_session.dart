import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

// Local imports:
import '../../screens/virtual_campfire/mental_health_theme.dart';

/// Note that the userID needs to be globally unique,
final String localUserID = math.Random().nextInt(10000).toString();

class VideoConferencePage extends StatelessWidget {
  final String conferenceID;
  final String userName;

  const VideoConferencePage({
    Key? key,
    required this.conferenceID,
    this.userName = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Custom display name that appears more friendly
    final displayName = userName.isEmpty ? "Peer_$localUserID" : userName;

    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: 772653556, // Replace with your actual appID
        appSign: "ff31aa9da2219176ca86650e47df1f572040b88be0185b1ce596f8ab4519f5da", // Replace with your actual appSign
        userID: localUserID,
        userName: displayName,
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig()
        // Customize top menu bar
          ..topMenuBarConfig = ZegoTopMenuBarConfig(
            style: ZegoMenuBarStyle.light,
          )

        // Customize bottom menu bar
          ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
            style: ZegoMenuBarStyle.light,
            hideAutomatically: true,
            hideByClick: true,
          )

        // Customize member list
          ..memberListConfig = ZegoMemberListConfig(
            showMicrophoneState: true,
            showCameraState: true,
          )

        // Customize audio video view
          ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
            useVideoViewAspectFill: true,
            showAvatarInAudioMode: true,
            showSoundWavesInAudioMode: true,
          )

        // Set layout mode to focus on speaker for better peer conversations
          ..layout = ZegoLayout.pictureInPicture(
            isSmallViewDraggable: true,
            switchLargeOrSmallViewByClick: true,
          )

        // Show call leaving confirmation dialog
          ..onLeaveConfirmation = (BuildContext context) async {
            return await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: MentalHealthTheme.lightPurple,
                  title: const Text(
                    "Leave the session?",
                    style: TextStyle(
                      color: MentalHealthTheme.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    "Are you sure you want to leave this peer support session?",
                    style: TextStyle(color: MentalHealthTheme.textDark),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        "Stay",
                        style: TextStyle(color: MentalHealthTheme.accentTeal),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        "Leave",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                );
              },
            );
          },
      ),
    );
  }
}