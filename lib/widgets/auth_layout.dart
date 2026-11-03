import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/constants.dart';

/// Responsive shell shared by the login and register pages.
///
/// * Wide screens (Chrome / tablets): brand panel on the left, form on the right.
/// * Narrow screens (phones): just the form, centred and scrollable.
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.child});

  /// Width at which we switch to the two-column layout.
  static const double wideBreakpoint = 900;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= wideBreakpoint;

          final form = SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: child,
                ),
              ),
            ),
          );

          if (!isWide) return form;

          return Row(
            children: [
              const Expanded(flex: 5, child: _BrandPanel()),
              Expanded(flex: 4, child: form),
            ],
          );
        },
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, AppTheme.primaryDark],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -80,
            right: -60,
            child: _circle(260, Colors.white.withAlpha(25)),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: _circle(320, Colors.white.withAlpha(20)),
          ),
          Positioned.fill(
            child: Padding(
            padding: const EdgeInsets.all(56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.hub_rounded,
                      color: Colors.white, size: 34),
                ),
                const SizedBox(height: 28),
                const Text(
                  AppInfo.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppInfo.tagline,
                  style: TextStyle(
                    color: Colors.white.withAlpha(215),
                    fontSize: 20,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),
                const _Feature(text: 'Secure sign-in with validated forms'),
                const _Feature(text: 'Clean, responsive design on any screen'),
                const _Feature(text: 'Get started in under a minute'),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded,
              color: Colors.white.withAlpha(230), size: 22),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withAlpha(230),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
