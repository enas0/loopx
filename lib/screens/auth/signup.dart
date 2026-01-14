import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home/entry_page.dart';
import 'login_page.dart';

import '../../widgets/auth/auth_label.dart';
import '../../widgets/auth/auth_field.dart';
import '../../widgets/auth/auth_button.dart';
import '../../services/validators.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /* ================= SIGN UP ================= */

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      final user = credential.user;
      if (user == null) throw Exception('User creation failed');

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': user.email,
        'track': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // تأكيد أن الدوكومنت صار جاهز
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      _goToEntry();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Authentication error';
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'Something went wrong';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goToEntry() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const EntryPage()),
      (_) => false,
    );
  }

  /* ================= UI ================= */

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
          'SIGN UP',
          style: TextStyle(
            color: colors.surface,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Personal Info'),

                  _fieldSpacing(),
                  const AuthLabel('First Name'),
                  _bigField(
                    controller: _firstNameController,
                    hint: 'First name',
                    validator: Validators.firstNameValidator,
                  ),

                  _fieldSpacing(),
                  const AuthLabel('Last Name'),
                  _bigField(
                    controller: _lastNameController,
                    hint: 'Last name',
                    validator: Validators.lastNameValidator,
                  ),

                  _sectionSpacing(),
                  _sectionTitle('Account'),

                  _fieldSpacing(),
                  const AuthLabel('Email'),
                  _bigField(
                    controller: _emailController,
                    hint: 'user@gmail.com',
                    validator: Validators.emailValidator,
                  ),

                  _fieldSpacing(),
                  const AuthLabel('Password'),
                  _bigField(
                    controller: _passwordController,
                    hint: '********',
                    obscure: true,
                    validator: Validators.passwordValidator,
                  ),

                  _fieldSpacing(),
                  const AuthLabel('Confirm Password'),
                  _bigField(
                    controller: _confirmPasswordController,
                    hint: '********',
                    obscure: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: colors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  AuthButton(
                    text: _isLoading ? 'PLEASE WAIT...' : 'CREATE ACCOUNT',
                    onPressed: _isLoading ? null : _signup,
                  ),

                  const SizedBox(height: 28),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Log in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        style: TextStyle(
                          color: colors.onSurface.withAlpha(180),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* ================= HELPERS ================= */

  Widget _bigField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      height: 58, // 🔥 حجم أوضح
      child: AuthField(
        controller: controller,
        hint: hint,
        obscure: obscure,
        validator: validator,
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _fieldSpacing() => const SizedBox(height: 16);
  Widget _sectionSpacing() => const SizedBox(height: 32);
}
