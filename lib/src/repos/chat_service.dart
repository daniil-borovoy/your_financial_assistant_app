import 'package:dio/dio.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';
import 'package:your_financial_assistant_app/src/models/message.dart';

class ChatService {
  final dio = Dio();
  late final Isar _isar;

  ChatService(this._isar);

  Future<String> sendQuestion(
    types.TextMessage msg,
    String userId,
    String chatUserId,
  ) async {
    final request = await dio.post(
      dotenv.env['API_BASE_URL']!,
      data: {"prompt": msg.text},
      options: Options(
        headers: {
          "Authorization": "Bearer ${dotenv.env['API_KEY']}",
        },
      ),
    );
    final userMessage = ChatMessage(
      text: msg.text,
      userId: userId,
      sendTime: DateTime.fromMillisecondsSinceEpoch(msg.createdAt!),
    );
    await _isar.writeTxn(() => _isar.chatMessages.put(userMessage));
    final chatMessage = ChatMessage(
        text: request.data, userId: chatUserId, sendTime: DateTime.now());
    await _isar.writeTxn(() => _isar.chatMessages.put(chatMessage));
    return request.data;
  }

  // TODO: pagination
  Future<List<ChatMessage>> getAllChatMessage() {
    return _isar.chatMessages.where().sortBySendTimeDesc().findAll();
  }
}
