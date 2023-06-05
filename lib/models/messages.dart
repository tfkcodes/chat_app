import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class ChatScreen extends HiveObject {
  @HiveField(0)
  final List<Map<String, dynamic>> contacts;

  @HiveField(1)
  final List<String> messages;

  ChatScreen({required this.contacts, required this.messages});
}












