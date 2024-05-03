import 'package:chat_app/constats/colors.dart';
import 'package:flutter/material.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPallet.whiteColor,
        title: Text(
          'Promotions  text',
          style: TextStyle(color: ColorPallet.darkCOlor),
        ),
        iconTheme: IconThemeData(color: ColorPallet.darkCOlor),
      ),
      body: const Center(
        child: Text('Promotions  text'),
      ),
    );
  }
}
