class TransactionSms {
  final String sender;
  final String body;
  final DateTime receivedAt;
  final bool processed;

  TransactionSms({
    required this.sender,
    required this.body,
    required this.receivedAt,
    this.processed = false,
  });
}
