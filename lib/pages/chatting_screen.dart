import 'package:chat_app/constats/colors.dart';
import 'package:chat_app/pages/widgets/message_list_Screen.dart';
import 'package:chat_app/providers/transaction_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../parsers/transaction_parser.dart';
import '../services/sms_background_service.dart';
import '../utils/transaction_detector.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({Key? key}) : super(key: key);

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  bool _newMessageIndicator = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initializeSmsListener();
    });
    _loadMessages();
  }

  Future<void> _initializeSmsListener() async {
    SmsBackgroundService.initialize();
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    SmsBackgroundService.stream.listen((data) async {
      await _loadMessages();
      final String sender = data['address'] ?? '';
      final String body = data['body'] ?? '';

      if (TransactionDetector.isTransactional(sender, body)) {
        final record = TransactionParser.parse(
          sender: sender,
          body: body,
          receivedAt: DateTime.now(),
        );

        if (record != null) {
          final txn = TransactionModel(
            sender: record.sender,
            body: record.rawMessage,
            date: record.receivedAt,
            amount: record.amount,
            balance: record.balance,
            reference: record.reference,
          );

          final box = Hive.box<TransactionModel>('transaction_queue');
          box.add(txn);

          final params = {
            "sender": record.sender,
            "body": record.rawMessage,
            "date": record.receivedAt,
            "amount": record.amount,
            "balance": record.balance,
            "reference": record.reference,
          };

          if (mounted) {
            setState(() {
              _messages.insert(
                0,
                SmsMessage.fromJson({
                  'address': sender,
                  'body': body,
                  'date': DateTime.now().millisecondsSinceEpoch, // always int!
                  'kind': SmsQueryKind.inbox.index,
                  'threadId': 0,
                }),
              );
              _newMessageIndicator = true;
            });
          }

          try {
            await provider.sendTransaction(params);
            print("Transaction sent successfully: $params");
          } catch (e) {
            print("Error sending transaction: $e");
          }

          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => _newMessageIndicator = false);
          });
        }
      }
    });
  }

  Future<void> _loadMessages() async {
    PermissionStatus smsPermission = await Permission.sms.request();

    if (smsPermission.isGranted) {
      final allMessages = await _query.querySms(
        kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
        count: 100,
        sort: true,
      );

      final transactionalMessages = allMessages.where((sms) {
        final body = sms.body ?? '';
        final sender = sms.address ?? '';
        return TransactionDetector.isTransactional(sender, body);
      }).map((sms) {
        return SmsMessage.fromJson({
          'address': sms.address ?? '',
          'body': sms.body ?? '',
          'date': sms.date?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch,
          'kind': sms.kind,
          'threadId': sms.threadId ?? 0,
        });
      }).toList();

      setState(() => _messages = transactionalMessages);
    }
  }

  @override
  Widget build(BuildContext context) {
    final txnProvider = context.watch<TransactionProvider>();

    return RefreshIndicator(
      onRefresh: _loadMessages,
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _messages.isNotEmpty
                  ? MessagesListView(messages: _messages)
                  : Center(
                      child: Text(
                        'No transactional messages.\nPull down to refresh...',
                        style: TextStyle(color: ColorPallet.primaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
            if (txnProvider.incomingMessageLoading)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: _incomingBanner(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _incomingBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.bell_fill, size: 16),
          SizedBox(width: 6),
          Text(
            "New transactional message received",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
