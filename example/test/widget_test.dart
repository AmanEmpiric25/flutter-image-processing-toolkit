import 'package:material_ui/material_ui.dart';
import 'package:flutter_image_processing_toolkit/flutter_image_processing_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('shows the compression entry point', (tester) async {
    await tester.pumpWidget(const CompressionDemoApp());

    expect(find.text('Image compression'), findsOneWidget);
    expect(find.text('Select image'), findsOneWidget);
    expect(find.text('Native, non-destructive compression'), findsOneWidget);
  });

  testWidgets('selects an output format', (tester) async {
    ImageOutputFormat? selection;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OutputFormatSelector(
            value: selection,
            onChanged: (format) => selection = format,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<ImageOutputFormat?>));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('WebP').last);
    await tester.pump();

    expect(selection, ImageOutputFormat.webp);
  });
}
