import 'package:flutter/material.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../services/validators.dart';
import '../home/home_page.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController _authController = AuthController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _authController.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (_) => false,
      );
    }
  }

  Future<void> _onForgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _authController.errorMessage = 'Please enter your email first';
      });
      return;
    }

    await _authController.resetPassword(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.onSurface,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.surface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'LOG IN',
          style: TextStyle(
            color: colors.surface,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),

      body: SafeArea(
        child: AnimatedBuilder(
          animation: _authController,
          builder: (_, __) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _Label('Email'),
                            _RoundedField(
                              hint: 'user@gmail.com',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.emailValidator,
                            ),

                            const SizedBox(height: 24),

                            const _Label('Password'),
                            _RoundedField(
                              hint: 'password',
                              controller: _passwordController,
                              obscure: true,
                              validator: Validators.passwordValidator,
                            ),

                            const SizedBox(height: 12),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _authController.isLoading
                                    ? null
                                    : _onForgotPassword,
                                child: Text(
                                  'Forgot your password?',
                                  style: TextStyle(
                                    color: colors.onSurface.withValues(
                                      alpha: 0.7,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            //  Error message
                            if (_authController.errorMessage != null) ...[
                              Text(
                                _authController.errorMessage!,
                                style: TextStyle(
                                  color: colors.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            //  Success message
                            if (_authController.successMessage != null) ...[
                              Text(
                                _authController.successMessage!,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _authController.isLoading
                                    ? null
                                    : _onLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.onSurface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                child: Text(
                                  _authController.isLoading
                                      ? 'PLEASE WAIT...'
                                      : 'LOG IN',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colors.surface,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SignupPage(),
                                    ),
                                  );
                                },
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Don’t have an account? ",
                                      ),
                                      TextSpan(
                                        text: 'Sign up',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: colors.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(
                                    color: colors.onSurface.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/* ---------- UI Helpers ---------- */

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, color: colors.onSurface),
    );
  }
}

class _RoundedField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const _RoundedField({
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: colors.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.4)),
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
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
    );
  }
}
