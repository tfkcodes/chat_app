import 'package:chat_app/constats/colors.dart';
import 'package:flutter/material.dart';

class HelpFeedbackScreen extends StatefulWidget {
  const HelpFeedbackScreen({super.key});

  @override
  State<HelpFeedbackScreen> createState() => _HelpFeedbackScreenState();
}

class _HelpFeedbackScreenState extends State<HelpFeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPallet.whiteColor,
        title: Text(
          'Help and feedback',
          style: TextStyle(color: ColorPallet.darkCOlor),
        ),
        iconTheme: IconThemeData(color: ColorPallet.darkCOlor),
      ),
      body: const Center(
        child: Text('Help and feedback'),
      ),
    );
  }
}
