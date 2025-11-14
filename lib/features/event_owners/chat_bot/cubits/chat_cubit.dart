// lib/cubit/chat_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/event_owners/chat_bot/data/models/chat_models.dart';
import 'package:plan_z/features/event_owners/chat_bot/data/models/dummy_data.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatWelcome()); // بدء بحالة الترحيب

  Timer? _typingTimer;
  static const Duration typingDuration = Duration(seconds: 2);

  void showWelcome() {
    emit(ChatWelcome());
  }

  void startChat() {
    emit(ChatLoading());
    
    final startQuestion = DummyData.getStartQuestion();
    final welcomeMessage = ChatMessage(
      id: '0',
      text: startQuestion.text,
      isBot: true,
      timestamp: DateTime.now(),
      options: startQuestion.options,
    );

    emit(ChatLoaded(
      messages: [welcomeMessage],
      messageHistory: ['start'],
      currentQuestion: startQuestion,
    ));
  }

  void selectOption(ChatOption option, ChatQuestion currentQuestion) {
    final currentState = state as ChatLoaded;
    
    // إضافة رسالة المستخدم
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: option.text,
      isBot: false,
      timestamp: DateTime.now(),
    );

    final updatedMessages = List<ChatMessage>.from(currentState.messages)
      ..add(userMessage);

    // إظهار typing indicator
    emit(currentState.copyWith(
      messages: updatedMessages,
      isTyping: true,
    ));

    // محاكاة وقت الكتابة
    _typingTimer?.cancel();
    _typingTimer = Timer(typingDuration, () {
      _addBotResponse(option, currentState.messageHistory);
    });
  }

  void _addBotResponse(ChatOption option, List<String> history) {
    final currentState = state as ChatLoaded;
    
    // إيجاد السؤال التالي
    final nextQuestion = DummyData.getQuestion(option.nextQuestionId);
    
    if (nextQuestion != null) {
      String responseText = option.responseText ?? nextQuestion.text;
      
      final botMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: responseText,
        isBot: true,
        timestamp: DateTime.now(),
        options: nextQuestion.options,
      );

      final updatedMessages = List<ChatMessage>.from(currentState.messages)
        ..add(botMessage);

      final updatedHistory = List<String>.from(history)
        ..add(option.nextQuestionId);

      emit(ChatLoaded(
        messages: updatedMessages,
        messageHistory: updatedHistory,
        isTyping: false,
        currentQuestion: nextQuestion,
      ));
    } else {
      // إذا لم يتم العثور على السؤال التالي
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: '🔧 عذراً، لم يتم إعداد رد محدد لهذا السؤال بعد.\nنحن نعمل على تحسين التطبيق باستمرار! 🚧\n\nيرجى اختيار خيار آخر أو العودة للقائمة الرئيسية.',
        isBot: true,
        timestamp: DateTime.now(),
        options: [
          ChatOption(
            id: 'back_main',
            text: '🔙 العودة للقائمة الرئيسية',
            nextQuestionId: 'start',
            responseText: 'بالطبع! كيف يمكنني مساعدتك؟',
          ),
        ],
      );

      final updatedMessages = List<ChatMessage>.from(currentState.messages)
        ..add(errorMessage);

      emit(ChatLoaded(
        messages: updatedMessages,
        messageHistory: currentState.messageHistory,
        isTyping: false,
        currentQuestion: ChatQuestion(
          id: 'error_fallback',
          text: errorMessage.text,
          options: errorMessage.options ?? [],
        ),
      ));
    }
  }

  void goBack() {
    final currentState = state as ChatLoaded;
    
    if (currentState.messageHistory.length <= 1) return;

    final newHistory = List<String>.from(currentState.messageHistory)
      ..removeLast();

    final previousQuestionId = newHistory.last;
    final previousQuestion = DummyData.getQuestion(previousQuestionId);

    if (previousQuestion != null) {
      final updatedMessages = List<ChatMessage>.from(currentState.messages);
      if (updatedMessages.length >= 2) {
        updatedMessages.removeLast(); // رد البوت
        updatedMessages.removeLast(); // رد المستخدم
      }

      emit(ChatLoaded(
        messages: updatedMessages,
        messageHistory: newHistory,
        currentQuestion: previousQuestion,
      ));
    }
  }

  void resetChat() {
    _typingTimer?.cancel();
    emit(ChatWelcome()); // العودة لشاشة الترحيب
  }

  @override
  Future<void> close() {
    _typingTimer?.cancel();
    return super.close();
  }
}
