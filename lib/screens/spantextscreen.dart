import 'package:chat_app/constats/colors.dart';
import 'package:flutter/material.dart';

class SpanTextScreen extends StatefulWidget {
  const SpanTextScreen({super.key});

  @override
  State<SpanTextScreen> createState() => _SpanTextScreenState();
}

class _SpanTextScreenState extends State<SpanTextScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPallet.whiteColor,
        title: Text(
          'Spam  text',
          style: TextStyle(color: ColorPallet.darkCOlor),
        ),
        iconTheme: IconThemeData(color: ColorPallet.darkCOlor),
      ),
      body: const Center(
        child: Text('Spam  text'),
      ),
    );
  }
}
