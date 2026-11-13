import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/utils/admin_navigation.dart';

import 'admin_sections.dart';

/// Atalhos da tela inicial do painel: uma grade que quebra linha conforme a
/// largura (até 3 colunas), com "Ver todas" e criação rápida em cada seção.
class AdminSectionsGrid extends StatelessWidget {
  const AdminSectionsGrid({super.key});

  static const double _minCardWidth = 280;
  static const double _gap = 16;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ((constraints.maxWidth + _gap) / (_minCardWidth + _gap))
            .floor()
            .clamp(1, 3);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: _gap,
            mainAxisSpacing: _gap,
            mainAxisExtent: 164,
          ),
          itemCount: adminSections.length,
          itemBuilder: (context, index) =>
              _AdminSectionCard(section: adminSections[index]),
        );
      },
    );
  }
}

class _AdminSectionCard extends StatelessWidget {
  const _AdminSectionCard({required this.section});

  final AdminSection section;

  static const _radius = BorderRadius.all(Radius.circular(14));

  @override
  Widget build(BuildContext context) {
    void openList() => context.push(section.listRoute);

    return Material(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: _radius,
        side: BorderSide(color: CustomColors.soft_border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell(
              onTap: openList,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: CustomColors.peach_cream,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        section.icon,
                        color: CustomColors.copper_spice,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.label,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: CustomColors.midnight_slate,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            section.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.4,
                              color:
                                  CustomColors.midnight_slate.withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: CustomColors.soft_border,
          ),
          SizedBox(
            height: 46,
            child: Row(
              children: [
                Expanded(
                  child: _CardAction(
                    label: section.seeAllLabel,
                    trailingIcon: Icons.arrow_forward_rounded,
                    color: CustomColors.pine_shadow,
                    onTap: openList,
                  ),
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: CustomColors.soft_border,
                ),
                Expanded(
                  child: _CardAction(
                    label: section.createLabel,
                    leadingIcon: Icons.add_rounded,
                    color: CustomColors.copper_spice,
                    onTap: () => openAdminForm(context, section.createRoute),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  const _CardAction({
    required this.label,
    required this.color,
    required this.onTap,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 18, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 6),
            Icon(trailingIcon, size: 18, color: color),
          ],
        ],
      ),
    );
  }
}
