import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:fit_track/main.dart';
import 'package:fit_track/router.dart';

void main() {
  testWidgets('Экран входа отображается', (WidgetTester tester) async {
    router = GoRouter(initialLocation: '/login', routes: buildRoutes());
    await tester.pumpWidget(const FitTrackApp());

    expect(find.text('FitTrack'), findsOneWidget);
    expect(find.text('Войти'), findsOneWidget);
  });
}
