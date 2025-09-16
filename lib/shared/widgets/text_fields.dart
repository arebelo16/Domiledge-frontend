import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<String>? autofillHints;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final int maxLines;
  final bool dense;
  final bool floatingLabelAlways;
  final bool? filled;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.autofillHints,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputAction,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.dense = true,
    this.floatingLabelAlways = true,
    this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: obscureText ? 1 : maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: floatingLabelAlways
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.auto,
        border: const OutlineInputBorder(),
        isDense: dense,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled,
      ),
    );
  }
}
