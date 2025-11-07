// lib/models/chat_models.dart
import 'package:flutter/animation.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isBot;
  final DateTime timestamp;
  final List<ChatOption>? options;
  final String? route;
  final VoidCallback? action;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isBot,
    required this.timestamp,
    this.action,
    this.options,
    this.route,
  });
}

class ChatOption {
  final String id;
  final String text;
  final String nextQuestionId;
  final String? responseText;
  final String? route;
  final VoidCallback? action; 

  ChatOption({
    required this.id,
    required this.text,
    required this.nextQuestionId,
    this.responseText,
    this.action,
    this.route
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
