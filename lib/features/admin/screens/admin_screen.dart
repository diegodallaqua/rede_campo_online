import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_dashboard_desktop_version.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_dashboard_mobile_version.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.vanilla_haze.withOpacity(0.5),
      body: const ResponsiveVisibility(
        visible: false,
        visibleWhen: [Condition.largerThan(name: TABLET)],
        replacement: AdminDashboardMobileVersion(),
        child: AdminDashboardDesktopVersion(),
      ),
    );
  }
}
