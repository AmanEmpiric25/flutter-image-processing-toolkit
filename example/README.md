# Compression example

This Android/iOS app demonstrates the public `flutter_image_processing_toolkit` API. It selects an image from the gallery, chooses a quality and optional output format, previews both files, and writes the new file to the app documents directory under `compressed-images`.

```sh
flutter pub get
flutter run
```

The app does not implement image processing itself; all compression is delegated to `ImageCompressionService` from the package root.
