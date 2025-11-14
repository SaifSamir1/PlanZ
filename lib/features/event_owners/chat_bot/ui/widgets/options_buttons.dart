// lib/widgets/options_buttons.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import '../../data/models/chat_models.dart';

class OptionsButtons extends StatelessWidget {
  final List<ChatOption> options;
  final Function(ChatOption) onOptionSelected;

  const OptionsButtons({
    super.key,
    required this.options,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 60, right: 16, top: 8, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;

            return FadeInUp(
              duration: Duration(milliseconds: 300 + (index * 100)),
              delay: Duration(milliseconds: index * 50),
              child: Container(
                margin: EdgeInsets.only(
                  bottom: index < options.length - 1 ? 8 : 0,
                ),
                child: _buildOptionButton(option,context),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildOptionButton(ChatOption option,BuildContext context) {
    final isBackButton =
        option.text.contains('🔙') || option.text.contains('العودة');
    final isMainAction =
        option.text.contains('✅') || option.text.contains('📞');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onOptionSelected(option);
          if (option.route != null && option.route!.isNotEmpty) {
    Navigator.pushNamed(context, option.route!);
  }
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: isBackButton
            ? AppColors.blue100
            : isMainAction
            ? AppColors.gold200
            : AppColors.blue100,
        highlightColor: isBackButton
            ? AppColors.blue50
            : isMainAction
            ? AppColors.gold100
            : AppColors.blue50,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: _getButtonColor(option),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _getBorderColor(option), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: _getShadowColor(option),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.text,
                  style: TextStyle(
                    color: _getTextColor(option),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _getButtonIcon(option),
                color: _getTextColor(option),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(ChatOption option) {
    if (option.text.contains('🔙') || option.text.contains('العودة')) {
      return AppColors.blue50;
    } else if (option.text.contains('✅') || option.text.contains('📞')) {
      return AppColors.gold50;
    } else {
      return AppColors.background;
    }
  }

  Color _getBorderColor(ChatOption option) {
    if (option.text.contains('🔙') || option.text.contains('العودة')) {
      return AppColors.blue200;
    } else if (option.text.contains('✅') || option.text.contains('📞')) {
      return AppColors.gold300;
    } else {
      return AppColors.blue100;
    }
  }

  Color _getShadowColor(ChatOption option) {
    if (option.text.contains('🔙') || option.text.contains('العودة')) {
      return AppColors.blue600.withOpacity(0.1);
    } else if (option.text.contains('✅') || option.text.contains('📞')) {
      return AppColors.primaryGold.withOpacity(0.2);
    } else {
      return AppColors.shadow;
    }
  }

  Color _getTextColor(ChatOption option) {
    if (option.text.contains('🔙') || option.text.contains('العودة')) {
      return AppColors.blue600;
    } else if (option.text.contains('✅') || option.text.contains('📞')) {
      return AppColors.gold700;
    } else {
      return AppColors.textPrimary;
    }
  }

  IconData _getButtonIcon(ChatOption option) {
    if (option.text.contains('🔙') || option.text.contains('العودة')) {
      return Icons.arrow_back_ios_rounded;
    } else if (option.text.contains('✅')) {
      return Icons.check_circle_outline_rounded;
    } else if (option.text.contains('📞')) {
      return Icons.phone_outlined;
    } else {
      return Icons.arrow_forward_ios_rounded;
    }
  }
}
