import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    this.onSubmit,
    this.validator,
    this.autovalidateMode,
    this.obscureText = false,
    this.style,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.labelText,
  });
  final TextEditingController controller;
  final Function(String)? onSubmit;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final bool obscureText;
  final TextStyle? style;
  // final String? obscuringCharacter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmit,
      autovalidateMode: autovalidateMode,
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: '*',
      style: style,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        border: const OutlineInputBorder(
          gapPadding: 0,
        ),
      ),
    );
  }
}
