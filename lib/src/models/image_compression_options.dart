import 'dart:io';

import 'image_output_format.dart';

/// Controls one compression operation.
class ImageCompressionOptions {
  /// Creates compression options.
  ///
  /// [quality] is an inclusive value between 0 and 100. A null [outputFormat]
  /// preserves the input format when that format is supported.
  const ImageCompressionOptions({
    this.quality = 80,
    this.outputFormat,
    this.outputDirectory,
  });

  /// Codec quality, from 0 (smallest) to 100 (highest quality).
  final int quality;

  /// Requested output format. Native platform support varies by format.
  final ImageOutputFormat? outputFormat;

  /// Directory for the generated file. A directory is created if necessary.
  final Directory? outputDirectory;
}
