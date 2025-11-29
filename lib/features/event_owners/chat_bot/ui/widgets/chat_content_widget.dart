

// lib/features/event_owners/chat_bot/ui/widgets/chat_content_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/event_owners/chat_bot/cubits/chat_cubit.dart';
import 'package:plan_z/features/event_owners/chat_bot/cubits/chat_state.dart';
import 'package:plan_z/features/event_owners/chat_bot/ui/widgets/message_bubble.dart';
import 'package:plan_z/features/event_owners/chat_bot/ui/widgets/options_buttons.dart';
import 'package:plan_z/features/event_owners/chat_bot/ui/widgets/typing_indicator.dart';

class ChatContentWidget extends StatelessWidget {
  final ChatLoaded state;
  final ScrollController scrollController;
  final bool shouldAutoScroll;
  final VoidCallback scrollToBottom;

  const ChatContentWidget({
    super.key,
    required this.state,
    required this.scrollController,
    required this.shouldAutoScroll,
    required this.scrollToBottom,
  });

  @override
  Widget build(BuildContext context) {
    // الـ auto-scroll الذكي - بس لو المستخدم قريب من الأسفل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients &&
          state.messages.isNotEmpty &&
          shouldAutoScroll) {
        // delay صغير عشان نتأكد إن الـ widget اترسم
        Future.delayed(const Duration(milliseconds: 100), () {
          if (scrollController.hasClients) {
            scrollToBottom();
          }
        });
      }
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: state.messages.length +
                (state.isTyping ? 1 : 0) +
                (state.currentQuestion?.options.isNotEmpty == true && !state.isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < state.messages.length) {
                return MessageBubble(message: state.messages[index]);
              } else if (state.isTyping && index == state.messages.length) {
                return const TypingIndicator();
              } else if (state.currentQuestion?.options.isNotEmpty == true && !state.isTyping) {
                return OptionsButtons(
                  options: state.currentQuestion!.options,
                  onOptionSelected: (option) {
                    context.read<ChatCubit>().selectOption(option, state.currentQuestion!);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
