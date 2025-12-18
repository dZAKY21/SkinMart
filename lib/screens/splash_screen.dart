import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final Widget? nextScreen;
  final Duration duration;
  final String logoPath; // Path untuk logo pohon + text SKINMART

  const SplashScreen({
    Key? key,
    this.nextScreen,
    this.duration = const Duration(seconds: 2),
    required this.logoPath,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Fade in and out animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start fade in animation
    _controller.forward();

    // Schedule navigation
    _scheduleNavigation();
  }

  void _scheduleNavigation() async {
    if (widget.nextScreen != null) {
      // Wait for duration minus fade out time
      final waitDuration = widget.duration.inMilliseconds - 500;
      await Future.delayed(Duration(milliseconds: waitDuration));

      if (mounted) {
        setState(() {
        });

        // Start fade out
        await _controller.reverse();

        // Navigate with smooth transition
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  widget.nextScreen!,
              transitionDuration: const Duration(milliseconds: 600),
              reverseTransitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Smooth fade with slight scale
                    var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
                        .animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                        );

                    var scaleAnimation = Tween<double>(begin: 0.92, end: 1.0)
                        .animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        );

                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: child,
                      ),
                    );
                  },
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDFEEDD), Color(0xFFB0D7B1), Color(0xFF8BBF90)],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Image.asset(
              widget.logoPath,
              width: 389,
              height: 311,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
