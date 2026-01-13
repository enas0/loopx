import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const AuthField({
    super.key,
    required this.hint,
    this.obscure = false,
    this.controller,
    this.validator,
  });

  Color _withAlpha(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: TextStyle(color: colors.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: _withAlpha(colors.onSurface, 0.4)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: colors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: colors.error),
        ),
      ),
    );
  }
}
