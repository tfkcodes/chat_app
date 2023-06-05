import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';

import '../constats/colors.dart';
import '../widgets/appbarwidget.dart';
import 'chatting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          centerTitle: true,
          actions: [
            AnimSearchBar(
              width: 250,
              textController: textEditingController,
              onSuffixTap: () {
                setState(() {
                  textEditingController.clear();
                });
              },
              color: ColorPallet.whiteColor,
              animationDurationInMilli: 200,
              autoFocus: true,
              closeSearchOnSuffixTap: true,
              rtl: true,
              helpText: 'Search chats.....',
              style: TextStyle(color: ColorPallet.whiteColor),
              textFieldColor: ColorPallet.darkCOlor,
              boxShadow: false,
              onSubmitted: (p0) {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
          iconTheme: IconThemeData(color: ColorPallet.darkCOlor),
        ),
        drawer: const DrawerWidget(),
        body: const ChattingScreen());
  }
}
