import 'package:chat_app/parsers/tz_mno_profiles.dart';

import '../models/transaction_record.dart';
import 'tz_profiles.dart';

class TransactionParser {
  static TransactionRecord? parse({
    required String sender,
    required String body,
    required DateTime receivedAt,
  }) {
    for (final profile in tzMnoProfiles) {
      if (profile.senderPattern.hasMatch(sender) ||
          profile.senderPattern.hasMatch(body)) {
        return _parseWithProfile(
          profile,
          sender,
          body,
          receivedAt,
        );
      }
    }
    return null;
  }

  static TransactionRecord _parseWithProfile(
    TzProviderProfile profile,
    String sender,
    String body,
    DateTime receivedAt,
  ) {
    double? extract(RegExp r) {
      final match = r.firstMatch(body);
      if (match == null) return null;
      return double.tryParse(match.group(1)!.replaceAll(',', ''));
    }

    String? extractRef(RegExp r) {
      return r.firstMatch(body)?.group(1);
    }

    return TransactionRecord(
      sender: sender,
      provider: profile.name,
      type: profile.typeResolver(body),
      amount: extract(profile.amountPattern),
      balance: extract(profile.balancePattern),
      reference: extractRef(profile.referencePattern),
      receivedAt: receivedAt,
      rawMessage: body,
    );
  }
}
