import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:uuid/uuid.dart';
import '../models/scan_result.dart';
import '../services/classifier_service.dart';
import '../services/history_service.dart';
import '../theme/app_theme.dart';
import 'treatment_screen.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  final ClassifierService _classifier = ClassifierService();
  final HistoryService _history = HistoryService();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  bool _isLoading = false;
  bool _modelLoaded = false;
  Map<String, dynamic>? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await _classifier.loadModel();
      setState(() => _modelLoaded = true);
    } catch (e) {
      setState(() => _error = 'Model not found. Please add model.tflite to assets/ml/.');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
          source: source, maxWidth: 1024, maxHeight: 1024, imageQuality: 90);
      if (picked == null) return;
      setState(() {
        _selectedImage = File(picked.path);
        _result = null;
        _error = null;
      });
      await _runInference();
    } catch (e) {
      setState(() => _error = 'Failed to pick image: $e');
    }
  }

  Future<void> _runInference() async {
    if (_selectedImage == null || !_modelLoaded) return;
    setState(() => _isLoading = true);
    try {
      final prediction = await _classifier.predict(_selectedImage!);
      setState(() {
        _result = prediction;
        _isLoading = false;
      });
      await _saveScan(prediction);
    } catch (e) {
      setState(() {
        _error = 'Inference error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveScan(Map<String, dynamic> prediction) async {
    try {
      final scan = ScanResult(
        id: const Uuid().v4(),
        diseaseName: prediction['label'],
        displayName: prediction['displayName'],
        confidence: prediction['confidence'],
        imagePath: _selectedImage!.path,
        scannedAt: DateTime.now(),
        isHealthy: prediction['isHealthy'],
      );
      await _history.saveScan(scan);
    } catch (_) {
      // History save failure is non-critical
    }
  }

  @override
  void dispose() {
    _classifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Scan Plant'),
        backgroundColor: AppTheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildImageArea(),
            const SizedBox(height: 20),
            _buildPickerButtons(),
            const SizedBox(height: 24),
            if (_isLoading) _buildLoadingIndicator(),
            if (_error != null) _buildErrorCard(),
            if (_result != null && !_isLoading) _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageArea() {
    return GestureDetector(
      onTap: () => _showPickerModal(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 260,
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _selectedImage != null
                ? AppTheme.primaryLight.withOpacity(0.5)
                : AppTheme.textSecondary.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: _selectedImage != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(_selectedImage!, fit: BoxFit.cover),
                    if (_isLoading)
                      Container(color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(
                              color: AppTheme.primaryLight),
                        )),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_photo_alternate_rounded,
                        color: AppTheme.primaryLight, size: 50),
                    const SizedBox(height: 12),
                    Text('Tap to select a leaf image',
                        style: GoogleFonts.poppins(
                            color: AppTheme.textSecondary, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('Camera or gallery',
                        style: GoogleFonts.poppins(
                            color: AppTheme.primaryLight.withOpacity(0.7),
                            fontSize: 12)),
                  ],
                ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildPickerButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryLight,
              side: const BorderSide(color: AppTheme.primaryLight),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt_rounded, size: 20),
            label: const Text('Camera'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.accent,
              side: const BorderSide(color: AppTheme.accent),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.photo_library_rounded, size: 20),
            label: const Text('Gallery'),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        const CircularProgressIndicator(color: AppTheme.primaryLight),
        const SizedBox(height: 12),
        Text('Analyzing leaf...',
            style: GoogleFonts.poppins(
                color: AppTheme.textSecondary, fontSize: 13)),
      ],
    ).animate().fadeIn();
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppTheme.error, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(_error!,
                style: GoogleFonts.poppins(
                    color: AppTheme.error, fontSize: 13)),
          ),
        ],
      ),
    ).animate().fadeIn().shake();
  }

  Widget _buildResultCard() {
    final result = _result!;
    final confidence = result['confidence'] as double;
    final isHealthy = result['isHealthy'] as bool;
    final displayName = result['displayName'] as String;
    final label = result['label'] as String;
    final color = isHealthy ? AppTheme.primaryLight : AppTheme.error;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHealthy ? '✅ Healthy Plant' : '⚠️ Disease Detected',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: color,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayName,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 44,
                    lineWidth: 6,
                    percent: confidence,
                    center: Text('${(confidence * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.poppins(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                    progressColor: color,
                    backgroundColor: color.withOpacity(0.15),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TreatmentScreen(
                        diseaseLabel: label,
                        displayName: displayName,
                        isHealthy: isHealthy,
                        confidence: confidence,
                        imagePath: _selectedImage!.path,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.medical_services_rounded, size: 18),
                  label: const Text('View Treatment Guide',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ).animate().slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOut),
      ],
    );
  }

  void _showPickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceLight,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Image Source',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.textPrimary)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded,
                  color: AppTheme.primaryLight),
              title: Text('Camera',
                  style: GoogleFonts.poppins(color: AppTheme.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: AppTheme.accent),
              title: Text('Gallery',
                  style: GoogleFonts.poppins(color: AppTheme.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
