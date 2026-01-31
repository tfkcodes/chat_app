import '../models/transaction_record.dart';
import 'tz_profiles.dart';

final List<TzProviderProfile> tzMnoProfiles = [
  // 🔵 M-PESA
  TzProviderProfile(
    name: 'M-PESA',
    senderPattern: RegExp(r'M-?PESA', caseSensitive: false),
    amountPattern: RegExp(r'TZS\s?([\d,]+\.?\d*)'),
    balancePattern: RegExp(r'Salio.*TZS\s?([\d,]+\.?\d*)'),
    referencePattern: RegExp(r'Ref[:\s]?([A-Z0-9]+)'),
    typeResolver: (body) {
      if (body.contains('Umetuma')) return TransactionType.outgoing;
      if (body.contains('Umetumiwa')) return TransactionType.incoming;
      return TransactionType.unknown;
    },
  ),

  TzProviderProfile(
    name: 'MIXX BY YAS',
    senderPattern: RegExp(
      r'MIXX|Tigo',
      caseSensitive: false,
    ),
    amountPattern: RegExp(
      r'(?:Umepokea|kiasi)[^\d]*([\d,]+\.?\d*)',
      caseSensitive: false,
    ),
    balancePattern: RegExp(
      r'Salio(?:\s+lako)?(?:\s+jipya)?[^\d]*([\d,]+\.?\d*)',
      caseSensitive: false,
    ),
    referencePattern: RegExp(
      r'kumbukumbu(?: ya malipo)?|Kumbukumbu No\.?:\s*([0-9]+)',
      caseSensitive: false,
    ),
    typeResolver: (body) {
      if (body.contains('Umepokea')) {
        return TransactionType.incoming;
      }
      if (body.contains('Umetuma pesa') ||
          body.contains('Wakala') ||
          body.contains('kiasi')) {
        return TransactionType.outgoing;
      }
      return TransactionType.unknown;
    },
  ),

  // 🔴 Airtel Money
  TzProviderProfile(
    name: 'AirtelMoney',
    senderPattern: RegExp(
      r'Airtel\s?Money|AirtelMoney',
      caseSensitive: false,
    ),
    amountPattern: RegExp(
      r'(?:Umetuma|Umepokea|Umelipa)[^\d]*([\d,]+\.?\d*)',
      caseSensitive: false,
    ),
    balancePattern: RegExp(
      r'Salio(?:\s+jipya)?[^\d]*([\d,]+\.?\d*)',
      caseSensitive: false,
    ),
    referencePattern: RegExp(
      r'(?:TID|Muamala No)[:\s]*([A-Z0-9.]+)',
      caseSensitive: false,
    ),
    typeResolver: (body) {
      if (body.contains('Umetuma') || body.contains('Umelipa')) {
        return TransactionType.outgoing;
      }
      if (body.contains('Umepokea')) {
        return TransactionType.incoming;
      }
      return TransactionType.unknown;
    },
  ),
];
