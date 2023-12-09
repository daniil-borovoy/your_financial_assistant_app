import 'package:isar/isar.dart';

part 'message.g.dart';

@collection
class ChatMessage {
  Id id = Isar.autoIncrement;

  late String userId;

  late String text;

  late DateTime sendTime;
}
