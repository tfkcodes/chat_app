import 'package:chat_app/constats/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> contacts;
  final List<String?> messages;
  final String? currentUser;
  ChatScreen(
      {required this.contacts,
      required this.messages,
      required this.currentUser});
  final List<SmsMessage> message = [];
  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // call the text editing controller
  final TextEditingController _textController = TextEditingController();
  List<SmsMessage> message = [];

  void _sendMessage() {
    String messageText = _textController.text;
    if (messageText.isNotEmpty) {
      // Create a new message map
      Map<String, dynamic> newMessage = {
        'isSent': true,
        'text': messageText,
      };

      // Add the new message to the list
      setState(() {
        widget.messages.add(newMessage as String?);
      });

      // Clear the text field
      _textController.clear();
    }
  }

// implement the phonecall button with the phone number

  @override
  Widget build(BuildContext context) {
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
                  String? sender = widget.currentUser;
                  bool isSentMessage = sender == widget.currentUser;
                  return Align(
                   
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      margin:
                          const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                      decoration: BoxDecoration(
                        color: isSentMessage
                            ? ColorPallet.sentMessageColor
                            : ColorPallet.receivedMessageColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.face)),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message.....',
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () {},
                ),
                IconButton(
                    icon: const Icon(Icons.send), onPressed: _sendMessage),
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
