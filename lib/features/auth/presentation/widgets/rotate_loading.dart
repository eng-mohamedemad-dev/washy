import 'package:flutter/material.dart';
import 'dart:math' as math;

/// RotateLoading - Custom loading animation matching Java RotateLoading
/// Two interlocking curved lines (blue/cyan and green) that rotate continuously
class RotateLoading extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final Color color1; // First line color (blue/cyan)
  final Color color2; // Second line color (green)
  final Duration duration;

  const RotateLoading({
    super.key,
    this.size = 60,
    this.strokeWidth = 6,
    this.color1 = const Color(0xFF13C0D7), // Cyan/Blue
    this.color2 = const Color(0xFF52D0A0), // Green
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<RotateLoading> createState() => _RotateLoadingState();
}

class _RotateLoadingState extends State<RotateLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _arcAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Rotation animation (continuous loop)
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Arc size animation (grows and shrinks)
    _arcAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.2).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 0.5,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _RotateLoadingPainter(
              rotation: _rotationAnimation.value,
              arcProgress: _arcAnimation.value,
              color1: widget.color1,
              color2: widget.color2,
              strokeWidth: widget.strokeWidth,
            ),
          ),
        );
      },
    );
  }
}

class _RotateLoadingPainter extends CustomPainter {
  final double rotation;
  final double arcProgress;
  final Color color1;
  final Color color2;
  final double strokeWidth;

  _RotateLoadingPainter({
    required this.rotation,
    required this.arcProgress,
    required this.color1,
    required this.color2,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;

    // Match Java: arc varies between 10 and 160 degrees (in radians)
    // Java: arc grows from 10 to 160, then shrinks back
    final arcDegrees = 10 + (150 * arcProgress); // 10 to 160 degrees
    final sweepAngle = math.pi * arcDegrees / 180;

    // First arc (blue/cyan) - starts at topDegree
    // Java: topDegree starts at 10 and rotates continuously
    final topDegreeRad = (10 * math.pi / 180) + rotation;

    final paint1 = Paint()
      ..color = color1
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      topDegreeRad,
      sweepAngle,
      false,
      paint1,
    );

    // Second arc (green) - starts at bottomDegree (180 degrees offset)
    // Java: bottomDegree starts at 190 and rotates continuously
    final bottomDegreeRad = (190 * math.pi / 180) + rotation;

    final paint2 = Paint()
      ..color = color2
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      bottomDegreeRad,
      sweepAngle,
      false,
      paint2,
    );
  }

  @override
  bool shouldRepaint(_RotateLoadingPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.arcProgress != arcProgress ||
        oldDelegate.color1 != color1 ||
        oldDelegate.color2 != color2 ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

