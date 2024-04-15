import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: Text("setting1")),
        Expanded(child: Text("setting2")),
        Expanded(child: Text("setting3")),
      ],
    );
  }
}