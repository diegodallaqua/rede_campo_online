import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/forms/form_field_shell.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/models/contributor.dart';
import 'package:rede_campo_online/core/models/contributor_roles.dart';
import 'package:rede_campo_online/features/admin/publications/screens/widgets/form/contributor_dialog.dart';
import 'package:rede_campo_online/features/members/models/members.dart';

/// Campo de gestão dos contribuidores da publicação: abre o
/// [ContributorDialog] para adicionar e lista os já escolhidos como chips
/// removíveis.
class ContributorsField extends StatelessWidget {
  const ContributorsField({
    super.key,
    required this.contributors,
    required this.availableMembers,
    required this.availableRoles,
    required this.onAdd,
    required this.onRemove,
  });

  final List<Contributors> contributors;
  final List<Members> availableMembers;
  final List<ContributorRoles> availableRoles;
  final void Function(Contributors) onAdd;
  final void Function(int index) onRemove;

  Future<void> _openDialog(BuildContext context) async {
    // Próxima ordem livre = maior ordem existente + 1. Usar o tamanho da lista
    // colide quando um contribuidor do meio é removido (ex.: [1,3] tem tamanho
    // 2, mas a ordem 3 já existe), gerando 409 AUTHOR_ORDER_CONFLICT no backend.
    final nextOrder = contributors.fold<int>(
          0,
          (max, c) => (c.order ?? 0) > max ? c.order! : max,
        ) +
        1;

    final result = await ContributorDialog.show(
      context: context,
      availableMembers: availableMembers,
      availableRoles: availableRoles,
      initialOrder: nextOrder,
    );
    if (result != null) onAdd(result);
  }

  @override
  Widget build(BuildContext context) {
    return FormFieldShell(
      label: 'Contribuidores',
      actionIcon: Icons.person_add_alt_outlined,
      actionLabel: 'Adicionar',
      onAction: () => _openDialog(context),
      child: contributors.isEmpty
          ? const FormFieldEmptyState(
              icon: Icons.people_outline_rounded,
              message: 'Nenhum contribuidor adicionado',
            )
          : FormFieldContentBox(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < contributors.length; i++)
                    _ContributorChip(
                      contributor: contributors[i],
                      onRemove: () => onRemove(i),
                    ),
                ],
              ),
            ),
    );
  }
}

class _ContributorChip extends StatelessWidget {
  const _ContributorChip({
    required this.contributor,
    required this.onRemove,
  });

  final Contributors contributor;
  final VoidCallback onRemove;

  bool get _isExternal => contributor.external_author != null;

  String get _name =>
      contributor.member?.name ?? contributor.external_author?.name ?? '—';

  @override
  Widget build(BuildContext context) {
    final role = contributor.contributor_role?.name;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 7, 6, 7),
      decoration: BoxDecoration(
        color: CustomColors.copper_spice.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CustomColors.copper_spice.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (contributor.order != null) ...[
            Text(
              '${contributor.order}º',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: CustomColors.copper_spice,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Icon(
            _isExternal ? Icons.person_outline_rounded : Icons.school_outlined,
            size: 14,
            color: CustomColors.copper_spice,
          ),
          const SizedBox(width: 6),
          Text(
            _name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: CustomColors.copper_spice,
            ),
          ),
          if (role != null && role.isNotEmpty) ...[
            const SizedBox(width: 6),
            _ChipBadge(
              label: role,
              backgroundColor: CustomColors.copper_spice.withOpacity(0.15),
              textColor: CustomColors.copper_spice,
            ),
          ],
          if (_isExternal) ...[
            const SizedBox(width: 6),
            _ChipBadge(
              label: 'Externo',
              backgroundColor: CustomColors.concrete_mist.withOpacity(0.5),
              textColor: CustomColors.pine_shadow.withOpacity(0.55),
            ),
          ],
          const SizedBox(width: 2),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onRemove,
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: CustomColors.copper_spice,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipBadge extends StatelessWidget {
  const _ChipBadge({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
