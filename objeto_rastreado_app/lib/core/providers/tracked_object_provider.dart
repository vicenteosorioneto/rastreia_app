import 'package:flutter/foundation.dart';
import '../models/tracked_object.dart';
import '../services/tracked_object_service.dart';

class TrackedObjectProvider with ChangeNotifier {
  final TrackedObjectService _service;
  List<TrackedObject> _objects = [];
  bool _isLoading = false;
  String? _error;

  TrackedObjectProvider(this._service);

  List<TrackedObject> get objects => _objects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Carregar objetos do usuário
  Future<void> loadUserObjects(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _objects = await _service.getUserObjects(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao carregar objetos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Carregar todos os objetos
  Future<void> loadAllObjects() async {
    _setLoading(true);
    try {
      _objects = await _service.getAllObjects();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Criar novo objeto
  Future<TrackedObject> createObject({
    required String name,
    required String description,
    required String location,
    required String userId,
  }) async {
    _setLoading(true);
    try {
      final object = await _service.createObject(
        name: name,
        description: description,
        location: location,
        userId: userId,
      );
      _objects.add(object);
      _error = null;
      return object;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Atualizar objeto
  Future<void> updateObject(TrackedObject object) async {
    _setLoading(true);
    try {
      await _service.updateObject(object);
      final index = _objects.indexWhere((o) => o.id == object.id);
      if (index != -1) {
        _objects[index] = object;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Deletar objeto
  Future<void> deleteObject(String id) async {
    _setLoading(true);
    try {
      await _service.deleteObject(id);
      _objects.removeWhere((o) => o.id == id);
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Buscar objetos por status
  Future<void> loadObjectsByStatus(String status) async {
    _setLoading(true);
    try {
      _objects = await _service.getObjectsByStatus(status);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
