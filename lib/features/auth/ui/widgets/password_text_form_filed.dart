import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_text_form.dart';

class AppPasswordTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;

  const AppPasswordTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.errorText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autovalidateMode,
  });

  @override
  State<AppPasswordTextField> createState() => _AppPasswordTextFieldState();
}

class _AppPasswordTextFieldState extends State<AppPasswordTextField>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  late AnimationController _iconAnimationController;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });

    if (_obscureText) {
      _iconAnimationController.reverse();
    } else {
      _iconAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hintText: widget.hintText ?? 'auth.password'.tr(),
      labelText: widget.labelText,
      errorText: widget.errorText,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      prefixIcon: Icon(
        Icons.lock_outline_rounded,
        color: AppColors.blue400,
        size: 22,
      ),
      suffixIcon: AnimatedBuilder(
        animation: _iconRotation,
        builder: (context, child) {
          return IconButton(
            icon: RotationTransition(
              turns: _iconRotation,
              child: Icon(
                _obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.blue400,
                size: 22,
              ),
            ),
            onPressed: _togglePasswordVisibility,
            splashRadius: 20,
            tooltip: _obscureText
                ? 'auth.show_password'.tr()
                : 'auth.hide_password'.tr(),
          );
        },
      ),
    );
  }
}
