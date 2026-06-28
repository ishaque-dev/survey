import 'package:flutter_test/flutter_test.dart';
import 'package:survey/main.dart';

void main() {
  testWidgets('Survey form renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Phone Number'), findsWidgets);
    expect(find.text('Proceed to vote'), findsOneWidget);
  });
}
