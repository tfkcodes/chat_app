import '../widgets/chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_app/constats/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:chat_app/screens/chats_body_screen.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chat_app/screens/widgets/message_list_Screen.dart';

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
                  SizedBox(
                    width: 10,
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
                ],
              ),
              if (selected == "All")
                _messages.isNotEmpty
                    ? MessagesListView(
                        messages: _messages,
                      )
                    : Center(
                        child: Text(
                          'No messages to show.\n Tap refresh button...',
                          style: TextStyle(color: ColorPallet.primaryColor),
                          textAlign: TextAlign.center,
                        ),
                      )
              else if (selected == "Spam")
                const Center(
                  child: Text("Spam text"),
                )
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
