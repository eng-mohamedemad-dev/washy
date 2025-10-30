import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Loading widget used throughout the app
class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;

  const LoadingWidget({
    super.key,
    this.message,
    this.color,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WashySpinner(size: size, blueColor: AppColors.washyBlue, greenColor: AppColors.washyGreen),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.colorTextNotSelected,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Simple circular loading indicator
class SimpleLoadingWidget extends StatelessWidget {
  final Color? color;
  final double size;

  const SimpleLoadingWidget({
    super.key,
    this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return WashySpinner(
      size: size,
      blueColor: color ?? AppColors.washyBlue,
      greenColor: AppColors.washyGreen,
    );
  }
}

/// WashySpinner - يحاكي مؤشر التحميل في تطبيق الجافا (قوسين أزرق وأخضر يدوران)
class WashySpinner extends StatefulWidget {
  final double size;
  final Color blueColor;
  final Color greenColor;

  const WashySpinner({
    super.key,
    this.size = 50,
    required this.blueColor,
    required this.greenColor,
  });

  @override
  State<WashySpinner> createState() => _WashySpinnerState();
}

class _WashySpinnerState extends State<WashySpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _WashySpinnerPainter(
              rotation: _controller.value * 2 * 3.1415926535,
              blueColor: widget.blueColor,
              greenColor: widget.greenColor,
              strokeWidth: widget.size * 0.12,
            ),
          );
        },
      ),
    );
  }
}

class _WashySpinnerPainter extends CustomPainter {
  final double rotation;
  final Color blueColor;
  final Color greenColor;
  final double strokeWidth;

  _WashySpinnerPainter({
    required this.rotation,
    required this.blueColor,
    required this.greenColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    final paintBlue = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = blueColor
      ..strokeWidth = strokeWidth;

    final paintGreen = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = greenColor
      ..strokeWidth = strokeWidth;

    // قوسين بطول ~ 200 درجة مع دوران مستمر لمحاكاة الشكل في الجافا
    const sweep = 3.5; // ~200deg
    final startBlue = rotation;
    final startGreen = rotation + 1.6; // إزاحة صغيرة بين القوسين

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startBlue,
      sweep,
      false,
      paintBlue,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startGreen,
      sweep,
      false,
      paintGreen,
    );
  }

  @override
  bool shouldRepaint(covariant _WashySpinnerPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.blueColor != blueColor ||
        oldDelegate.greenColor != greenColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}



