import 'package:flutter/material.dart';

// Силуэт тела с тапабельными группами мышц. Тап по зоне -> onSelect(группа),
// каталог фильтруется тем же серверным поиском, что и чипы.
// Зоны делятся по вертикальным полосам (центр) + бокам (руки/спина),
// чтобы тап был однозначным.
class MuscleFigure extends StatelessWidget {
  final String? selected; // имя выбранной группы или null
  final ValueChanged<String> onSelect;

  const MuscleFigure({super.key, required this.selected, required this.onSelect});

  // перевод точки тапа (0..1) в группу мышц
  String? _hit(Offset n) {
    final x = n.dx, y = n.dy;
    if (y < 0.15 || y > 0.98) return null;
    final central = x >= 0.33 && x <= 0.67;
    if (!central) {
      if (y >= 0.17 && y <= 0.52) return 'Спина'; // руки/бока
      return null;
    }
    if (y < 0.21) return 'Плечи';
    if (y < 0.335) return 'Грудь';
    if (y < 0.51) return 'Кор';
    return 'Ноги';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 0.62,
      child: LayoutBuilder(
        builder: (context, c) {
          final size = Size(c.maxWidth, c.maxHeight);
          return GestureDetector(
            onTapDown: (d) {
              final n = Offset(
                d.localPosition.dx / size.width,
                d.localPosition.dy / size.height,
              );
              final g = _hit(n);
              if (g != null) onSelect(g);
            },
            child: CustomPaint(
              size: size,
              painter: _BodyPainter(selected: selected, scheme: scheme),
            ),
          );
        },
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  final String? selected;
  final ColorScheme scheme;

  _BodyPainter({required this.selected, required this.scheme});

  @override
  void paint(Canvas canvas, Size s) {
    final base = scheme.surfaceContainerHighest;
    final idle = Color.lerp(base, scheme.primary, 0.16)!;
    final hot = scheme.primary;

    Rect r(double l, double t, double rt, double b) =>
        Rect.fromLTRB(l * s.width, t * s.height, rt * s.width, b * s.height);
    RRect rr(double l, double t, double rt, double b, double rad) =>
        RRect.fromRectAndRadius(r(l, t, rt, b), Radius.circular(rad * s.width));
    Offset o(double x, double y) => Offset(x * s.width, y * s.height);

    final p = Paint()..style = PaintingStyle.fill;

    // --- силуэт ---
    p.color = base;
    canvas.drawCircle(o(0.5, 0.085), 0.072 * s.width, p); // голова
    canvas.drawRRect(rr(0.455, 0.14, 0.545, 0.19, 0.02), p); // шея
    canvas.drawRRect(rr(0.345, 0.18, 0.655, 0.52, 0.05), p); // торс
    canvas.drawRRect(rr(0.21, 0.20, 0.30, 0.49, 0.05), p); // левая рука
    canvas.drawRRect(rr(0.70, 0.20, 0.79, 0.49, 0.05), p); // правая рука
    canvas.drawRRect(rr(0.36, 0.52, 0.47, 0.96, 0.05), p); // левая нога
    canvas.drawRRect(rr(0.53, 0.52, 0.64, 0.96, 0.05), p); // правая нога

    // --- зоны мышц: сначала все приглушённо, потом выбранная ярко ---
    void zone(String group, Color color) {
      p.color = color;
      switch (group) {
        case 'Плечи':
          canvas.drawCircle(o(0.335, 0.205), 0.075 * s.width, p);
          canvas.drawCircle(o(0.665, 0.205), 0.075 * s.width, p);
        case 'Грудь':
          canvas.drawRRect(rr(0.355, 0.225, 0.495, 0.325, 0.03), p);
          canvas.drawRRect(rr(0.505, 0.225, 0.645, 0.325, 0.03), p);
        case 'Кор':
          canvas.drawRRect(rr(0.42, 0.345, 0.58, 0.39, 0.02), p);
          canvas.drawRRect(rr(0.42, 0.40, 0.58, 0.445, 0.02), p);
          canvas.drawRRect(rr(0.42, 0.455, 0.58, 0.50, 0.02), p);
        case 'Ноги':
          canvas.drawRRect(rr(0.36, 0.53, 0.47, 0.73, 0.05), p);
          canvas.drawRRect(rr(0.53, 0.53, 0.64, 0.73, 0.05), p);
        case 'Спина':
          canvas.drawRRect(rr(0.21, 0.21, 0.30, 0.48, 0.05), p);
          canvas.drawRRect(rr(0.70, 0.21, 0.79, 0.48, 0.05), p);
      }
    }

    for (final g in const ['Плечи', 'Грудь', 'Кор', 'Ноги', 'Спина']) {
      zone(g, idle);
    }
    if (selected != null) zone(selected!, hot);
  }

  @override
  bool shouldRepaint(covariant _BodyPainter old) =>
      old.selected != selected || old.scheme != scheme;
}
