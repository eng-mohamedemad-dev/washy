import 'package:flutter/material.dart';

/// SplashPage - App splash screen matching Java SplashActivity
/// Java uses: background_splash.xml gradient + ic_splash.png logo with fade-in animation
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Match Java: AnimationUtils.loadAnimation(this, R.anim.fade_in)
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000), // Typical fade-in duration
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    // Start animation immediately like Java
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Match Java background_splash.xml gradient
        // Gradient: startColor="#13C0D7" (cyan), centerColor="#52D0A0" (teal), endColor="#92E068" (green)
        // angle="315" (diagonal from top-left to bottom-right)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF13C0D7), // Cyan - start color
              Color(0xFF52D0A0), // Teal - center color (in Java XML)
              Color(0xFF92E068), // Green - end color
            ],
            stops: [0.0, 0.5, 1.0], // Distribute colors evenly with center at 0.5
          ),
        ),
        child: Center(
          // Match Java: Logo centered in parent with fade-in animation
          // Java uses: ImageView with ic_splash.png (84dp x 83dp) + fade_in animation
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              'assets/images/ic_splash.png',
              width: 84,
              height: 83,
              // Fallback if image doesn't exist
              errorBuilder: (context, error, stackTrace) {
                // If logo doesn't exist, show a simple white circle as placeholder
                return Container(
                  width: 84,
                  height: 83,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.local_laundry_service,
                    color: Colors.white,
                    size: 50,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

