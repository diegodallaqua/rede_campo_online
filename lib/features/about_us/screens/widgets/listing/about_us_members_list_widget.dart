import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../core/ui/listing_tiles/members/member_tile.dart';
import '../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../core/ui/widgets/arrow_button.dart';
import '../../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../../core/ui/widgets/list_error_state.dart';
import '../../../../../core/ui/widgets/list_loading_state.dart';
import '../../../../members/models/members.dart';
import '../../../../members/stores/members_store.dart';

class AboutUsMembersListWidget extends StatefulWidget {
  final MembersStore membersStore;

  const AboutUsMembersListWidget({super.key, required this.membersStore});

  @override
  State<AboutUsMembersListWidget> createState() =>
      _AboutUsMembersListWidgetState();
}

class _AboutUsMembersListWidgetState extends State<AboutUsMembersListWidget> {
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
        if (widget.membersStore.showProgress) {
          return const ListLoadingState(
            color: CustomColors.copper_spice,
          );
        } else if (widget.membersStore.membersError != null &&
            widget.membersStore.list.isEmpty) {
          return ListErrorState(
            message: 'Não foi possível carregar os membros.',
            onRetry: () => widget.membersStore.refreshMembers,
            iconColor: CustomColors.copper_spice,
            messageColor: CustomColors.pine_shadow,
          );
        } else if (widget.membersStore.list.isEmpty) {
          return const ListEmptyState(
            message: 'Nenhum membro encontrado.',
          );
        }
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
            ArrowButton(
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
            ArrowButton(
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
}
