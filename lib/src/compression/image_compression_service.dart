import 'dart:io';

import 'package:path/path.dart' as path;

import '../exceptions/image_processing_exception.dart';
import '../models/compression_result.dart';
import '../models/image_compression_options.dart';
import '../models/image_output_format.dart';
import 'image_compressor.dart';
import 'native_image_compressor.dart';

/// Compresses image files using the native Android and iOS codecs.
class ImageCompressionService {
  ImageCompressionService({ImageCompressor? compressor})
    : _compressor = compressor ?? const NativeImageCompressor();

  final ImageCompressor _compressor;

  /// Creates a new compressed file and leaves [input] unchanged.
  Future<CompressionResult> compress(
    File input, {
    ImageCompressionOptions options = const ImageCompressionOptions(),
  }) async {
    _validateOptions(options);
    final originalSize = await _validateInput(input);
    final format = options.outputFormat ?? _formatForPath(input.path);
    final outputDirectory =
        options.outputDirectory ??
        Directory(path.join(input.parent.path, 'compressed_images'));
    final outputPath = path.join(
      outputDirectory.path,
      '${path.basenameWithoutExtension(input.path)}_compressed_'
      '${DateTime.now().microsecondsSinceEpoch}.${format.fileExtension}',
    );
    final expectedOutput = File(outputPath);

    try {
      await outputDirectory.create(recursive: true);
      final outputPathFromCodec = await _compressor.compress(
        inputPath: input.path,
        outputPath: outputPath,
        quality: options.quality,
        format: format,
      );
      if (outputPathFromCodec == null) {
        throw const ImageProcessingException(
          ImageProcessingErrorCode.compressionFailed,
          'The native codec did not produce an output file.',
        );
      }
      final output = File(outputPathFromCodec);
      if (!await output.exists()) {
        throw const ImageProcessingException(
          ImageProcessingErrorCode.compressionFailed,
          'The native codec returned a path that does not exist.',
        );
      }
      return CompressionResult(
        originalFile: input,
        outputFile: output,
        originalSizeBytes: originalSize,
        compressedSizeBytes: await output.length(),
        outputFormat: format,
      );
    } on ImageProcessingException {
      await _deleteIfPresent(expectedOutput);
      rethrow;
    } catch (error) {
      await _deleteIfPresent(expectedOutput);
      throw ImageProcessingException(
        ImageProcessingErrorCode.compressionFailed,
        'Unable to compress the image.',
        cause: error,
      );
    }
  }

  Future<int> _validateInput(File input) async {
    if (!await input.exists()) {
      throw const ImageProcessingException(
        ImageProcessingErrorCode.invalidInput,
        'The input file does not exist.',
      );
    }
    final size = await input.length();
    if (size == 0) {
      throw const ImageProcessingException(
        ImageProcessingErrorCode.invalidInput,
        'The input file is empty.',
      );
    }
    _formatForPath(input.path);
    return size;
  }

  void _validateOptions(ImageCompressionOptions options) {
    if (options.quality < 0 || options.quality > 100) {
      throw const ImageProcessingException(
        ImageProcessingErrorCode.invalidInput,
        'Compression quality must be between 0 and 100.',
      );
    }
  }

  ImageOutputFormat _formatForPath(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return switch (extension) {
      '.jpg' || '.jpeg' => ImageOutputFormat.jpeg,
      '.png' => ImageOutputFormat.png,
      '.webp' => ImageOutputFormat.webp,
      '.heic' => ImageOutputFormat.heic,
      _ => throw ImageProcessingException(
        ImageProcessingErrorCode.unsupportedFormat,
        'Unsupported image format: ${extension.isEmpty ? '(none)' : extension}.',
      ),
    };
  }

  Future<void> _deleteIfPresent(File file) async {
    if (await file.exists()) await file.delete();
  }
}
