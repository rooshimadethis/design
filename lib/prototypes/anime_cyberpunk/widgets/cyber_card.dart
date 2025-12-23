import 'package:flutter/material.dart';
import '../theme.dart';

class CyberCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool showBorder;

  const CyberCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          color: CyberTheme.cardBg,
          shape: _CyberShape(
            borderColor: showBorder
                ? CyberTheme.neonCyan.withOpacity(0.5)
                : Colors.transparent,
            borderWidth: showBorder ? 1.0 : 0.0,
          ),
          shadows: showBorder
              ? [
                  BoxShadow(
                    color: CyberTheme.neonCyan.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Custom Clipper/Painter for the "Cut Corner" effect
class _CyberShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double cutSize;

  const _CyberShape({
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.cutSize = 20.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // Cut top-right and bottom-left corners
    return Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right - cutSize, rect.top)
      ..lineTo(rect.right, rect.top + cutSize)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left + cutSize, rect.bottom)
      ..lineTo(rect.left, rect.bottom - cutSize)
      ..lineTo(rect.left, rect.top)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (borderWidth == 0.0) return;

    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawPath(getOuterPath(rect), paint);
  }

  @override
  ShapeBorder scale(double t) => this; // Simplified
}
