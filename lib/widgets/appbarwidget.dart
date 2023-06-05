import 'package:chat_app/screens/blockedtext.dart';
import 'package:chat_app/screens/feedback.dart';
import 'package:chat_app/screens/promotions.dart';
import 'package:chat_app/screens/settings.dart';
import 'package:chat_app/screens/spantextscreen.dart';
import 'package:flutter/material.dart';

import '../constats/colors.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: MediaQuery.of(context).size.width *
            0.75, // Adjust the value as needed
        elevation: 0,
        child: ListView(padding: EdgeInsets.zero, children: [
          Container(
            color: ColorPallet.whiteColor,
            child: UserAccountsDrawerHeader(
              accountName: const Text('Luciano',style:TextStyle(color:Colors.black),),
              accountEmail: const Text('lucianodev@gmail.com',style:TextStyle(color:Color(0xFF4E4E4E))),
              currentAccountPicture: const SizedBox(
                width: 72, // Adjust the size of the avatar
                height: 72, // Adjust the size of the avatar
          
                child: CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
              otherAccountsPictures: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Handle edit profile functionality
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Spam'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SpanTextScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Blocked'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BlockedTextScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_offer),
            title: const Text('Promotions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PromotionScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Feedback'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HelpFeedbackScreen()),
              );
            },
          ),
        ]));
  }
}
