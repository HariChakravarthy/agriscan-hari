import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/treatment_data.dart';
import '../theme/app_theme.dart';

class TreatmentScreen extends StatelessWidget {
  final String diseaseLabel;
  final String displayName;
  final bool isHealthy;
  final double confidence;
  final String imagePath;

  const TreatmentScreen({
    super.key,
    required this.diseaseLabel,
    required this.displayName,
    required this.isHealthy,
    required this.confidence,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final treatment = TreatmentData.getTreatment(diseaseLabel);
    final description = treatment['description'] as String;
    final severity = treatment['severity'] as String;
    final chemical = List<String>.from(treatment['chemical'] as List);
    final natural = List<String>.from(treatment['natural'] as List);
    final prevention = List<String>.from(treatment['prevention'] as List);

    final severityColor = _getSeverityColor(severity);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(context, severityColor),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSeverityChip(severity, severityColor),
                const SizedBox(height: 16),
                _buildDescriptionCard(description),
                const SizedBox(height: 16),
                if (chemical.isNotEmpty) ...[
                  _buildTreatmentSection(
                    icon: Icons.science_rounded,
                    title: 'Chemical Treatments',
                    color: AppTheme.error,
                    items: chemical,
                    delay: 100,
                  ),
                  const SizedBox(height: 16),
                ],
                _buildTreatmentSection(
                  icon: Icons.eco_rounded,
                  title: isHealthy ? 'Care Tips' : 'Natural Remedies',
                  color: AppTheme.primaryLight,
                  items: natural,
                  delay: 200,
                ),
                const SizedBox(height: 16),
                _buildTreatmentSection(
                  icon: Icons.shield_rounded,
                  title: 'Prevention Strategies',
                  color: AppTheme.accent,
                  items: prevention,
                  delay: 300,
                ),
                const SizedBox(height: 16),
                _buildTreatmentSection(
                  icon: Icons.forum_rounded,
                  title: 'Community & Forum Tips',
                  color: Colors.blueAccent,
                  items: List<String>.from(treatment['community'] as List? ?? []),
                  delay: 400,
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context, Color severityColor) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppTheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Leaf image or gradient fallback
            File(imagePath).existsSync()
                ? Image.file(File(imagePath), fit: BoxFit.cover)
                : Container(color: AppTheme.cardBg),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppTheme.surface.withOpacity(0.95),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Title at bottom
            Positioned(
              bottom: 16,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayName,
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary)),
                  Text('${(confidence * 100).toStringAsFixed(1)}% confidence',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: severityColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityChip(String severity, Color color) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: color, size: 14),
              const SizedBox(width: 6),
              Text('Severity: $severity',
                  style: GoogleFonts.poppins(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildDescriptionCard(String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(description,
          style: GoogleFonts.poppins(
              color: AppTheme.textSecondary, fontSize: 13, height: 1.6)),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildTreatmentSection({
    required IconData icon,
    required String title,
    required Color color,
    required List<String> items,
    required int delay,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          ...items.asMap().entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                        color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(e.value,
                        style: GoogleFonts.poppins(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                            height: 1.5)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn().slideY(begin: 0.1);
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppTheme.error;
      case 'high':
        return AppTheme.warning;
      case 'medium':
        return Colors.orange;
      case 'none':
        return AppTheme.primaryLight;
      default:
        return AppTheme.textSecondary;
    }
  }
}
