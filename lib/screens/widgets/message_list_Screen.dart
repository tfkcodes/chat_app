import '../../constats/colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:chat_app/screens/chats_body_screen.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class MessagesListView extends StatefulWidget {
  const MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;

  @override
  State<MessagesListView> createState() => MessagesListViewState();
}

Future<List<Map<String, dynamic>>> getContactsWithMessages(
    List<SmsMessage> messages) async {
  List<Map<String, dynamic>> contactsWithMessages = [];

  for (var message in messages) {
    Iterable<Contact> contacts = await ContactsService.getContactsForPhone(
      message.address,
    );
    if (contacts.isNotEmpty) {
      Contact contact = contacts.first;

      bool contactExists = false;
      int contactIndex = 0;
      for (int i = 0; i < contactsWithMessages.length; i++) {
        if (contactsWithMessages[i]['name'] == contact.displayName) {
          contactExists = true;
          contactIndex += i;
          break;
        }
      }
      if (contactExists) {
        contactsWithMessages[contactIndex]['messages'].add(message.body);
      } else {
        Map<String, dynamic> contactWithMessages = {
          'name': contact.displayName ?? '',
          'messages': [message.body],
          'phone': [contact.phones!.map((e) => e.value)]
        };
        contactsWithMessages.add(contactWithMessages);
      }
    }
  }

  return contactsWithMessages;
}

class MessagesListViewState extends State<MessagesListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getContactsWithMessages(widget.messages),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> contactsWithMessages = snapshot.data!;
          return Column(
            children: [
              Divider(),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: contactsWithMessages.length,
                itemBuilder: (BuildContext context, index) {
                  String name = contactsWithMessages[index]['name'];
                  List<String?> messages =
                      contactsWithMessages[index]['messages'];

                  List<String> nameParts = name.split(' ');
                  String firstName = nameParts.first;

                  int hashCode = name.hashCode;
                  Color backgroundColor =
                      Color((hashCode & 0xFF0000FF) | 0xFF808080);
                  print("heeee ${contactsWithMessages[index]['phone']}");
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircleAvatar(
                          backgroundColor: backgroundColor,
                          child: Text(
                            firstName.substring(0, 2).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        messages.join('\n'),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              contacts: contactsWithMessages[index],
                              messages: contactsWithMessages[index]['messages'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong try again',
              style: TextStyle(color: ColorPallet.primaryColor),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return Center(
              child: SizedBox(
            height: 600,
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext conext, index) {
                  return const Skeletonizer(
                    child: ListTile(
                      title: Text("Message title"),
                      subtitle: Text("Message body max line 3"),
                      leading: CircleAvatar(),
                    ),
                  );
                }),
          ));
        }
      },
    );
  }
}
