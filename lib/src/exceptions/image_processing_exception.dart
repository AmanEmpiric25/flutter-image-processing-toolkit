/// Failure categories returned by the image processing toolkit.
enum ImageProcessingErrorCode {
  invalidInput,
  unsupportedFormat,
  compressionFailed,
}

/// A typed, actionable error from an image processing operation.
class ImageProcessingException implements Exception {
  const ImageProcessingException(this.code, this.message, {this.cause});

  final ImageProcessingErrorCode code;
  final String message;
  final Object? cause;

  @override
  String toString() => 'ImageProcessingException($code): $message';
}
