import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this import

// Local imports:
import '../../screens/virtual_campfire/mental_health_theme.dart'; // Updated import path
import '../../screens/virtual_campfire/video_session.dart';

class HomePage extends StatefulWidget {
  final String? prefilledSessionId;

  const HomePage({
    Key? key,
    this.prefilledSessionId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late TextEditingController conferenceIDController;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    // Use prefilled session ID if available
    conferenceIDController = TextEditingController(
        text: widget.prefilledSessionId ?? "mental_health_session"
    );
    nameController = TextEditingController();

    // Request camera and microphone permissions when page loads
    _requestPermissions();
  }

  // Request camera and microphone permissions
  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MentalHealthTheme.primaryPurple,
        foregroundColor: Colors.white,
        title: const Text("Peer Support"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MentalHealthTheme.lightPurple.withOpacity(0.7),
              MentalHealthTheme.primaryPurple,
              MentalHealthTheme.darkPurple,
            ],
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white.withOpacity(0.9),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.healing,
                    size: 64,
                    color: MentalHealthTheme.primaryPurple,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Peer Support Session",
                    style: TextStyle(
                      color: MentalHealthTheme.darkPurple,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Connect with others in a safe and supportive environment",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Your Name (Optional)",
                      prefixIcon: const Icon(Icons.person, color: MentalHealthTheme.primaryPurple),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: MentalHealthTheme.lightPurple),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: MentalHealthTheme.lightPurple),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: MentalHealthTheme.primaryPurple, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: conferenceIDController,
                    decoration: InputDecoration(
                      labelText: "Session ID",
                      prefixIcon: const Icon(Icons.group, color: MentalHealthTheme.primaryPurple),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: MentalHealthTheme.lightPurple),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: MentalHealthTheme.lightPurple),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: MentalHealthTheme.primaryPurple, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (conferenceIDController.text.trim().isNotEmpty) {
                          // Ensure permissions are granted before proceeding
                          final cameraStatus = await Permission.camera.status;
                          final micStatus = await Permission.microphone.status;

                          if (!cameraStatus.isGranted || !micStatus.isGranted) {
                            // Re-request permissions if not granted
                            await _requestPermissions();
                          }

                          // Navigate to video conference page
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return VideoConferencePage(
                                conferenceID: conferenceIDController.text.trim(),
                                userName: nameController.text.trim(),
                              );
                            }),
                          );
                        } else {
                          // Show error if session ID is empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter a session ID"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MentalHealthTheme.accentTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        "Join Session",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Generate a random session ID
                      final randomID = "session_${math.Random().nextInt(10000)}";
                      conferenceIDController.text = randomID;
                    },
                    child: const Text(
                      "Generate New Session ID",
                      style: TextStyle(
                        color: MentalHealthTheme.calmBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    conferenceIDController.dispose();
    nameController.dispose();
    super.dispose();
  }
}