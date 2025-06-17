import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tracked_object.dart';

class TrackedObjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'objects';

  Future<List<TrackedObject>> getAllObjects() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs
          .map((doc) => TrackedObject.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar objetos: $e');
    }
  }

  Future<List<TrackedObject>> getUserObjects(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) => TrackedObject.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar objetos do usuário: $e');
    }
  }

  Future<List<TrackedObject>> getObjectsByStatus(String status) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: status)
          .get();
      return snapshot.docs
          .map((doc) => TrackedObject.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar objetos por status: $e');
    }
  }

  Future<TrackedObject> createObject({
    required String name,
    required String description,
    required String location,
    required String userId,
  }) async {
    try {
      final object = TrackedObject(
        id: '', // Será gerado pelo Firestore
        name: name,
        description: description,
        location: location,
        status: 'Ativo',
        userId: userId,
        createdAt: DateTime.now(),
      );

      final docRef = await _firestore
          .collection(_collection)
          .add(object.toMap());
      return TrackedObject.fromMap(object.toMap(), docRef.id);
    } catch (e) {
      throw Exception('Erro ao criar objeto: $e');
    }
  }

  Future<void> updateObject(TrackedObject object) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(object.id)
          .update(object.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar objeto: $e');
    }
  }

  Future<void> deleteObject(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar objeto: $e');
    }
  }
}
