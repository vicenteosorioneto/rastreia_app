import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userEmail;
  final String _verificationCode = '123456';
  DateTime? _lastCodeSentTime;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  DateTime? get lastCodeSentTime => _lastCodeSentTime;
  bool get isLoading => _isLoading;

  // Construtor que verifica se há um usuário salvo
  AuthProvider() {
    _checkSavedUser();
  }

  Future<void> _checkSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('user_email');
    _isAuthenticated = _userEmail != null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulação de login
      await Future.delayed(const Duration(seconds: 1));
      _userEmail = email;
      _isAuthenticated = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userEmail', email);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isAuthenticated = false;
      _userEmail = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userEmail = prefs.getString('userEmail');
    notifyListeners();
  }

  Future<bool> sendVerificationCode(String email) async {
    if (_lastCodeSentTime != null) {
      final difference = DateTime.now().difference(_lastCodeSentTime!);
      if (difference.inSeconds < 60) {
        return false;
      }
    }

    _lastCodeSentTime = DateTime.now();
    notifyListeners();
    return true;
  }

  bool verifyCode(String code) {
    return code == _verificationCode;
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulação de reset de senha
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> startRegistration(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userEmail = email;
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> completeRegistration() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _isAuthenticated = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', _userEmail!);
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> startPasswordReset(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userEmail = email;
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> completePasswordReset(String newPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool canResendCode() {
    if (_lastCodeSentTime == null) return true;
    final difference = DateTime.now().difference(_lastCodeSentTime!);
    return difference.inSeconds >= 60;
  }
}
