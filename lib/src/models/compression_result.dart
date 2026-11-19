import 'dart:io';

import 'image_output_format.dart';

/// The successful outcome of an image compression operation.
class CompressionResult {
  const CompressionResult({
    required this.originalFile,
    required this.outputFile,
    required this.originalSizeBytes,
    required this.compressedSizeBytes,
    required this.outputFormat,
  });

  final File originalFile;
  final File outputFile;
  final int originalSizeBytes;
  final int compressedSizeBytes;
  final ImageOutputFormat outputFormat;

  /// Fraction of bytes saved, clamped to avoid invalid percentages.
  double get compressionRatio {
    if (originalSizeBytes <= 0) return 0;
    final ratio = (originalSizeBytes - compressedSizeBytes) / originalSizeBytes;
    return ratio.clamp(0, 1).toDouble();
  }

  /// Percentage of bytes saved, in the inclusive range 0 to 100.
  double get compressionPercentage => compressionRatio * 100;
}
