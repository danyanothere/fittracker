import 'package:flutter_test/flutter_test.dart';

import 'package:fit_track/main.dart';

void main() {
  testWidgets('Экран входа отображается', (WidgetTester tester) async {
    await tester.pumpWidget(const FitTrackApp());

    expect(find.text('FitTrack'), findsOneWidget);
    expect(find.text('Войти'), findsOneWidget);
  });
}
