import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class PhonebookContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ContactList(),
    );
  }
}

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late Iterable<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  Future<void> getContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _contacts.isNotEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _contacts.length,
            itemBuilder: (context, index) {
              Contact contact = _contacts.elementAt(index);
              return ListTile(
                title: Text(contact.displayName ?? ''),
                subtitle: Text(contact.phones!.isNotEmpty
                    ? contact.phones!.first.value!
                    : 'No phone number'),
                onTap: () {},
              );
            },
          );
  }
}
