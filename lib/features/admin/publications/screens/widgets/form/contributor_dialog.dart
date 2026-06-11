import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/forms/admin_input_decoration.dart';
import 'package:rede_campo_online/core/ui/forms/form_field_shell.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import 'package:rede_campo_online/core/utils/models/contributor.dart';
import 'package:rede_campo_online/core/utils/models/contributor_roles.dart';
import 'package:rede_campo_online/core/utils/models/external_author.dart';
import 'package:rede_campo_online/features/members/models/members.dart';

/// Diálogo de criação de um contribuidor da publicação. O contribuidor pode
/// ser um membro do grupo ou um autor externo criado na hora — neste caso o
/// autor externo é persistido junto com o salvamento da publicação, antes do
/// próprio contribuidor.
class ContributorDialog extends StatefulWidget {
  const ContributorDialog({
    super.key,
    required this.availableMembers,
    required this.availableRoles,
    this.initialOrder = 1,
  });

  final List<Members> availableMembers;
  final List<ContributorRoles> availableRoles;
  final int initialOrder;

  /// Exibe o Dialog e retorna o contribuidor montado, ou null se cancelado.
  static Future<Contributors?> show({
    required BuildContext context,
    required List<Members> availableMembers,
    required List<ContributorRoles> availableRoles,
    int initialOrder = 1,
  }) {
    return showDialog<Contributors>(
      context: context,
      builder: (_) => ContributorDialog(
        availableMembers: availableMembers,
        availableRoles: availableRoles,
        initialOrder: initialOrder,
      ),
    );
  }

  @override
  State<ContributorDialog> createState() => _ContributorDialogState();
}

class _ContributorDialogState extends State<ContributorDialog> {
  bool _isExternal = false;
  bool _showErrors = false;

  // Membro
  final _searchController = TextEditingController();
  String _searchQuery = '';
  Members? _selectedMember;

  // Autor externo
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _orcidController = TextEditingController();

  // Papel
  ContributorRoles? _selectedRole;

  // Ordem de autoria
  late final TextEditingController _orderController =
      TextEditingController(text: widget.initialOrder.toString());

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _orcidController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  List<Members> get _filteredMembers {
    if (_searchQuery.isEmpty) return widget.availableMembers;
    return widget.availableMembers
        .where((m) =>
            (m.name ?? '').toLowerCase().contains(_searchQuery) ||
            (m.email ?? '').toLowerCase().contains(_searchQuery))
        .toList();
  }

  bool get _memberValid => _isExternal || _selectedMember != null;

  bool get _nameValid => !_isExternal || _nameController.text.trim().isNotEmpty;

  // Opcional; quando preenchido exige formato de e-mail.
  bool get _emailValid {
    if (!_isExternal) return true;
    final value = _emailController.text.trim();
    if (value.isEmpty) return true;
    return value.isEmailValid();
  }

  // Opcional; quando preenchido exige o formato ORCID 0000-0000-0000-000X.
  bool get _orcidValid {
    if (!_isExternal) return true;
    final value = _orcidController.text.trim();
    if (value.isEmpty) return true;
    return RegExp(r'^\d{4}-\d{4}-\d{4}-\d{3}[\dXx]$').hasMatch(value);
  }

  bool get _roleValid => _selectedRole != null;

  bool get _orderValid {
    final order = int.tryParse(_orderController.text.trim());
    return order != null && order > 0;
  }

  bool get _isValid =>
      _memberValid &&
      _nameValid &&
      _emailValid &&
      _orcidValid &&
      _roleValid &&
      _orderValid;

  void _confirm() {
    if (!_isValid) {
      setState(() => _showErrors = true);
      return;
    }

    final contributor = Contributors(
      member: _isExternal ? null : _selectedMember,
      external_author: _isExternal
          ? ExternalAuthors(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              orcid: _orcidController.text.trim().toUpperCase(),
            )
          : null,
      contributor_role: _selectedRole,
      order: int.parse(_orderController.text.trim()),
    );
    Navigator.of(context).pop(contributor);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Adicionar Contribuidor',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: CustomColors.midnight_slate,
          fontSize: 17,
        ),
      ),
      content: SizedBox(
        width: 400,
        height: MediaQuery.sizeOf(context).height * 0.5,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTypeToggle(),
              const SizedBox(height: 16),
              if (_isExternal)
                _buildExternalAuthorForm()
              else
                _buildMemberPicker(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildRoleDropdown(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _orderController,
                onChanged: (_) => setState(() {}),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    color: CustomColors.midnight_slate, fontSize: 14),
                decoration: adminInputDecoration(
                  label: 'Ordem de autoria',
                  icon: Icons.format_list_numbered_rounded,
                  errorText: _showErrors && !_orderValid
                      ? 'Informe um número válido'
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Color(0xFF6B7280)),
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
          onPressed: _confirm,
          child: const Text(
            'Adicionar',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeToggle() {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment(
          value: false,
          label: Text('Membro do grupo'),
          icon: Icon(Icons.group_outlined, size: 16),
        ),
        ButtonSegment(
          value: true,
          label: Text('Autor externo'),
          icon: Icon(Icons.person_add_alt_outlined, size: 16),
        ),
      ],
      selected: {_isExternal},
      onSelectionChanged: (selection) =>
          setState(() => _isExternal = selection.first),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? Colors.white
              : CustomColors.midnight_slate,
        ),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? CustomColors.copper_spice
              : Colors.transparent,
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      showSelectedIcon: false,
    );
  }

  Widget _buildMemberPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomSearchBar(
          controller: _searchController,
          onSubmitted: (query) =>
              setState(() => _searchQuery = query.trim().toLowerCase()),
          hintText: 'Pesquisar membro',
          borderColor: const Color(0xFFE2E2DC),
          textColor: CustomColors.midnight_slate,
          hintColor: CustomColors.midnight_slate.withOpacity(0.45),
          iconColor: CustomColors.midnight_slate.withOpacity(0.45),
        ),
        const SizedBox(height: 8),
        // Altura fixa com rolagem própria: a lista de membros nunca faz o
        // diálogo crescer além do tamanho previsto, mesmo com muitos itens.
        SizedBox(
          height: 220,
          child: widget.availableMembers.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Nenhum membro disponível.',
                    style: TextStyle(
                        color: Color(0xFF6B7280), fontSize: 14, height: 1.5),
                  ),
                )
              : _filteredMembers.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Nenhum resultado encontrado',
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.midnight_slate.withOpacity(0.45),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _filteredMembers
                            .map((member) => _buildMemberOption(member))
                            .toList(),
                      ),
                    ),
        ),
        if (_showErrors && !_memberValid)
          const FieldErrorText(message: 'Selecione um membro', topSpacing: 4),
      ],
    );
  }

  Widget _buildMemberOption(Members member) {
    return RadioListTile<Members>(
      value: member,
      groupValue: _selectedMember,
      onChanged: (value) => setState(() => _selectedMember = value),
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: CustomColors.copper_spice,
      title: Text(
        member.name ?? '—',
        style: const TextStyle(
          fontSize: 14,
          color: CustomColors.midnight_slate,
        ),
      ),
      subtitle: (member.email != null && member.email!.isNotEmpty)
          ? Text(
              member.email!,
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.midnight_slate.withOpacity(0.5),
              ),
            )
          : null,
    );
  }

  Widget _buildExternalAuthorForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nameController,
          onChanged: (_) => setState(() {}),
          style:
              const TextStyle(color: CustomColors.midnight_slate, fontSize: 14),
          decoration: adminInputDecoration(
            label: 'Nome',
            icon: Icons.person_outline_rounded,
            errorText: _showErrors && !_nameValid ? 'Campo obrigatório' : null,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          onChanged: (_) => setState(() {}),
          keyboardType: TextInputType.emailAddress,
          style:
              const TextStyle(color: CustomColors.midnight_slate, fontSize: 14),
          decoration: adminInputDecoration(
            label: 'E-mail (opcional)',
            icon: Icons.alternate_email_rounded,
            errorText:
                _showErrors && !_emailValid ? 'Informe um e-mail válido' : null,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _orcidController,
          onChanged: (_) => setState(() {}),
          style:
              const TextStyle(color: CustomColors.midnight_slate, fontSize: 14),
          decoration: adminInputDecoration(
            label: 'ORCID (opcional)',
            icon: Icons.badge_outlined,
            errorText: _showErrors && !_orcidValid
                ? 'Formato: 0000-0000-0000-0000'
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<ContributorRoles>(
      value: _selectedRole,
      isExpanded: true,
      // Altura fixa de menu; abre abaixo do campo em vez de cobri-lo/subir.
      menuMaxHeight: 240,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: CustomColors.midnight_slate),
      style: const TextStyle(
        color: CustomColors.midnight_slate,
        fontSize: 14,
      ),
      hint: Text(
        widget.availableRoles.isEmpty
            ? 'Carregando papéis...'
            : 'Papel na publicação',
        style: TextStyle(
          color: CustomColors.midnight_slate.withOpacity(0.45),
          fontSize: 14,
        ),
      ),
      items: widget.availableRoles
          .map(
            (role) => DropdownMenuItem<ContributorRoles>(
              value: role,
              child: Text(role.name ?? '—'),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedRole = value),
      decoration: adminInputDecoration(
        label: 'Papel na publicação',
        icon: Icons.workspace_premium_outlined,
        errorText: _showErrors && !_roleValid ? 'Campo obrigatório' : null,
      ),
    );
  }
}
