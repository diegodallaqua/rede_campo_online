import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class LoginBrandingPanel extends StatelessWidget {
  const LoginBrandingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CustomColors.copper_spice, CustomColors.midnight_slate],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: CustomColors.vanilla_haze.withOpacity(0.06),
                  width: 48,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 10,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: CustomColors.vanilla_haze.withOpacity(0.09),
                  width: 24,
                ),
              ),
            ),
          ),
          Positioned(
            top: 52,
            right: 52,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.vanilla_haze.withOpacity(0.55),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo_white.png',
                  height: 64,
                  fit: BoxFit.contain,
                ),
                const Spacer(),
                const Text(
                  'Rede Campo\nOnline',
                  style: TextStyle(
                    color: CustomColors.vanilla_haze,
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Área restrita para pesquisadores\nassociados ao grupo.',
                  style: TextStyle(
                    color: CustomColors.vanilla_haze.withOpacity(0.60),
                    fontSize: 15,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 56),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
