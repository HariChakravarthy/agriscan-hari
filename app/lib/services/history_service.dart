import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/scan_result.dart';

class HistoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _collection {
    return _db.collection('users').doc(_userId ?? 'anonymous').collection('scans');
  }

  Future<void> saveScan(ScanResult scan) async {
    await _collection.doc(scan.id).set(scan.toMap());
  }

  Stream<List<ScanResult>> watchHistory() {
    return _collection
        .orderBy('scannedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => ScanResult.fromMap(d.data())).toList());
  }

  Future<List<ScanResult>> getHistory() async {
    final snap = await _collection.orderBy('scannedAt', descending: true).get();
    return snap.docs.map((d) => ScanResult.fromMap(d.data())).toList();
  }

  Future<void> deleteScan(String id) async {
    await _collection.doc(id).delete();
  }
}
