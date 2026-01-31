import 'package:chat_app/constats/colors.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  final String? contact;
  final List<String?> messages;
  ChatScreen({
    super.key,
    required this.contact,
    required this.messages,
  });
  final List<SmsMessage> message = [];
  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _sendMessage(String message) async {
    String _result = await sendSMS(
      sendDirect: true,
      message: message,
      recipients: [
        widget.contact.toString().replaceAll("(", "").replaceAll(")", "")
      ],
    ).catchError((onError) {
      print(onError);
    });

    print(_result);
  }

  void _launchPhoneCall() async {
    String phoneNumber =
        widget.contact.toString().replaceAll("(", "").replaceAll(")", "");
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.contact.toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPallet.whiteColor,
        elevation: 0,
        title: Text(
          name,
          style: TextStyle(color: ColorPallet.darkCOlor, fontSize: 18),
          overflow: TextOverflow.clip,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                _launchPhoneCall();
              },
              icon: const Icon(
                Icons.call,
              )),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: ColorPallet.darkCOlor,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 9),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  String message = widget.messages[index]!;
                  return Column(
                    children: [
                      BubbleSpecialThree(
                        text: message,
                        color: const Color(0xFFE8E8EE),
                        tail: true,
                        isSender: true,
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Row(
              children: [
                Expanded(
                  child: MessageBar(
                    onSend: (value) {
                      _sendMessage(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class morePopUpMenuWidget extends StatelessWidget {
  const morePopUpMenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.abc,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
