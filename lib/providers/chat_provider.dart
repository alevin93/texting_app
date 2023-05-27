import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';

class ChatProvider with ChangeNotifier {
  Map<String, List<ChatMessage>> _chats = {
    'Local Chat': [ChatMessage(id: '1', content: 'This is where local chats will appear', timestamp: DateTime.now(), isSent: true)]
  };

  Map<String, List<ChatMessage>> get chats {
    return {..._chats};
  }

  void addMessage(String chatId, String content, bool isSent) {
    if (_chats.containsKey(chatId)) {
      _chats[chatId]!.add(ChatMessage(
        id: DateTime.now().toString(),
        content: content,
        timestamp: DateTime.now(),
        isSent: isSent,
      ));
    } else {
      _chats[chatId] = [
        ChatMessage(
          id: DateTime.now().toString(),
          content: content,
          timestamp: DateTime.now(),
          isSent: isSent,
        )
      ];
    }

    notifyListeners();
  }
}