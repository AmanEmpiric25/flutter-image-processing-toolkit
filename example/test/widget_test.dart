import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('shows the compression entry point', (tester) async {
    await tester.pumpWidget(const CompressionDemoApp());

    expect(find.text('Image compression'), findsOneWidget);
    expect(find.text('Select image'), findsOneWidget);
    expect(find.text('Native, non-destructive compression'), findsOneWidget);
  });
}
