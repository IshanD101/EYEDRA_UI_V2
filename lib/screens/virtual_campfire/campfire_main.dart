import 'package:flutter/material.dart';

class CampfireMain extends StatefulWidget {
  const CampfireMain({super.key});

  State<CampfireMain> createState() => _CampfireState();
}

class _CampfireState extends State<CampfireMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Campfire'),
      ),
    );
  }
}
