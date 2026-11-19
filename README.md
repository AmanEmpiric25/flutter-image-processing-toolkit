# Flutter Image Processing Toolkit

A reusable Flutter package for non-destructive image compression on Android and iOS. This first release intentionally implements compression only; resizing, cropping, metadata, and camera workflows are out of scope.

## Features

- Asynchronous native image compression.
- Quality from 0 through 100, optional output format, and configurable output directory.
- JPEG, PNG, WebP, and HEIC extension validation.
- A new output file for every operation; the original file is never changed.
- Typed failures and a result containing sizes, output path, format, and saved percentage.
- An Android/iOS example app with gallery selection, previews, progress, errors, and an app-documents export location.

## Installation

```yaml
dependencies:
  flutter_image_processing_toolkit: ^0.1.0
```

Run `flutter pub get`, then import the package:

```dart
import 'package:flutter_image_processing_toolkit/flutter_image_processing_toolkit.dart';
```

Flutter 3.50 or later (Dart 3.12 or later) is required.

## Usage

```dart
final compressor = ImageCompressionService();
final result = await compressor.compress(
  File('/path/to/source.jpg'),
  options: ImageCompressionOptions(
    quality: 75,
    outputFormat: ImageOutputFormat.jpeg,
    outputDirectory: Directory('/path/to/exports'),
  ),
);

print(result.outputFile.path);
print('${result.compressionPercentage.toStringAsFixed(1)}% saved');
```

Omit `outputFormat` to use the supported source format. Omit `outputDirectory` to create a `compressed_images` directory beside the input. Catch `ImageProcessingException` and inspect its `code` (`invalidInput`, `unsupportedFormat`, or `compressionFailed`).

## API

`ImageCompressionService.compress(File, {ImageCompressionOptions options})` returns a `Future<CompressionResult>`.

`CompressionResult` provides `originalFile`, `outputFile`, `originalSizeBytes`, `compressedSizeBytes`, `outputFormat`, and `compressionPercentage`. The percentage is clamped to 0–100: an output that is larger than its source reports `0% saved` rather than a misleading negative value.

## Platforms and limitations

Android and iOS are supported through `flutter_image_compress`. Codec availability, notably HEIC and WebP output, depends on the platform and device; requests unavailable on the current device fail with `compressionFailed`. Files are validated by extension before native decoding, so a corrupt file with a supported extension may still fail during native compression. The package does not target web, macOS, Windows, or Linux in this release.

Compression is asynchronous and uses the native codec, but applications should still present a loading state for large images. Generated output remains under caller control; remove exported files when they are no longer needed.

## Example screenshots

Run the example on an Android or iOS device to see the gallery-to-export compression flow. Screenshots will be added after device verification; no screenshots are included yet.

```sh
cd example
flutter run
```

## Testing

Host-side checks, no device required:

```sh
dart format --output=none --set-exit-if-changed lib test example/lib example/test example/integration_test
flutter analyze
flutter test
cd example && flutter test
```

### Integration tests

`example/integration_test/compression_test.dart` drives the real Android and iOS
codecs, which the unit tests replace with an injected adapter. It needs a
connected device, emulator, or simulator:

```sh
cd example
flutter devices
flutter test integration_test
```

The test copies the bundled `assets/sample_photo.jpg` fixture into the app
documents directory, compresses it into a subdirectory there, and deletes
everything it wrote on teardown. It never reads the gallery and never writes to
external storage, so it needs no runtime storage permission. CI does not run it:
GitHub-hosted runners have no attached device.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Please open an issue before broad changes, use a focused branch such as `feature/compression-format-picker` or `fix/heic-output-error`, and submit a tested pull request.

## License

This project is released under the BSD 3-Clause License. See [LICENSE](LICENSE).
