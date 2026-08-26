import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/members/models/members.dart';

class MembersDialog extends StatefulWidget {
  const MembersDialog({
    super.key,
    required this.availableMembers,
    this.selectedMembers = const [],
  });

  final List<Members> availableMembers;
  final List<Members> selectedMembers;

  /// Shows the dialog and returns the confirmed selection, or null if cancelled.
  static Future<List<Members>?> show({
    required BuildContext context,
    required List<Members> availableMembers,
    List<Members> selectedMembers = const [],
  }) {
    return showDialog<List<Members>>(
      context: context,
      builder: (_) => MembersDialog(
        availableMembers: availableMembers,
        selectedMembers: selectedMembers,
      ),
    );
  }

  @override
  State<MembersDialog> createState() => _MembersDialogState();
}

class _MembersDialogState extends State<MembersDialog> {
  late final Set<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = {
      for (final member in widget.selectedMembers)
        if (member.id != null) member.id!,
    };
  }

  void _toggle(Members member) {
    if (member.id == null) return;
    setState(() {
      if (_selectedIds.contains(member.id)) {
        _selectedIds.remove(member.id);
      } else {
        _selectedIds.add(member.id!);
      }
    });
  }

  List<Members> get _result => widget.availableMembers
      .where((m) => m.id != null && _selectedIds.contains(m.id))
      .toList();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Membros',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: CustomColors.midnight_slate,
          fontSize: 17,
        ),
      ),
      content: widget.availableMembers.isEmpty
          ? const Text(
              'Nenhum membro disponível.',
              style: TextStyle(
                  color: CustomColors.neutral_gray, fontSize: 14, height: 1.5),
            )
          : ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360, maxWidth: 400),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.availableMembers.map((member) {
                    final selected =
                        member.id != null && _selectedIds.contains(member.id);
                    return CheckboxListTile(
                      value: selected,
                      onChanged: (_) => _toggle(member),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: CustomColors.copper_spice,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        member.name ?? '-',
                        style: const TextStyle(
                          fontSize: 14,
                          color: CustomColors.midnight_slate,
                        ),
                      ),
                      subtitle:
                          (member.email != null && member.email!.isNotEmpty)
                              ? Text(
                                  member.email!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CustomColors.midnight_slate
                                        .withOpacity(0.5),
                                  ),
                                )
                              : null,
                    );
                  }).toList(),
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: CustomColors.neutral_gray),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.copper_spice,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          onPressed: () => Navigator.of(context).pop(_result),
          child: const Text(
            'Confirmar',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
