import '../models/transaction_record.dart';

class TzProviderProfile {
  final String name;
  final RegExp senderPattern;
  final RegExp amountPattern;
  final RegExp balancePattern;
  final RegExp referencePattern;
  final TransactionType Function(String body) typeResolver;

  TzProviderProfile({
    required this.name,
    required this.senderPattern,
    required this.amountPattern,
    required this.balancePattern,
    required this.referencePattern,
    required this.typeResolver,
  });
}
