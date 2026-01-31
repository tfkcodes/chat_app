import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String sender;

  @HiveField(1)
  String body;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  double? amount;

  @HiveField(4)
  double? balance;

  @HiveField(5)
  String? reference;

  TransactionModel({
    required this.sender,
    required this.body,
    required this.date,
    this.amount,
    this.balance,
    this.reference,
  });
  Map<String, dynamic> toRequestParams() {
    return {
      "sender": sender,
      "body": body,
      "date": date.toIso8601String(),
      "amount": amount ?? 0.0,
      "balance": balance ?? 0.0,
      "reference": reference ?? "",
    };
  }
}
