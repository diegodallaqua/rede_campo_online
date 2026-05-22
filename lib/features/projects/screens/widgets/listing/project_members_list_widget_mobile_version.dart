import 'package:flutter/material.dart';

import '../../../../../core/ui/listing_tiles/members/member_tile.dart';
import '../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../core/ui/widgets/arrow_button.dart';
import '../../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../members/models/members.dart';

class ProjectMembersListWidgetMobileVersion extends StatefulWidget {
  final List<Members> members;

  static const double _cardWidth = 160.0;
  static const double _cardHeight = 220.0;
  static const double _gap = 12.0;

  const ProjectMembersListWidgetMobileVersion({
    super.key,
    required this.members,
  });

  @override
  State<ProjectMembersListWidgetMobileVersion> createState() =>
      _ProjectMembersListWidgetMobileVersionState();
}

class _ProjectMembersListWidgetMobileVersionState
    extends State<ProjectMembersListWidgetMobileVersion> {
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
    final target = (_scrollController.offset -
            ProjectMembersListWidgetMobileVersion._cardWidth -
            ProjectMembersListWidgetMobileVersion._gap)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    final target = (_scrollController.offset +
            ProjectMembersListWidgetMobileVersion._cardWidth +
            ProjectMembersListWidgetMobileVersion._gap)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.members.isEmpty) {
      return const ListEmptyState(
        message: 'Nenhum membro vinculado a este projeto.',
        messageColor: CustomColors.vanilla_haze,
        iconColor: CustomColors.vanilla_haze,
      );
    }
    return _buildList(widget.members);
  }

  Widget _buildList(List<Members> members) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth - 2 * 40 - 2 * 8;
        final int visibleCount =
            ((availableWidth + ProjectMembersListWidgetMobileVersion._gap) /
                    (ProjectMembersListWidgetMobileVersion._cardWidth +
                        ProjectMembersListWidgetMobileVersion._gap))
                .floor()
                .clamp(1, members.length);
        final bool allFit = members.length <= visibleCount;

        return Row(
          children: [
            ArrowButton(
              icon: Icons.chevron_left_rounded,
              enabled: !allFit && _canScrollLeft,
              onTap: _scrollLeft,
              iconColor: CustomColors.vanilla_haze,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: ProjectMembersListWidgetMobileVersion._cardHeight,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: members.length,
                  separatorBuilder: (_, __) => const SizedBox(
                    width: ProjectMembersListWidgetMobileVersion._gap,
                  ),
                  itemBuilder: (context, index) {
                    return MemberTile(
                        member: members[index],
                        mainColor: CustomColors.vanilla_haze);
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            ArrowButton(
              icon: Icons.chevron_right_rounded,
              enabled: !allFit && _canScrollRight,
              onTap: _scrollRight,
              iconColor: CustomColors.vanilla_haze,
            ),
          ],
        );
      },
    );
  }
}
