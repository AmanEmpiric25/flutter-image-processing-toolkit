import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../models/image_output_format.dart';
import 'image_compressor.dart';

class NativeImageCompressor implements ImageCompressor {
  const NativeImageCompressor();

  @override
  Future<String?> compress({
    required String inputPath,
    required String outputPath,
    required int quality,
    required ImageOutputFormat format,
  }) async {
    final output = await FlutterImageCompress.compressAndGetFile(
      inputPath,
      outputPath,
      quality: quality,
      format: switch (format) {
        ImageOutputFormat.jpeg => CompressFormat.jpeg,
        ImageOutputFormat.png => CompressFormat.png,
        ImageOutputFormat.webp => CompressFormat.webp,
        ImageOutputFormat.heic => CompressFormat.heic,
      },
    );
    return output?.path;
  }
}
