import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ClassifierService {
  static const String _modelPath = 'assets/ml/model.tflite';
  static const String _labelsPath = 'assets/ml/labels.txt';
  static const int _inputSize = 224;

  Interpreter? _interpreter;
  List<String> _labels = [];

  bool get isLoaded => _interpreter != null && _labels.isNotEmpty;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
      await _loadLabels();
    } catch (e) {
      throw Exception('Failed to load TFLite model: $e');
    }
  }

  Future<void> _loadLabels() async {
    final raw = await rootBundle.loadString(_labelsPath);
    _labels = raw.trim().split('\n').map((s) => s.trim()).toList();
  }

  Future<Map<String, dynamic>> predict(File imageFile) async {
    if (!isLoaded) throw Exception('Model not loaded. Call loadModel() first.');

    // Load and resize image
    final bytes = await imageFile.readAsBytes();
    final rawImage = img.decodeImage(bytes);
    if (rawImage == null) throw Exception('Could not decode image.');

    final resized = img.copyResize(rawImage, width: _inputSize, height: _inputSize);

    // Normalize: pixel values 0.0–1.0 (image v4 API)
    final input = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (y) => List.generate(
          _inputSize,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    // Run inference
    final output = List.filled(1 * 15, 0.0).reshape([1, 15]);
    _interpreter?.run(input, output);

    // Parse results
    final probabilities = (output[0] as List).cast<double>();

    // Find top prediction
    double maxProb = 0.0;
    int maxIdx = 0;
    for (int i = 0; i < probabilities.length; i++) {
      if (probabilities[i] > maxProb) {
        maxProb = probabilities[i];
        maxIdx = i;
      }
    }

    final rawLabel = _labels[maxIdx];
    return {
      'label': rawLabel,
      'displayName': _formatLabel(rawLabel),
      'confidence': maxProb,
      'isHealthy': rawLabel.toLowerCase().contains('healthy'),
      'allProbabilities': Map.fromIterables(_labels, probabilities),
    };
  }

  String _formatLabel(String raw) {
    // e.g. "Tomato___Bacterial_spot" -> "Bacterial Spot"
    return raw
        .replaceAll(RegExp(r'^[A-Za-z]+___'), '')
        .replaceAll('_', ' ');
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
