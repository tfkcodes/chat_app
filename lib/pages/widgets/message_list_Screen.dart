import 'package:flutter/widgets.dart';

import '../../constats/colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:chat_app/pages/chats_body_screen.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class MessagesListView extends StatefulWidget {
  const MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;

  @override
  State<MessagesListView> createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<MessagesListView> {
  late List<Map<String, dynamic>> _contactsWithMessages;

  @override
  void initState() {
    super.initState();
    _loadContactsWithMessages();
  }

  Future<void> _loadContactsWithMessages() async {
    try {
      _contactsWithMessages = await getContactsWithMessages(widget.messages);
      setState(() {});
    } catch (e) {
      // Handle error
      print('Error loading messages: $e');
    }
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

        var contactIndex = contactsWithMessages.indexWhere(
          (element) => element['name'] == contact.displayName,
        );

        if (contactIndex != -1) {
          contactsWithMessages[contactIndex]['messages'].add(message.body);
        } else {
          contactsWithMessages.add({
            'name': contact.displayName ?? '',
            'messages': [message.body],
            'phone': contact.phones?.map((e) => e.value).toList() ?? [],
          });
        }
      }
    }

    return contactsWithMessages;
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD:lib/screens/widgets/message_list_Screen.dart
    return _contactsWithMessages.isEmpty
        ? _buildLoadingSkeleton()
        : _buildMessagesList();
  }

  Widget _buildLoadingSkeleton() {
    return Center(
      child: SizedBox(
        height: 600,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, index) {
            return const Skeletonizer(
              child: ListTile(
                title: Text("Message title"),
                subtitle: Text("Message body max line 3"),
                leading: CircleAvatar(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return Column(
      children: [
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: _contactsWithMessages.length,
            itemBuilder: (BuildContext context, index) {
              return _buildMessageListItem(_contactsWithMessages[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageListItem(Map<String, dynamic> contact) {
    String name = contact['name'];
    List<String?> messages = contact['messages'];

    String firstName = name.split(' ').first;

    int hashCode = name.hashCode;
    Color backgroundColor = Color((hashCode & 0xFF0000FF) | 0xFF808080);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: backgroundColor,
          child: Text(
            firstName.substring(0, 2).toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          messages.join('\n'),
          style: const TextStyle(color: Colors.grey),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                contacts: contact,
                messages: messages,
=======
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getContactsWithMessages(widget.messages),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> contactsWithMessages = snapshot.data!;
          return Column(
            children: [
              const Divider(),
              Expanded(
                child: ListView.builder(
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
                                messages: contactsWithMessages[index]
                                    ['messages'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
>>>>>>> b8ba27b (remove login):lib/pages/widgets/message_list_Screen.dart
              ),
            ),
          );
        },
      ),
    );
  }
}
