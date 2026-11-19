/// Formats that can be requested for a compressed image.
enum ImageOutputFormat {
  jpeg('jpg'),
  png('png'),
  webp('webp'),
  heic('heic');

  const ImageOutputFormat(this.fileExtension);

  /// Conventional output filename extension, without a leading period.
  final String fileExtension;
}
