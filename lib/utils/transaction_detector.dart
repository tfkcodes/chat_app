class TransactionDetector {
  static final List<RegExp> _transactionPatterns = [
    // MNOs
    RegExp(r'm-?pesa', caseSensitive: false),
    RegExp(r'mixx', caseSensitive: false),
    RegExp(r'airtel', caseSensitive: false),
    RegExp(r'halopesa', caseSensitive: false),

    // Banks
    RegExp(r'crdb', caseSensitive: false),
    RegExp(r'nmb', caseSensitive: false),
    RegExp(r'absa', caseSensitive: false),
    RegExp(r'stanbic', caseSensitive: false),
    RegExp(r'exim', caseSensitive: false),

    // Transaction keywords
    RegExp(r'tzs|tsh', caseSensitive: false),
    RegExp(r'salio|balance', caseSensitive: false),
    RegExp(r'ref|transaction id|muamala', caseSensitive: false),
  ];

  static bool isTransactional(String sender, String body) {
    final text = '$sender $body';
    return _transactionPatterns.any((r) => r.hasMatch(text));
  }
}
