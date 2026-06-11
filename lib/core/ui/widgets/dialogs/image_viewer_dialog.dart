import 'package:flutter/material.dart';

import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

class ImageViewerDialog extends StatefulWidget {
  final List<String> imageUrls;
  final List<String?> imageNames;
  final int initialIndex;

  const ImageViewerDialog({
    super.key,
    required this.imageUrls,
    this.imageNames = const [],
    this.initialIndex = 0,
  });

  static Future<void> show({
    required BuildContext context,
    required List<String> imageUrls,
    List<String?> imageNames = const [],
    int initialIndex = 0,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Fechar',
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (ctx, _, __) => ImageViewerDialog(
        imageUrls: imageUrls,
        imageNames: imageNames,
        initialIndex: initialIndex,
      ),
      transitionBuilder: (ctx, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<ImageViewerDialog> createState() => _ImageViewerDialogState();
}

class _ImageViewerDialogState extends State<ImageViewerDialog> {
  late final PageController _controller;
  late int _currentIndex;

  static const int _maxDots = 7;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _hasMultiple => widget.imageUrls.length > 1;
  bool get _useDots => widget.imageUrls.length <= _maxDots;

  String? get _currentName {
    if (widget.imageNames.isEmpty ||
        _currentIndex >= widget.imageNames.length) {
      return null;
    }
    final name = widget.imageNames[_currentIndex];
    return (name != null && name.isNotEmpty) ? name : null;
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.imageUrls.length;

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            // ── Swipeable image pages ──────────────────────────────
            PageView.builder(
              controller: _controller,
              itemCount: total,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 80),
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.imageUrls[index],
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const ImagePlaceholder(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // ── Top bar: counter (left) + close button (right) ─────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_hasMultiple)
                      _CounterBadge(current: _currentIndex + 1, total: total)
                    else
                      const SizedBox.shrink(),
                    _CloseButton(onTap: () => Navigator.of(context).pop()),
                  ],
                ),
              ),
            ),

            // ── Left / Right arrows ────────────────────────────────
            if (_hasMultiple) ...[
              Positioned(
                left: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _ArrowButton(
                    icon: Icons.chevron_left_rounded,
                    enabled: _currentIndex > 0,
                    onTap: () => _controller.previousPage(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _ArrowButton(
                    icon: Icons.chevron_right_rounded,
                    enabled: _currentIndex < widget.imageUrls.length - 1,
                    onTap: () => _controller.nextPage(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
              ),
            ],

            // ── Bottom: name + dot indicators / counter ─────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_currentName != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 8),
                      child: Text(
                        _currentName!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: CustomColors.vanilla_haze,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(blurRadius: 10, color: Colors.black)
                          ],
                        ),
                      ),
                    ),
                  if (_hasMultiple)
                    _useDots
                        ? _DotIndicators(
                            count: total,
                            activeIndex: _currentIndex,
                          )
                        : _BottomCounter(
                            current: _currentIndex + 1,
                            total: total,
                          ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
        ),
        child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
      ),
    );
  }
}

class _CounterBadge extends StatelessWidget {
  final int current;
  final int total;
  const _CounterBadge({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Text(
        '$current / $total',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BottomCounter extends StatelessWidget {
  final int current;
  final int total;
  const _BottomCounter({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$current / $total',
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const _ArrowButton(
      {required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: enabled ? 1.0 : 0.25,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

class _DotIndicators extends StatelessWidget {
  final int count;
  final int activeIndex;
  const _DotIndicators({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20.0 : 6.0,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.35),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
