import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/buttons/custom_button.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_mobile_page_scaffold.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_section_header.dart';
import 'package:rede_campo_online/core/ui/widgets/bottom_action_bar.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'admin_desktop_shell.dart';

/// Estrutura dos formulários do painel (nova/editar).
///
/// Desktop: barra lateral, caminho "Seção › título" e duas colunas. À
/// esquerda ficam os [mainFields]; à direita, o painel [publishTitle] com os
/// [publishFields] e os botões, seguido de um painel para cada item de
/// [sideFields]. Com pouca largura útil as colunas se empilham.
///
/// Mobile: cabeçalho em gradiente, todos os campos em uma coluna e barra de
/// ações fixa no rodapé.
class AdminFormScaffold extends StatelessWidget {
  const AdminFormScaffold({
    super.key,
    required this.sectionLabel,
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.mainFields,
    this.publishTitle = 'Publicação',
    this.publishFields = const [],
    this.sideFields = const [],
    required this.editing,
    required this.loading,
    required this.onSave,
    this.onDelete,
    this.postLabel = 'Publicar',
  });

  final String sectionLabel;
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final List<Widget> mainFields;
  final String publishTitle;
  final List<Widget> publishFields;
  final List<Widget> sideFields;
  final bool editing;
  final bool loading;
  final VoidCallback onSave;
  final VoidCallback? onDelete;
  final String postLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: _buildMobile(),
        child: _buildDesktop(),
      ),
    );
  }

  Widget _buildDesktop() {
    final mainPanel = _FormPanel(children: mainFields);
    final sideColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FormPanel(
          title: publishTitle,
          children: [
            ...publishFields,
            _DesktopActions(
              editing: editing,
              loading: loading,
              postLabel: postLabel,
              onSave: onSave,
              onDelete: onDelete,
            ),
          ],
        ),
        for (final field in sideFields) ...[
          const SizedBox(height: 16),
          _FormPanel(children: [field]),
        ],
      ],
    );

    return AdminDesktopShell(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(40, 32, 40, 48),
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Breadcrumb(
                  sectionLabel: sectionLabel,
                  current: title,
                  onSectionTap: onBack,
                ),
                const SizedBox(height: 10),
                Text(title, style: AdminHeaderStyles.title),
                const SizedBox(height: 8),
                Text(subtitle, style: AdminHeaderStyles.subtitle),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 760) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          mainPanel,
                          const SizedBox(height: 20),
                          sideColumn,
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: mainPanel),
                        const SizedBox(width: 20),
                        SizedBox(width: 340, child: sideColumn),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobile() {
    return AdminMobilePageScaffold(
      title: title,
      subtitle: subtitle,
      onBack: onBack,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _withSpacing(
                  [...mainFields, ...publishFields, ...sideFields],
                ),
              ),
            ),
          ),
          BottomActionBar(
            editing: editing,
            loading: loading,
            postLabel: postLabel,
            onSave: onSave,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

List<Widget> _withSpacing(List<Widget> fields) {
  return [
    for (var i = 0; i < fields.length; i++) ...[
      if (i > 0) const SizedBox(height: 16),
      fields[i],
    ],
  ];
}

/// "Notícias › Nova notícia": a seção é um link de volta para a listagem.
class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({
    required this.sectionLabel,
    required this.current,
    required this.onSectionTap,
  });

  final String sectionLabel;
  final String current;
  final VoidCallback onSectionTap;

  @override
  Widget build(BuildContext context) {
    final muted = CustomColors.midnight_slate.withOpacity(0.75);

    return Row(
      children: [
        TextButton(
          onPressed: onSectionTap,
          style: TextButton.styleFrom(
            foregroundColor: CustomColors.pine_shadow,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: const Size(0, 32),
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Text(sectionLabel),
        ),
        Icon(Icons.chevron_right_rounded, size: 18, color: muted),
        const SizedBox(width: 4),
        Text(current, style: TextStyle(fontSize: 13, color: muted)),
      ],
    );
  }
}

/// Painel branco que agrupa campos no desktop.
class _FormPanel extends StatelessWidget {
  const _FormPanel({required this.children, this.title});

  final List<Widget> children;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final heading = title;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CustomColors.soft_border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (heading != null) ...[
            Text(
              heading.toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: CustomColors.midnight_slate.withOpacity(0.75),
              ),
            ),
            const SizedBox(height: 14),
          ],
          ..._withSpacing(children),
        ],
      ),
    );
  }
}

/// Botões do painel de publicação: salvar/publicar e, na edição, apagar.
class _DesktopActions extends StatelessWidget {
  const _DesktopActions({
    required this.editing,
    required this.loading,
    required this.postLabel,
    required this.onSave,
    required this.onDelete,
  });

  final bool editing;
  final bool loading;
  final String postLabel;
  final VoidCallback onSave;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 48,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: CustomColors.copper_spice,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomButton(
          width: double.infinity,
          height: 48,
          elevation: 0,
          color: CustomColors.copper_spice,
          text: editing ? 'Salvar alterações' : postLabel,
          textColor: Colors.white,
          borderRadius: 10,
          fontWeight: FontWeight.w700,
          function: onSave,
        ),
        if (editing && onDelete != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
            label: const Text('Apagar'),
            style: TextButton.styleFrom(
              foregroundColor: CustomColors.danger_red,
              minimumSize: const Size(0, 44),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
