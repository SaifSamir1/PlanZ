// lib/screens/chat_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/new_owner_features/chat_bot/cubits/chat_cubit.dart';
import 'package:plan_z/features/new_owner_features/chat_bot/cubits/chat_state.dart';
import 'package:plan_z/features/new_owner_features/chat_bot/ui/widgets/message_bubble.dart';
import 'package:plan_z/features/new_owner_features/chat_bot/ui/widgets/options_buttons.dart';
import 'package:plan_z/features/new_owner_features/chat_bot/ui/widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fabAnimationController;
  bool _showScrollToBottom = false;
  bool _shouldAutoScroll = true; // إضافة هذا المتغير المهم

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scrollController.addListener(_scrollListener);
  }

  // تحديث الـ scroll listener
  void _scrollListener() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.position.pixels;
      final maxPosition = _scrollController.position.maxScrollExtent;
      final isNearBottom = maxPosition - currentPosition <= 150;
      
      // تحديث حالة الـ auto scroll بناءً على موقع المستخدم
      _shouldAutoScroll = isNearBottom;
      
      if (!isNearBottom && !_showScrollToBottom) {
        setState(() => _showScrollToBottom = true);
        _fabAnimationController.forward();
      } else if (isNearBottom && _showScrollToBottom) {
        setState(() => _showScrollToBottom = false);
        _fabAnimationController.reverse();
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }



  @override
  void dispose() {
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
       
        title: 'مساعد PlanZ',
        actions: [
          
      BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoaded && state.messageHistory.length > 1) {
            return IconButton(
              onPressed: () => context.read<ChatCubit>().goBack(),
              icon: const Icon(Icons.undo_rounded),
              color: AppColors.blue600,
              tooltip: 'تراجع',
            );
          }
          return const SizedBox.shrink();
        },
      ),
      PopupMenuButton<String>(
        icon: Icon(Icons.more_vert_rounded, color: Colors.white),
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'restart',
            child: Row(
              children: [
                Icon(Icons.refresh_rounded, color: AppColors.blue600, size: 20),
                const SizedBox(width: 12),
                const Text(
                  'بداية جديدة', 
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  )
                ),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'restart') {
            context.read<ChatCubit>().resetChat();
          }
        },
      ),
    
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatWelcome) {
            return _buildWelcomeState();
          } else if (state is ChatLoading) {
            return _buildLoadingState();
          } else if (state is ChatLoaded) {
            return _buildChatContent(state);
          } else if (state is ChatError) {
            return _buildErrorState(state.message);
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: _buildScrollToBottomFAB(),
    );
  }

Widget _buildWelcomeState() {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 
                  (MediaQuery.of(context).padding.top + kToolbarHeight),
      ),
      child: FadeIn(
        duration: const Duration(milliseconds: 800),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // مساحة أعلى مرنة
              const SizedBox(height: 20),
              
              // Logo المساعد 
              SlideInDown(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.blue400, AppColors.blue600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue600.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // العنوان
              SlideInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 600),
                child: Text(
                  'مرحباً بك في مساعد PlanZ! 👋',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // الوصف
              SlideInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 600),
                child: Text(
                  'سأساعدك في العثور على كل ما تحتاجه حول الأحداث والفعاليات.\nاضغط على البدء للمتابعة! ✨',
                  style: TextStyle(
                    color: AppColors.blue400,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // زر البدء
              SlideInUp(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 600),
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryGold, AppColors.gold600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGold.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.read<ChatCubit>().startChat(),
                      borderRadius: BorderRadius.circular(27),
                      splashColor: Colors.white.withOpacity(0.2),
                      highlightColor: Colors.white.withOpacity(0.1),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.rocket_launch_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'البدء الآن',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
              
              // معلومات إضافية
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 600),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.blue50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.blue100, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.blue100,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.blue600,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'متاح في اي وقت للإجابة على جميع استفساراتك',
                          style: TextStyle(
                            color: AppColors.blue600,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // مساحة أسفل مرنة
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildLoadingState() {
    return Center(
      child: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.blue500, AppColors.blue600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(45),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue600.withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'جاري تحضير المحادثة...',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'سأكون معك خلال ثوانٍ',
              style: TextStyle(
                color: AppColors.blue400,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
                strokeWidth: 4,
                backgroundColor: AppColors.gold100,
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildChatContent(ChatLoaded state) {
  // هنا الحل الذكي - بس auto-scroll لو المستخدم قريب من الأسفل
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients && 
        state.messages.isNotEmpty && 
        _shouldAutoScroll) {
      // delay صغير عشان نتأكد إن الـ widget اترسم
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollToBottom();
        }
      });
    }
  });

  return Column(
    children: [
      Expanded(
        child: ListView.builder(
          controller: _scrollController,
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
    SizedBox(height: 80),
    ],
  );
}


  Widget _buildErrorState(String message) {
    return Center(
      child: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(color: AppColors.error.withOpacity(0.2), width: 2),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 40,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'حدث خطأ غير متوقع',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  color: AppColors.blue400,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryGold, AppColors.gold600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGold.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.read<ChatCubit>().resetChat(),
                    borderRadius: BorderRadius.circular(26),
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollToBottomFAB() {
    return AnimatedBuilder(
      animation: _fabAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabAnimationController.value,
          child: FloatingActionButton.small(
            onPressed: _scrollToBottom,
            backgroundColor: AppColors.primaryGold,
            foregroundColor: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.keyboard_arrow_down_rounded, size: 22),
          ),
        );
      },
    );
  }
}
