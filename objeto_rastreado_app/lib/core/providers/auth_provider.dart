import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _userEmail;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get userEmail => _userEmail;

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

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulando uma chamada de API
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implementar chamada real de API
      if (email.isNotEmpty && password.length >= 6) {
        _isAuthenticated = true;
        _userEmail = email;

        // Salvar dados do usuário se "lembrar-me" estiver marcado
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulando uma chamada de API
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implementar chamada real de API
      if (email.isNotEmpty && password.length >= 6 && name.isNotEmpty) {
        _isAuthenticated = true;
        _userEmail = email;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    // Simulando uma chamada de API
    await Future.delayed(const Duration(seconds: 1));

    _isAuthenticated = false;
    _userEmail = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulando uma chamada de API
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implementar chamada real de API
      if (email.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
