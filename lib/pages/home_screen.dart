import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constats/colors.dart';
import 'chatting_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPallet.whiteColor,
          elevation: 0,
          title: Text(
            'Messages',
            style: TextStyle(color: ColorPallet.darkCOlor),
          ),
          centerTitle: false,
          iconTheme: IconThemeData(color: ColorPallet.darkCOlor),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/svg/msg.svg",
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
        body: const ChattingScreen());
  }
}
