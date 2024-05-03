import 'chatting_screen.dart';
import '../constats/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

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
            PopupMenuButton<String>(itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                // const PopupMenuItem<String>(
                //   value: 'Profile',
                //   child: ListTile(
                //     leading: Icon(Icons.person),
                //     title: Text('Profile'),
                //   ),
                // ),
                const PopupMenuItem<String>(
                  value: 'Settings',
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Settings'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Help & Support',
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Help & Support'),
                  ),
                ),
              ];
            }),
          ],
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
