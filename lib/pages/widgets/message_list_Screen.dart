import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

import '../chats_body_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.messages.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final sms = widget.messages[index];
        final sender = sms.address ?? 'Unknown';
        final body = sms.body ?? '';

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Text(
              sender.substring(0, 1).toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            sender,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            _formatDate(sms.date),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  contact: sender,
                  messages: [body],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
