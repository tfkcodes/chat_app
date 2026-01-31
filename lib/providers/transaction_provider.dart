import 'package:flutter/cupertino.dart';

import '../repositories/transaction_repository.dart';
import '../services/sms_background_service.dart';

class TransactionProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _incomingMessageLoading = false;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _errorSms = "";
  String get errorSms => _errorSms;
  bool get incomingMessageLoading => _incomingMessageLoading;

  void setIncomingMessage(bool value) {
    _incomingMessageLoading = value;
    notifyListeners();
  }

  void listenToSmsStream() {
    SmsBackgroundService.stream.listen((data) {
      setIncomingMessage(true);

      Future.delayed(const Duration(seconds: 2), () {
        setIncomingMessage(false);
      });
    });
  }

  Future<void> sendTransaction(Map<String, dynamic> params) async {
    _isLoading = true;
    print("Params ${params}");
    notifyListeners();
    TransactionRepository().sendTransaction(params: params).then((value) {
      if (value.isLeft) {
        _errorSms = value.left;
        _isLoading = false;
        _hasError = false;
        print("Sucess sms ${_errorSms}");
        notifyListeners();
      } else {
        _isLoading = false;
        _hasError = true;
        _errorSms = value.right.message ?? "Unkown Error";
        print("Error sms ${_errorSms}");
        notifyListeners();
      }
    });
  }
}
