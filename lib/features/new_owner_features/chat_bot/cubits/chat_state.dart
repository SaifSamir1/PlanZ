// lib/cubit/chat_state.dart
import 'package:equatable/equatable.dart';
import 'package:plan_z/features/new_owner_features/chat_bot/data/models/chat_models.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatWelcome extends ChatState {} // حالة جديدة للـ Welcome

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final List<String> messageHistory;
  final bool isTyping;
  final ChatQuestion? currentQuestion;

  const ChatLoaded({
    required this.messages,
    required this.messageHistory,
    this.isTyping = false,
    this.currentQuestion,
  });

  @override
  List<Object?> get props => [messages, messageHistory, isTyping, currentQuestion];

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    List<String>? messageHistory,
    bool? isTyping,
    ChatQuestion? currentQuestion,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      messageHistory: messageHistory ?? this.messageHistory,
      isTyping: isTyping ?? this.isTyping,
      currentQuestion: currentQuestion ?? this.currentQuestion,
    );
  }
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object> get props => [message];
}
