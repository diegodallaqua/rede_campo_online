import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/admin/projects/screens/widgets/members_dialog.dart';
import 'package:rede_campo_online/features/members/models/members.dart';

class MembersField extends StatelessWidget {
  const MembersField({
    super.key,
    required this.availableMembers,
    required this.selectedMembers,
    required this.onChanged,
  });

  final List<Members> availableMembers;
  final List<Members> selectedMembers;
  final void Function(List<Members>) onChanged;

  Future<void> _openDialog(BuildContext context) async {
    final result = await MembersDialog.show(
      context: context,
      availableMembers: availableMembers,
      selectedMembers: selectedMembers,
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Membros',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CustomColors.midnight_slate,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _openDialog(context),
              icon: const Icon(Icons.group_add_outlined, size: 18),
              label: Text(selectedMembers.isEmpty ? 'Selecionar' : 'Editar'),
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.copper_spice,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (selectedMembers.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: CustomColors.vanilla_haze.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CustomColors.soft_border),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 28,
                  color: CustomColors.midnight_slate.withOpacity(0.25),
                ),
                const SizedBox(height: 6),
                Text(
                  'Nenhum membro selecionado',
                  style: TextStyle(
                    fontSize: 13,
                    color: CustomColors.midnight_slate.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CustomColors.vanilla_haze.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CustomColors.soft_border),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedMembers
                  .map((member) => _MemberChip(name: member.name ?? '-'))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _MemberChip extends StatelessWidget {
  const _MemberChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: CustomColors.copper_spice.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CustomColors.copper_spice.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_outline_rounded,
              size: 14, color: CustomColors.copper_spice),
          const SizedBox(width: 6),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: CustomColors.copper_spice,
            ),
          ),
        ],
      ),
    );
  }
}
