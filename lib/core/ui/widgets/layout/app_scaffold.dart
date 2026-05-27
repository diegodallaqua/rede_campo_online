import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';
import 'custom_app_bar.dart';
import 'mobile_drawer.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key, required this.body});

  final Widget body;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  bool _drawerOpen = false;

  void _closeDrawer() => setState(() => _drawerOpen = false);

  @override
  Widget build(BuildContext context) {
    const double drawerWidth = 250.0;

    return Scaffold(
      backgroundColor: CustomColors.vanilla_haze,
      appBar: CustomAppBar(
          onMenuTap: () => setState(() => _drawerOpen = !_drawerOpen)),
      body: Stack(
        children: [
          widget.body,
          IgnorePointer(
            ignoring: !_drawerOpen,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 280),
              opacity: _drawerOpen ? 0.54 : 0.0,
              child: GestureDetector(
                onTap: _closeDrawer,
                child: Container(color: Colors.black),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: ClipRect(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                width: _drawerOpen ? drawerWidth : 0.0,
                child: OverflowBox(
                  maxWidth: drawerWidth,
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: drawerWidth,
                    child: MobileDrawer(onClose: _closeDrawer),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
