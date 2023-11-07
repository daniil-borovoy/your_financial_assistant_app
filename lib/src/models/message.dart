import 'package:isar/isar.dart';

part 'message.g.dart';

@collection
class ChatMessage {
  final Id? id = Isar.autoIncrement;

  final String userId;
  final String text;
  final DateTime sendTime;

  const ChatMessage({
    required this.text,
    required this.userId,
    required this.sendTime,
  });
}
