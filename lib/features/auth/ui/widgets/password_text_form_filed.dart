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
  // ignore: library_private_types_in_public_api
  _AppPasswordTextFieldState createState() => _AppPasswordTextFieldState();
}

class _AppPasswordTextFieldState extends State<AppPasswordTextField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hintText: widget.hintText ?? 'كلمة المرور',
      labelText: widget.labelText ?? 'كلمة المرور',
      errorText: widget.errorText,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: AppColors.textHint,
        ),
        onPressed: _togglePasswordVisibility,
      ),
    );
  }
}
