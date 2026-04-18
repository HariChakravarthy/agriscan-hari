import 'package:cloud_firestore/cloud_firestore.dart';

class ScanResult {
  final String id;
  final String diseaseName;
  final String displayName;
  final double confidence;
  final String imagePath;
  final DateTime scannedAt;
  final bool isHealthy;

  ScanResult({
    required this.id,
    required this.diseaseName,
    required this.displayName,
    required this.confidence,
    required this.imagePath,
    required this.scannedAt,
    required this.isHealthy,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'diseaseName': diseaseName,
    'displayName': displayName,
    'confidence': confidence,
    'imagePath': imagePath,
    'scannedAt': Timestamp.fromDate(scannedAt),
    'isHealthy': isHealthy,
  };

  factory ScanResult.fromMap(Map<String, dynamic> map) => ScanResult(
    id: map['id'] ?? '',
    diseaseName: map['diseaseName'] ?? '',
    displayName: map['displayName'] ?? '',
    confidence: (map['confidence'] ?? 0.0).toDouble(),
    imagePath: map['imagePath'] ?? '',
    scannedAt: (map['scannedAt'] as Timestamp).toDate(),
    isHealthy: map['isHealthy'] ?? false,
  );
}
