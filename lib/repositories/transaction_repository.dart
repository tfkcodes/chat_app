import 'package:chat_app/config/error_map.dart';
import 'package:either_dart/either.dart';

import '../config/assets.dart';
import '../config/request.dart';

class TransactionRepository {
  Future<Either<String, ErrorMap>> sendTransaction(
      {required Map<String, dynamic> params, token = ""}) async {
    return await ApplicationBaseRequest.post(
      AppAssets.baseUrl,
      AppAssets.sendTransaction,
      params,
      token: token,
    ).request().then((response) {
      if (response.status ~/ 100 == 2) {
        bool status = response.data["status"];
        if (status && !response.data['data'].isEmpty) {
          return Left(response.data['sms']);
        } else {
          return Right(
            ErrorMap(
              status: response.status,
              message: response.data['sms'],
              body: response.body,
              errorMap: response.data,
            ),
          );
        }
      } else {
        return Right(
          ErrorMap(
            status: response.status,
            message: response.message,
            body: response.body,
            errorMap: response.data,
          ),
        );
      }
    });
  }
}
