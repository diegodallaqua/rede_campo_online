import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';

class MetricHighlightsWidget extends StatefulWidget {
  final bool isDesktop;

  const MetricHighlightsWidget({super.key, this.isDesktop = false});

  @override
  State<MetricHighlightsWidget> createState() => _MetricHighlightsWidgetState();
}

class _MetricHighlightsWidgetState extends State<MetricHighlightsWidget>
    with TickerProviderStateMixin {
  static const _metrics = [
    _Metric('+60', 'Membros espalhados por todo o Brasil'),
    _Metric('+100', 'Artigos, livros e relatórios publicados'),
    _Metric('+10', 'Projetos de extensão em andamento'),
    _Metric('+5', 'Aplicações desenvolvidas'),
  ];

  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _slides;
  late final List<Animation<double>> _fades;

  ScrollPosition? _scrollPosition;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _metrics.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 680),
      ),
    );
    _slides = _controllers
        .map((c) => Tween<Offset>(
              begin: const Offset(0, 0.35),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: c, curve: Curves.easeOutCubic)))
        .toList();
    _fades = _controllers
        .map((c) => Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollPosition?.removeListener(_checkVisibility);
    final scrollable = context.findAncestorStateOfType<ScrollableState>();
    _scrollPosition = scrollable?.position;
    _scrollPosition?.addListener(_checkVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_checkVisibility);
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _checkVisibility() {
    if (_hasAnimated || !mounted) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    if (offset.dy < screenHeight * 0.90) {
      _hasAnimated = true;
      _scrollPosition?.removeListener(_checkVisibility);
      _triggerAnimations();
    }
  }

  void _triggerAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isDesktop ? _buildDesktop() : _buildMobile();
  }

  Widget _buildMobile() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - 20) / 3;
        final count = _metrics.length;
        final rows = <Widget>[];
        int i = 0;
        while (i < count) {
          final tilesInRow = (count - i) >= 3 ? 3 : (count - i);
          if (rows.isNotEmpty) rows.add(const SizedBox(height: 10));
          final rowChildren = <Widget>[];
          for (int j = 0; j < tilesInRow; j++) {
            if (rowChildren.isNotEmpty) {
              rowChildren.add(const SizedBox(width: 10));
            }
            rowChildren.add(
                SizedBox(width: tileWidth, child: _animatedMobileTile(i + j)));
          }
          rows.add(
            tilesInRow == 3
                ? Row(children: rowChildren)
                : Center(
                    child: Row(
                        mainAxisSize: MainAxisSize.min, children: rowChildren)),
          );
          i += tilesInRow;
        }
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
      },
    );
  }

  Widget _animatedMobileTile(int i) {
    return FadeTransition(
      opacity: _fades[i],
      child: SlideTransition(
        position: _slides[i],
        child: _MobileTile(metric: _metrics[i]),
      ),
    );
  }

  Widget _buildDesktop() {
    final count = _metrics.length;
    final rows = <Widget>[];
    int i = 0;
    while (i < count) {
      final isOddLast = (i == count - 1) && count.isOdd;
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 16));
      if (isOddLast) {
        rows.add(_animatedDesktopTile(i));
        i++;
      } else {
        rows.add(Row(
          children: [
            Expanded(child: _animatedDesktopTile(i)),
            const SizedBox(width: 16),
            Expanded(child: _animatedDesktopTile(i + 1)),
          ],
        ));
        i += 2;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }

  Widget _animatedDesktopTile(int i) {
    return FadeTransition(
      opacity: _fades[i],
      child: SlideTransition(
        position: _slides[i],
        child: _DesktopTile(metric: _metrics[i]),
      ),
    );
  }
}

class _MobileTile extends StatelessWidget {
  final _Metric metric;

  const _MobileTile({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.fromLTRB(10, 18, 10, 18),
      decoration: BoxDecoration(
        color: CustomColors.midnight_slate,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: CustomColors.copper_spice.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.copper_spice.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                colors: [CustomColors.copper_spice, CustomColors.fresh_sprout],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            metric.number,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: CustomColors.copper_spice,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            metric.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopTile extends StatelessWidget {
  final _Metric metric;

  const _DesktopTile({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: CustomColors.midnight_slate,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CustomColors.copper_spice.withOpacity(0.22),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.copper_spice.withOpacity(0.10),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                colors: [CustomColors.copper_spice, CustomColors.fresh_sprout],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            metric.number,
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: CustomColors.copper_spice,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            metric.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric {
  final String number;
  final String description;

  const _Metric(this.number, this.description);
}
