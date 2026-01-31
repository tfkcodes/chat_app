enum TransactionType {
  incoming,
  outgoing,
  balanceInquiry,
  unknown,
}

class TransactionRecord {
  final String sender;
  final String provider; // M-PESA, TigoPesa, CRDB, etc
  final TransactionType type;
  final double? amount;
  final double? balance;
  final String? reference;
  final DateTime receivedAt;
  final String rawMessage;

  TransactionRecord({
    required this.sender,
    required this.provider,
    required this.type,
    required this.receivedAt,
    required this.rawMessage,
    this.amount,
    this.balance,
    this.reference,
  });
}
