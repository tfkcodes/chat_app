import 'package:chat_app/constats/colors.dart';
import 'package:chat_app/screens/chats_body_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

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
    // Iterate over contacts
    // ignore: unused_local_variable
    for (var contact in contacts) {}
  }

  @override
  void initState() {
    super.initState();

    //get contacts list
    getContacts();

    // Sync messages and contacts when the app is opened/installed
    syncMessagesAndContacts();
  }

  Future<void> syncMessagesAndContacts() async {
    PermissionStatus smsPermission = await Permission.sms.request();
    PermissionStatus contactPermission = await Permission.contacts.request();
    if (smsPermission.isGranted && contactPermission.isGranted) {
      final messages = await _query.querySms(
        kinds: [
          SmsQueryKind.inbox,
          SmsQueryKind.sent,
          SmsQueryKind.draft,
        ],
      );
      if (messages.isNotEmpty) {
        contactsWithMessages.add(Contact());
      }
      debugPrint('sms inbox messages: ${messages.length}');

      setState(() => _messages = messages);
    } else {
      await Permission.sms.request();
    }
  }

// this function return to phonebook contacts once user click a open messa

  Future<void> openPhonebookContacts() async {
    var permission = await Permission.sms.status;
    PermissionStatus contactStatus = await Permission.contacts.request();
    if (permission.isGranted || contactStatus.isGranted) {
      Iterable<Contact>? contacts = await ContactsService.getContacts();
      if (contacts.isNotEmpty) {
        // Open phonebook contacts and display a contact picker
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
          // Handle selected contact and send a message
          String phoneNumber = selectedContact.phones?.first.value ?? '';
          // Implement your logic to send a message to the selected contact
        } else {
          // No contact selected
        }
      } else {
        // No contacts available
      }
    } else {
      await Permission.sms.request();
      await Permission.contacts.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: _messages.isNotEmpty
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openPhonebookContacts,
        child: const Icon(Icons.chat_bubble),
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

// get the contact with messages containing the contacts function

Future<List<Map<String, dynamic>>> getContactsWithMessages(
    List<SmsMessage> messages) async {
  List<Map<String, dynamic>> contactsWithMessages = [];

  for (var message in messages) {
    Iterable<Contact> contacts = await ContactsService.getContactsForPhone(
      message.address,
    );
    if (contacts.isNotEmpty) {
      Contact contact = contacts.first;

      // Check if the contact already exists in contactsWithMessages list
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
        // Append the message to the existing contact's messages list
        contactsWithMessages[contactIndex]['messages'].add(message.body);
      } else {
        // Create a new entry in contactsWithMessages list
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

// a list to display all messages inside the body
class _MessagesListViewState extends State<_MessagesListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getContactsWithMessages(widget.messages),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> contactsWithMessages = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: contactsWithMessages.length,
            itemBuilder: (BuildContext context, index) {
              String name = contactsWithMessages[index]['name'];
              List<String?> messages = contactsWithMessages[index]['messages'];

              // Extract first and last name
              List<String> nameParts = name.split(' ');
              String firstName = nameParts.first;

              // Generate background color based on name
              int hashCode = name.hashCode;
              Color backgroundColor =
                  Color((hashCode & 0xFF0000FF) | 0xFF808080);

              // Get the last message time

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      backgroundColor: backgroundColor,
                      child: Text(
                        firstName[0],
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
                    maxLines: 1,
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
                                currentUser: '',
                              )),
                    );
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');

          return Center(
            child: Text(
              'Something went wrong try again',
              style: TextStyle(color: ColorPallet.primaryColor),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
