import 'package:dio/dio.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';
import 'package:your_financial_assistant_app/src/models/message.dart';

abstract interface class ChatService {
  Future<List<String>> sendQuestion(
    types.TextMessage msg,
    String userId,
    String chatUserId,
  );

  Future<List<ChatMessage>> getChatMessages({int page = 1, int limit = 10});

  Future<List<ChatMessage>> getAllLastMessages();
}

const systemRoleChatSetup =
    """You are a helpful assistant in transactions analysis.""";

class ChatServiceImpl implements ChatService {
  final Dio _httpClient;
  final Isar _isar;

  ChatServiceImpl({required Isar isar, required Dio httpClient})
      : _isar = isar,
        _httpClient = httpClient;

  @override
  Future<List<String>> sendQuestion(
    types.TextMessage msg,
    String userId,
    String chatUserId,
  ) async {
    final previousMessages = (await getAllLastMessages())
        .map((e) => {
              "content": e.text,
              "role": e.userId == "82091008-a484-4a89-ae75-a22bf8d6f3ab"
                  ? "assistant"
                  : "user"
            })
        .toList();
    final request = await _httpClient.post(
      "${dotenv.env['API_BASE_URL']!}/v1/chat/completions",
      data: {
        "messages": [
          {
            "content": systemRoleChatSetup,
            "role": "system"
          },
          ...previousMessages,
          {"content": msg.text, "role": "user"}
        ]
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${dotenv.env['API_KEY']}",
        },
      ),
    );
    final userMessage = ChatMessage()
      ..text = msg.text
      ..userId = userId
      ..sendTime = DateTime.fromMillisecondsSinceEpoch(msg.createdAt!);

    await _isar.writeTxn(() => _isar.chatMessages.put(userMessage));
    final answers = (request.data["choices"] as List)
        .map((msg) => ChatMessage()
          ..text = msg["message"]["content"]
          ..userId = chatUserId
          ..sendTime = DateTime.now())
        .toList();

    await _isar.writeTxn(() async {
      for (final answer in answers) {
        await _isar.chatMessages.put(answer);
      }
    });

    return answers.map((e) => e.text).toList();
  }

  @override
  Future<List<ChatMessage>> getChatMessages({int page = 1, int limit = 10}) {
    return _isar.chatMessages
        .where()
        .sortBySendTimeDesc()
        .offset((page - 1) * limit)
        .limit(limit)
        .findAll();
  }

  @override
  Future<List<ChatMessage>> getAllLastMessages() {
    return _isar.chatMessages.where().sortBySendTime().findAll();
  }
}
