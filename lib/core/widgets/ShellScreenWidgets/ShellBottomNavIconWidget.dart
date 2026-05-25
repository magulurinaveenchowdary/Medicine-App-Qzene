import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';

enum WireframeBottomNavTabKind { today, medicines, history, settings }

/// Bottom-nav icons matching `Medicine_Reminder_Wireframes_v2` SVG paths.
class ShellBottomNavIconWidget extends StatelessWidget {
  const ShellBottomNavIconWidget({
    super.key,
    required this.tabKind,
    required this.isActive,
    this.size = 22,
  });

  final WireframeBottomNavTabKind tabKind;
  final bool isActive;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? AppColorsDesignTokens.colorPrimary
        : AppColorsDesignTokens.textSecondary;
    return CustomPaint(
      size: Size(size, size),
      painter: _ShellBottomNavIconPainter(
        tabKind: tabKind,
        isActive: isActive,
        color: color,
      ),
    );
  }
}

class _ShellBottomNavIconPainter extends CustomPainter {
  _ShellBottomNavIconPainter({
    required this.tabKind,
    required this.isActive,
    required this.color,
  });

  final WireframeBottomNavTabKind tabKind;
  final bool isActive;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    canvas.scale(scale);
    switch (tabKind) {
      case WireframeBottomNavTabKind.today:
        _paintToday(canvas);
      case WireframeBottomNavTabKind.medicines:
        _paintMedicines(canvas);
      case WireframeBottomNavTabKind.history:
        _paintHistory(canvas);
      case WireframeBottomNavTabKind.settings:
        _paintSettings(canvas);
    }
  }

  void _paintToday(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(3, 5, 18, 16),
      const Radius.circular(2),
    );
    if (isActive) {
      canvas.drawRRect(rect, Paint()..color = color);
      return;
    }
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rect, stroke);
    canvas.drawLine(const Offset(3, 9), const Offset(21, 9), stroke);
    canvas.drawLine(const Offset(8, 3), const Offset(8, 7), stroke);
    canvas.drawLine(const Offset(16, 3), const Offset(16, 7), stroke);
  }

  void _paintMedicines(Canvas canvas) {
    canvas.save();
    canvas.translate(12, 12);
    canvas.rotate(-0.52);
    canvas.translate(-12, -12);
    final pill = RRect.fromRectAndRadius(
      const Rect.fromLTWH(3, 10, 18, 4),
      const Radius.circular(2),
    );
    if (isActive) {
      canvas.drawRRect(pill, Paint()..color = color);
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          const Rect.fromLTWH(3, 10, 9, 4),
          topLeft: const Radius.circular(2),
          bottomLeft: const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFF5BA3F7),
      );
    } else {
      final stroke = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRRect(pill, stroke);
    }
    canvas.restore();
  }

  void _paintHistory(Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = isActive ? 2.5 : 2
      ..strokeCap = StrokeCap.round;
    if (isActive) {
      canvas.drawLine(const Offset(3, 20), const Offset(3, 10), paint);
      canvas.drawLine(const Offset(9, 20), const Offset(9, 4), paint);
      canvas.drawLine(const Offset(15, 20), const Offset(15, 13), paint);
      canvas.drawLine(const Offset(21, 20), const Offset(21, 17), paint);
    } else {
      canvas.drawLine(const Offset(3, 20), const Offset(3, 10), paint);
      canvas.drawLine(const Offset(9, 20), const Offset(9, 4), paint);
      canvas.drawLine(const Offset(15, 20), const Offset(15, 13), paint);
      canvas.drawLine(const Offset(21, 20), const Offset(21, 17), paint);
    }
  }

  void _paintSettings(Canvas canvas) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(const Offset(12, 12), 9, stroke);
    if (isActive) {
      canvas.drawCircle(const Offset(12, 12), 3, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _ShellBottomNavIconPainter oldDelegate) {
    return oldDelegate.tabKind != tabKind ||
        oldDelegate.isActive != isActive ||
        oldDelegate.color != color;
  }
}
