import 'package:flutter/material.dart';
import '../theme/custom_colors.dart';

/// Gradient hero header used on admin detail screens, mirroring the
/// LoginScreen mobile layout (copper → midnight gradient with a back action,
/// title and subtitle in [CustomColors.vanilla_haze]).
class GradientHeader extends StatelessWidget {
  const GradientHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 14,
                color: CustomColors.vanilla_haze,
              ),
              label: const Text('Voltar'),
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.vanilla_haze.withOpacity(0.75),
                textStyle: const TextStyle(fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: CustomColors.vanilla_haze,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: CustomColors.vanilla_haze.withOpacity(0.60),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
