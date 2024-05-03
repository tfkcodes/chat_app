import 'package:chat_app/constats/colors.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPallet.whiteColor,
        title: Text(
          'Settings',
          style: TextStyle(color: ColorPallet.darkCOlor),
        ),
        iconTheme: IconThemeData(color: ColorPallet.darkCOlor),
      ),
      body: const Center(
        child: Text('Settings'),
      ),
    );
  }
}
