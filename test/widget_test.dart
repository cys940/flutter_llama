import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_ai_chat/main.dart';

void main() {
  testWidgets('App renders ChatScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: LocalAiChatApp(),
      ),
    );

    // Verify that the main title exists.
    expect(find.text('Local AI Chat'), findsOneWidget);
    
    // Verify that the welcome text (Curator) exists before model is loaded
    expect(find.text('The Digital Curator'), findsOneWidget);
  });
}
