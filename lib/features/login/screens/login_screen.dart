import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/login/screens/widgets/login_branding_panel.dart';
import 'package:rede_campo_online/features/login/screens/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.vanilla_haze.withOpacity(0.5),
      body: const ResponsiveVisibility(
        visible: false,
        visibleWhen: [Condition.largerThan(name: TABLET)],
        replacement: _MobileLayout(),
        child: _DesktopLayout(),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: LoginBrandingPanel()),
        Expanded(child: _FormPanel()),
      ],
    );
  }
}

class _FormPanel extends StatelessWidget {
  const _FormPanel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () => context.go(AppRoutes.home),
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
              label: const Text('Voltar'),
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.midnight_slate.withOpacity(0.50),
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(fontSize: 13),
              ),
            ),
            const Spacer(),
            const Text(
              'Bem-vindo de volta',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: CustomColors.pine_shadow,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Faça login para acessar o painel administrativo.',
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.pine_shadow.withOpacity(0.55),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            const LoginForm(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [CustomColors.copper_spice, CustomColors.midnight_slate],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => context.go(AppRoutes.home),
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          size: 14, color: CustomColors.vanilla_haze),
                      label: const Text('Voltar'),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            CustomColors.vanilla_haze.withOpacity(0.55),
                        padding: EdgeInsets.zero,
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rede Campo\nOnline',
                            style: TextStyle(
                              color: CustomColors.vanilla_haze,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Área restrita para pesquisadores\nassociados ao grupo.',
                            style: TextStyle(
                              color:
                                  CustomColors.vanilla_haze.withOpacity(0.60),
                              fontSize: 13,
                              height: 1.65,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: CustomColors.salt_flower,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Faça login para acessar o painel administrativo.',
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.midnight_slate.withOpacity(0.55),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const LoginForm(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
