import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:chat_app/constats/colors.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> contacts;
  final List<String?> messages;
  ChatScreen({
    super.key,
    required this.contacts,
    required this.messages,
  });
  final List<SmsMessage> message = [];
  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // call the text editing controller
  final TextEditingController _textController = TextEditingController();

  final Telephony telephony = Telephony.instance;
  void _sendMessage(String value) async {
    print("Sending $value");
    await Telephony.instance.sendSms(
        to: widget.contacts['phone'][0]
            .toString()
            .replaceAll("(", "")
            .replaceAll(")", ""),
        message: value);
  }

  @override
  Widget build(BuildContext context) {
    print(
        "hello ${widget.contacts['phone'][0].toString().replaceAll("(", "").replaceAll(")", "")}");
    String name = widget.contacts['name'];
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
              onPressed: () async {},
              icon: const Icon(
                Icons.call,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
              )),
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
                        color: Color(0xFFE8E8EE),
                        tail: true,
                        isSender: true,
                      ),
                      SizedBox(
                        height: 100,
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
                    actions: [
                      InkWell(
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 24,
                        ),
                        onTap: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: InkWell(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.green,
                            size: 24,
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
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
              IconButton(onPressed: () {}, icon: const Icon(Icons.abc))
            ],
          )
        ],
      ),
    );
  }
}
