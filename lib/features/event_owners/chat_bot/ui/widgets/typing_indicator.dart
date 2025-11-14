// ignore_for_file: deprecated_member_use

// lib/widgets/typing_indicator.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 80, top: 8, bottom: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.blue50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.blue100, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'يكتب',
                    style: TextStyle(
                      color: AppColors.blue600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Row(
                        children: List.generate(3, (index) {
                          final delay = index * 0.2;
                          final opacity =
                              (0.4 +
                                      0.6 *
                                          (0.5 +
                                              0.5 *
                                                  math.sin(
                                                    (_animationController
                                                                .value *
                                                            2 *
                                                            math.pi) +
                                                        delay * 2 * math.pi,
                                                  )))
                                  .clamp(0.0, 1.0);

                          return Container(
                            margin: EdgeInsets.only(right: index < 2 ? 2 : 0),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.blue600.withOpacity(opacity),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
