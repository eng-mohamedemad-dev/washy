import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'rotate_loading.dart';

/// CustomProgressDialog - Matches Java ProgressDialog with icon animation + rotating lines
/// Java uses: frames_animation_test.xml (29 frames) for icon + DotsZoomProgress (hidden) or rotating arcs
class CustomProgressDialog extends StatefulWidget {
  final String? iconAssetPath; // Path to animated icon frames (e.g., 'assets/images/loading/')
  final int frameCount; // Number of animation frames (default 29 for Java)
  final Duration frameDuration; // Duration per frame (default 55ms for Java)

  const CustomProgressDialog({
    super.key,
    this.iconAssetPath,
    this.frameCount = 29,
    this.frameDuration = const Duration(milliseconds: 55),
  });

  @override
  State<CustomProgressDialog> createState() => _CustomProgressDialogState();
}

class _CustomProgressDialogState extends State<CustomProgressDialog>
    with TickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late AnimationController _rotateController;
  int _currentFrame = 0;
  List<ui.Image>? _loadedFrames;

  @override
  void initState() {
    super.initState();
    
    // Icon frame animation controller (matches Java: 29 frames, 55ms each)
    _iconAnimationController = AnimationController(
      duration: widget.frameDuration * widget.frameCount,
      vsync: this,
    );
    _iconAnimationController.repeat();

    // Rotating lines animation controller
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _rotateController.repeat();

    // Load frames if asset path provided
    if (widget.iconAssetPath != null) {
      _loadFrames();
    } else {
      // If no frames, just animate the rotation
      _iconAnimationController.addListener(_updateFrame);
    }
  }

  void _updateFrame() {
    if (widget.iconAssetPath == null) return;
    final frameIndex = (_iconAnimationController.value * widget.frameCount).floor() % widget.frameCount;
    if (frameIndex != _currentFrame) {
      setState(() => _currentFrame = frameIndex);
    }
  }

  Future<void> _loadFrames() async {
    // TODO: Load frames from assets if provided
    // For now, we'll use a simple rotating icon
    _iconAnimationController.addListener(_updateFrame);
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Rotating lines (outer) - matches Java rotating arcs
              Positioned.fill(
                child: RotateLoading(
                  size: 150,
                  strokeWidth: 6,
                  color1: const Color(0xFF13C0D7), // Cyan/Blue
                  color2: const Color(0xFF52D0A0), // Green
                ),
              ),
              
              // Icon in center (80x80dp as per Java)
              // If frames available, show frame animation; otherwise show simple icon
              Positioned(
                top: 17, // Match Java: layout_marginTop="17dp"
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: widget.iconAssetPath != null && _loadedFrames != null && _loadedFrames!.isNotEmpty
                      ? CustomPaint(
                          painter: _FramePainter(image: _loadedFrames![_currentFrame]),
                        )
                      : _buildDefaultIcon(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    // Fallback: Simple rotating icon if frames not available
    return AnimatedBuilder(
      animation: _iconAnimationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _iconAnimationController.value * 2 * 3.14159,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF13C0D7),
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.local_laundry_service,
              color: Color(0xFF52D0A0),
              size: 50,
            ),
          ),
        );
      },
    );
  }
}

class _FramePainter extends CustomPainter {
  final ui.Image image;

  _FramePainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..filterQuality = FilterQuality.high;
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_FramePainter oldDelegate) => oldDelegate.image != image;
}

