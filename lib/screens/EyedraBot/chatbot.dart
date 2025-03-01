import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:model_viewer_plus/model_viewer_plus.dart';


class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {

  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  Future<void> sendMessage(String message) async {
    setState(() {
      messages.add({"role": "user", "content": message});
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/chat'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": message}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          messages.add({"role": "bot", "content": responseData["response"]});
        });
      } else {
        setState(() {
          messages.add({"role": "bot", "content": "Error: Unable to get response."});
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"role": "bot", "content": "Error: Unable to connect to server."});
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: Colors.black.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
        padding: const EdgeInsets.all(16),
    height: 500,
    child: Column(
    children: [

      SizedBox(
        height: 200,
        child: ModelViewer(
          src: 'assets/mascot/untitled.glb',
          autoRotate: true,
          cameraControls: true,
          backgroundColor: Colors.transparent,
        ),
      ),
      const Divider(color: Colors.white),
      Expanded(
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            return Align(
              alignment: msg["role"] == "user"
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: msg["role"] == "user"
                      ? Colors.blueAccent
                      : Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  msg["content"]!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),

    ]
    )
    )
    );
  }
}

