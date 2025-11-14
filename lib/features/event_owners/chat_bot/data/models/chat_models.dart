// lib/models/chat_models.dart
class ChatMessage {
  final String id;
  final String text;
  final bool isBot;
  final DateTime timestamp;
  final List<ChatOption>? options;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isBot,
    required this.timestamp,
    this.options,
  });
}

class ChatOption {
  final String id;
  final String text;
  final String nextQuestionId;
  final String? responseText;

  ChatOption({
    required this.id,
    required this.text,
    required this.nextQuestionId,
    this.responseText,
  });
}

class ChatQuestion {
  final String id;
  final String text;
  final List<ChatOption> options;
  final bool isStart;
  final bool isFinal;

  ChatQuestion({
    required this.id,
    required this.text,
    required this.options,
    this.isStart = false,
    this.isFinal = false,
  });
}
