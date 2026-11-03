import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'auth_layout.dart';

/// Title + subtitle at the top of each form.
/// On narrow screens it also shows a small logo, because the brand panel
/// is hidden there.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final isNarrow =
        MediaQuery.sizeOf(context).width < AuthLayout.wideBreakpoint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isNarrow) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.hub_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 24),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textMuted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
