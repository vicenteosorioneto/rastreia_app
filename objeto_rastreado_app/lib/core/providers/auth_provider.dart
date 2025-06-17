import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_type.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  String? _userEmail;
  String? _userName;
  UserType? _userType;
  final String _verificationCode = '123456';
  DateTime? _lastCodeSentTime;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get currentUser => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  UserType? get userType => _userType;
  DateTime? get lastCodeSentTime => _lastCodeSentTime;

  Future<void> signIn({required String email, required String password}) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _auth.signOut();
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _checkCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      _userEmail = user.email;
      _isAuthenticated = true;

      // Buscar dados adicionais do usuário no Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        _userName = data['name'];
        _userType = UserType.values.firstWhere(
          (type) => type.toString() == data['userType'],
        );
      }
    }
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
      await _auth.sendPasswordResetEmail(email: email);
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
      // Criar usuário no Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Salvar dados adicionais no Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'cpf': cpf,
          'userType': userType.toString(),
          'matricula': matricula,
          'unidade': unidade,
          'createdAt': FieldValue.serverTimestamp(),
        });

        _userEmail = email;
        _userName = name;
        _userType = userType;
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
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
