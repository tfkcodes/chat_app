import '../widgets/chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_app/constats/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:chat_app/screens/chats_body_screen.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  List<Contact> contactsWithMessages = [];

  Future<void> getContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    // ignore: unused_local_variable
    for (var contact in contacts) {}
  }

  @override
  void initState() {
    super.initState();

    getContacts();

    syncMessagesAndContacts();
  }

  Future<void> syncMessagesAndContacts() async {
    PermissionStatus smsPermission = await Permission.sms.request();
    PermissionStatus contactPermission = await Permission.contacts.request();
    if (smsPermission.isGranted && contactPermission.isGranted) {
      final messages = await _query.querySms(kinds: [
        SmsQueryKind.inbox,
        SmsQueryKind.sent,
        // SmsQueryKind.draft,
      ], count: 200, sort: true);
      if (messages.isNotEmpty) {
        contactsWithMessages.add(Contact());
      }
      debugPrint('sms inbox messages: ${messages.length}');

      setState(() => _messages = messages);
    } else {
      await Permission.sms.request();
    }
  }

  Future<void> openPhonebookContacts() async {
    var permission = await Permission.sms.status;
    PermissionStatus contactStatus = await Permission.contacts.request();
    if (permission.isGranted || contactStatus.isGranted) {
      Iterable<Contact>? contacts = await ContactsService.getContacts();
      if (contacts.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Contact? selectedContact = await showDialog<Contact>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Select a contact'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = contacts.elementAt(index);
                  return ListTile(
                    title: Text(contact.displayName ?? ''),
                    onTap: () {
                      Navigator.pop(context, contact);
                    },
                  );
                },
              ),
            ),
          ),
        );

        if (selectedContact != null) {
          String phoneNumber = selectedContact.phones?.first.value ?? '';
        } else {}
      } else {}
    } else {
      await Permission.sms.request();
      await Permission.contacts.request();
    }
  }

  String selected = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IChip(
                    label: "All",
                    isSelected: selected == "All",
                    onTap: () {
                      setState(() {
                        selected = "All";
                      });
                    },
                  ),
                  IChip(
                    label: "Spam",
                    isSelected: selected == "Spam",
                    onTap: () {
                      setState(() {
                        selected = "Spam";
                      });
                    },
                  ),
                  IChip(
                      label: 'Promotions',
                      isSelected: selected == "Promotions",
                      onTap: () {
                        setState(() {
                          selected = "Promotions";
                        });
                      })
                ],
              ),
              _messages.isNotEmpty
                  ? _MessagesListView(
                      messages: _messages,
                    )
                  : Center(
                      child: Text(
                        'No messages to show.\n Tap refresh button...',
                        style: TextStyle(color: ColorPallet.primaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: openPhonebookContacts,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/svg/p.svg",
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessagesListView extends StatefulWidget {
  const _MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;

  @override
  State<_MessagesListView> createState() => _MessagesListViewState();
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
        };
        contactsWithMessages.add(contactWithMessages);
      }
    }
  }

  return contactsWithMessages;
}

class _MessagesListViewState extends State<_MessagesListView> {
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
