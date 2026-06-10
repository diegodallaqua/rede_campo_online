import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../core/global/injection.dart';
import '../core/utils/stores/user_manager_store.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  await initializeDateFormatting('pt_BR', null);
  await getIt<UserManagerStore>().checkSession();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(400, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(768, name: TABLET),
          const ResponsiveBreakpoint.resize(1024, name: DESKTOP),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Rede Campo Online',
    );
  }
}
