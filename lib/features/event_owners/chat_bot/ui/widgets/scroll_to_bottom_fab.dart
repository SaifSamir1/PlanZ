

// lib/features/event_owners/chat_bot/ui/widgets/scroll_to_bottom_fab.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class ScrollToBottomFAB extends StatelessWidget {
  final AnimationController animationController;
  final VoidCallback onPressed;

  const ScrollToBottomFAB({
    super.key,
    required this.animationController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: animationController.value,
          child: FloatingActionButton.small(
            onPressed: onPressed,
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
