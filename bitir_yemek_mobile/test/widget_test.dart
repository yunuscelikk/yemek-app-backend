import 'package:flutter_test/flutter_test.dart';

import 'package:bitir_yemek_mobile/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pump();

    // App should render without crashing
    expect(find.text('BitirGitsin'), findsOneWidget);
  });
}
