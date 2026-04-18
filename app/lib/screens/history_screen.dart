import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/scan_result.dart';
import '../services/history_service.dart';
import '../theme/app_theme.dart';
import 'treatment_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Scan History'),
        backgroundColor: AppTheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded,
                color: AppTheme.textSecondary),
            onPressed: () {}, // Future: filter by date / disease type
          ),
        ],
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: _historyService.watchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryLight),
            );
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          final scans = snapshot.data ?? [];

          if (scans.isEmpty) {
            return _buildEmptyState();
          }

          return _buildHistoryList(scans);
        },
      ),
    );
  }

  Widget _buildHistoryList(List<ScanResult> scans) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: scans.length,
      itemBuilder: (context, index) {
        final scan = scans[index];
        return _buildScanTile(context, scan, index);
      },
    );
  }

  Widget _buildScanTile(BuildContext context, ScanResult scan, int index) {
    final color = scan.isHealthy ? AppTheme.primaryLight : AppTheme.error;
    final timeStr = DateFormat('dd MMM yyyy  •  hh:mm a').format(scan.scannedAt);

    return Dismissible(
      key: Key(scan.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: AppTheme.error),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => _historyService.deleteScan(scan.id),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TreatmentScreen(
              diseaseLabel: scan.diseaseName,
              displayName: scan.displayName,
              isHealthy: scan.isHealthy,
              confidence: scan.confidence,
              imagePath: scan.imagePath,
            ),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(15)),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: File(scan.imagePath).existsSync()
                      ? Image.file(File(scan.imagePath), fit: BoxFit.cover)
                      : Container(
                          color: AppTheme.surfaceLight,
                          child: Icon(Icons.image_not_supported_rounded,
                              color: AppTheme.textSecondary),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(scan.displayName,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(timeStr,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: AppTheme.textSecondary)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              scan.isHealthy ? '✅ Healthy' : '⚠️ Disease',
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: color,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(scan.confidence * 100).toStringAsFixed(1)}%',
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.chevron_right_rounded,
                    color: AppTheme.textSecondary),
              ),
            ],
          ),
        ).animate(delay: Duration(milliseconds: index * 60)).fadeIn().slideX(begin: 0.05),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_rounded,
              size: 70, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text('No scans yet',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          Text('Scan a plant leaf to see\nyour history here.',
              style: GoogleFonts.poppins(
                  color: AppTheme.textSecondary, fontSize: 13),
              textAlign: TextAlign.center),
        ],
      ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  Widget _buildErrorState(String error) {
    // If Firebase not configured yet, show a friendly placeholder
    final isFirebaseError =
        error.contains('firebase') || error.contains('Firebase') || error.contains('network');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 60, color: AppTheme.textSecondary),
            const SizedBox(height: 16),
            Text(
              isFirebaseError ? 'Firebase not configured' : 'Error loading history',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              isFirebaseError
                  ? 'History will be available once Firebase is set up.'
                  : error,
              style: GoogleFonts.poppins(
                  color: AppTheme.textSecondary, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        title: Text('Delete Scan',
            style: GoogleFonts.poppins(color: AppTheme.textPrimary)),
        content: Text('Are you sure you want to remove this scan from history?',
            style: GoogleFonts.poppins(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete',
                style: GoogleFonts.poppins(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}
