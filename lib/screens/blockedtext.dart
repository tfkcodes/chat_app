import 'package:chat_app/constats/colors.dart';
import 'package:flutter/material.dart';

class BlockedTextScreen extends StatefulWidget {
  const BlockedTextScreen({super.key});

  @override
  State<BlockedTextScreen> createState() => _BlockedTextScreenState();
}

class _BlockedTextScreenState extends State<BlockedTextScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPallet.whiteColor,
        title: Text(
          ' blocked text',
          style: TextStyle(color: ColorPallet.darkCOlor),
        ),
        iconTheme: IconThemeData(color: ColorPallet.darkCOlor),
      ),
      body: const Center(
        child: Text('Spam and blocked text'),
      ),
    );
  }
}
