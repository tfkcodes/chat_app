import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/transaction_model.dart';
import '../parsers/transaction_parser.dart';
import '../providers/transaction_provider.dart';

class SmsBackgroundService {
  static const _channel = MethodChannel('sms_background_channel');

  static final StreamController<Map<String, dynamic>> _controller =
      StreamController.broadcast();

  static Stream<Map<String, dynamic>> get stream => _controller.stream;

  static void initialize({TransactionProvider? provider}) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onIncomingSms') {
        final data = Map<String, dynamic>.from(call.arguments);
        print("📩 Incoming SMS: $data");

        final tx = await TransactionQueue.add(data);

        if (provider != null) {
          final record = TransactionParser.parse(
            sender: tx.sender,
            body: tx.body,
            receivedAt: tx.date,
          );

          if (record != null) {
            final params = {
              "sender": tx.sender,
              "body": tx.body,
              "transaction_date": tx.date.toIso8601String(),
            };

            try {
              await provider.sendTransaction(params);
            } catch (e) {
              print("Error sending transaction from background: $e");
            }
          }
        }
        _controller.add(data);
      }
    });
  }
}

class TransactionQueue {
  /// Returns the TransactionModel after adding it to Hive
  static Future<TransactionModel> add(Map<String, dynamic> data) async {
    final box = Hive.box<TransactionModel>('transaction_queue');

    final tx = TransactionModel(
      sender: data['sender'],
      body: data['body'],
      date: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
    );

    await box.add(tx);

    return tx;
  }
}
