import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  //  LOGIN
  Future<bool> login(String email, String password) async {
    _startLoading();

    try {
      await _authService.login(email: email, password: password);
      _clearMessages();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _stopLoading();
    }
  }

  //  FORGOT PASSWORD
  Future<void> resetPassword(String email) async {
    _startLoading();

    try {
      await _authService.resetPassword(email: email);
      successMessage = 'Password reset link sent to your email';
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      successMessage = null;
    } finally {
      _stopLoading();
    }
  }

  void _startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void _clearMessages() {
    errorMessage = null;
    successMessage = null;
  }
}
