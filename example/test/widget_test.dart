import 'dart:io';
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_image_processing_toolkit/flutter_image_processing_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  testWidgets('shows the compression entry point', (tester) async {
    await tester.pumpWidget(const CompressionDemoApp());

    expect(find.text('Image compression'), findsOneWidget);
    expect(find.text('Select image'), findsOneWidget);
    expect(find.text('Native, non-destructive compression'), findsOneWidget);
  });

  testWidgets('selects an output format for a chosen image', (tester) async {
    final directory = await Directory.systemTemp.createTemp(
      'compression-demo-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final image = File('${directory.path}/source.png');
    await image.writeAsBytes(
      Uint8List.fromList([
        137,
        80,
        78,
        71,
        13,
        10,
        26,
        10,
        0,
        0,
        0,
        13,
        73,
        72,
        68,
        82,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        1,
        8,
        6,
        0,
        0,
        0,
        31,
        21,
        196,
        137,
        0,
        0,
        0,
        0,
        13,
        73,
        68,
        65,
        84,
        8,
        215,
        99,
        248,
        207,
        192,
        240,
        31,
        0,
        5,
        0,
        1,
        255,
        137,
        153,
        61,
        29,
        0,
        0,
        0,
        0,
        73,
        69,
        78,
        68,
        174,
        66,
        96,
        130,
      ]),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: CompressionDemoPage(imageSelector: () async => XFile(image.path)),
      ),
    );

    await tester.tap(find.text('Select image'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<ImageOutputFormat?>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('WebP').last);
    await tester.pumpAndSettle();

    expect(find.text('Output format'), findsOneWidget);
    expect(find.text('WebP'), findsOneWidget);
  });
}
