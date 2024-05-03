// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConstant {
  // static const String BASE_URL = "http://10.0.2.2:8080";
  // static const String BASE_URI = "10.0.2.2:8080";
  static const String BASE_URL = "http://192.168.177.251:8080";
  static const String BASE_URI = "192.168.177.251:8080";

  // Function to generate a URL with variable ID
  // static String getMessageListUrl(String id) {
  //   return '$MESSAGE_URL$id/';
  // }

  static String dateTime(originalDateString) {
    DateTime originalDate = DateTime.parse(originalDateString);
    const darEsSalaamOffset = Duration(hours: 3);
    final darEsSalaamDate = originalDate.add(darEsSalaamOffset);
    return DateFormat('MMM dd, yyyy hh:mm a').format(darEsSalaamDate);
  }

  static String date(originalDateString) {
    DateTime originalDate = DateTime.parse(originalDateString);
    const darEsSalaamOffset = Duration(hours: 3);
    final darEsSalaamDate = originalDate.add(darEsSalaamOffset);
    return DateFormat('MMM dd, yyyy').format(darEsSalaamDate);
  }

  // static Future<LoginUser?> getLoginUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? data = prefs.getString('userData');

  //   if (data != null) {
  //     return LoginUser.fromJson(jsonDecode(data));
  //   }
  //   return null;
  // }

  // static Future<Map<String, String>> getMainHeaders() async {
  //   late Map<String, String> mainHeaders;
  //   LoginUser? loginUser = await getLoginUser();

  //   mainHeaders = {
  //     'Authorization': 'Bearer ${loginUser!.access}',
  //   };
  //   return mainHeaders;
  // }

  static Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userData = prefs.getString('userData') ?? '';
    return jsonDecode(userData);
  }
}
