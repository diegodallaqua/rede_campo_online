import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/ui/listing_tiles/member_tile.dart';
import '../../../../core/ui/theme/custom_colors.dart';
import '../../../members/models/members.dart';
import '../../../members/stores/members_store.dart';

class MembersListWidget extends StatefulWidget {
  final MembersStore membersStore;

  const MembersListWidget({super.key, required this.membersStore});

  @override
  State<MembersListWidget> createState() => _MembersListWidgetState();
}

class _MembersListWidgetState extends State<MembersListWidget> {
  static const double _cardWidth = 160.0;
  static const double _cardHeight = 220.0;
  static const double _gap = 12.0;

  final ScrollController _scrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateArrowState);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrowState);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateArrowState() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    setState(() {
      _canScrollLeft = pos.pixels > 0;
      _canScrollRight = pos.pixels < pos.maxScrollExtent;
    });
  }

  void _scrollLeft() {
    final target = (_scrollController.offset - _cardWidth - _gap)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    final target = (_scrollController.offset + _cardWidth + _gap)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (widget.membersStore.showProgress) return _buildLoading();
        if (widget.membersStore.membersError != null &&
            widget.membersStore.list.isEmpty) return _buildError();
        if (widget.membersStore.list.isEmpty) return _buildEmpty();
        return _buildList(widget.membersStore.list);
      },
    );
  }

  Widget _buildList(List<Members> members) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth - 2 * 40 - 2 * 8;
        final int visibleCount = ((availableWidth + _gap) / (_cardWidth + _gap))
            .floor()
            .clamp(1, members.length);
        final bool allFit = members.length <= visibleCount;

        return Row(
          children: [
            _ArrowButton(
              icon: Icons.chevron_left_rounded,
              enabled: !allFit && _canScrollLeft,
              onTap: _scrollLeft,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: _cardHeight,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: members.length,
                  separatorBuilder: (_, __) => const SizedBox(width: _gap),
                  itemBuilder: (context, index) {
                    return MemberTile(
                      member: members[index],
                      onTap: () => _onMemberTap(members[index]),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            _ArrowButton(
              icon: Icons.chevron_right_rounded,
              enabled: !allFit && _canScrollRight,
              onTap: _scrollRight,
            ),
          ],
        );
      },
    );
  }

  void _onMemberTap(Members member) {
    // TODO: navegar para a tela de detalhe do membro
  }

  Widget _buildLoading() {
    return const SizedBox(
      height: _cardHeight,
      child: Center(
        child: CircularProgressIndicator(
          color: CustomColors.copper_spice,
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _buildError() {
    return SizedBox(
      height: _cardHeight,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                color: CustomColors.pine_shadow, size: 32),
            const SizedBox(height: 8),
            const Text(
              'Não foi possível carregar os membros.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: CustomColors.pine_shadow),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: widget.membersStore.refreshMembers,
              child: const Text(
                'Tentar novamente',
                style: TextStyle(
                  fontSize: 13,
                  color: CustomColors.copper_spice,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const SizedBox(
      height: _cardHeight,
      child: Center(
        child: Text(
          'Nenhum membro cadastrado no momento.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: CustomColors.pine_shadow),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _ArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.2,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: CustomColors.copper_spice,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
