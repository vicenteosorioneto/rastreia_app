import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_type.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userEmail;
  String? _userName;
  UserType? _userType;
  final String _verificationCode = '123456';
  DateTime? _lastCodeSentTime;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  UserType? get userType => _userType;
  DateTime? get lastCodeSentTime => _lastCodeSentTime;
  bool get isLoading => _isLoading;

  // Construtor que verifica se há um usuário salvo
  AuthProvider() {
    _checkSavedUser();
  }

  Future<void> _checkSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('user_email');
    _userName = prefs.getString('user_name');
    final userTypeString = prefs.getString('user_type');
    if (userTypeString != null) {
      _userType = UserType.values.firstWhere(
        (type) => type.toString() == userTypeString,
      );
    }
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

      // TODO: Buscar dados do usuário do backend
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('user_email', email);

      // Recuperar tipo de usuário salvo
      final userTypeString = prefs.getString('user_type');
      if (userTypeString != null) {
        _userType = UserType.values.firstWhere(
          (type) => type.toString() == userTypeString,
        );
      }

      // Recuperar nome do usuário
      _userName = prefs.getString('user_name');
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
      _userName = null;
      _userType = null;
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

  Future<bool> startRegistration(
    String email,
    String password, {
    required String name,
    required String cpf,
    required UserType userType,
    String? matricula,
    String? unidade,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userEmail = email;
      _userName = name;
      _userType = userType;

      // Salvar dados temporariamente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('temp_email', email);
      await prefs.setString('temp_name', name);
      await prefs.setString('temp_cpf', cpf);
      await prefs.setString('temp_user_type', userType.toString());
      if (matricula != null) {
        await prefs.setString('temp_matricula', matricula);
      }
      if (unidade != null) {
        await prefs.setString('temp_unidade', unidade);
      }

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

      final prefs = await SharedPreferences.getInstance();

      // Mover dados temporários para permanentes
      final email = prefs.getString('temp_email');
      final name = prefs.getString('temp_name');
      final userTypeString = prefs.getString('temp_user_type');

      if (email != null && name != null && userTypeString != null) {
        await prefs.setString('user_email', email);
        await prefs.setString('user_name', name);
        await prefs.setString('user_type', userTypeString);

        _userEmail = email;
        _userName = name;
        _userType = UserType.values.firstWhere(
          (type) => type.toString() == userTypeString,
        );
        _isAuthenticated = true;

        // Limpar dados temporários
        await prefs.remove('temp_email');
        await prefs.remove('temp_name');
        await prefs.remove('temp_cpf');
        await prefs.remove('temp_user_type');
        await prefs.remove('temp_matricula');
        await prefs.remove('temp_unidade');

        return true;
      }
      return false;
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
