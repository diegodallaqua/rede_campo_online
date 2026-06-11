import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

const _errorColor = Color(0xFFCF1322);
const _borderColor = Color(0xFFE2E2DC);

/// Bloco de formulário composto: rótulo à esquerda e ação (TextButton com
/// ícone) à direita, seguidos do conteúdo do campo. Padrão usado pelos campos
/// de áreas de pesquisa, contribuidores, uploads e seletores de entidade.
class FormFieldShell extends StatelessWidget {
  const FormFieldShell({
    super.key,
    required this.label,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
    required this.child,
  });

  final String label;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback onAction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CustomColors.midnight_slate,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: onAction,
              icon: Icon(actionIcon, size: 18),
              label: Text(actionLabel),
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
        child,
      ],
    );
  }
}

/// Caixa de estado vazio de um campo composto: ícone e mensagem centralizados
/// dentro de um contêiner com borda. [hasError] tinge a borda de vermelho.
class FormFieldEmptyState extends StatelessWidget {
  const FormFieldEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.hasError = false,
  });

  final IconData icon;
  final String message;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasError ? _errorColor : _borderColor,
          width: hasError ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: CustomColors.midnight_slate.withOpacity(0.25),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: TextStyle(
              fontSize: 13,
              color: CustomColors.midnight_slate.withOpacity(0.45),
            ),
          ),
        ],
      ),
    );
  }
}

/// Contêiner com borda usado para o conteúdo preenchido de um campo composto.
class FormFieldContentBox extends StatelessWidget {
  const FormFieldContentBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.color,
    this.borderColor = _borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? CustomColors.vanilla_haze.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

/// Mensagem de erro exibida abaixo de campos que não usam a decoração
/// padrão do Material para erros.
class FieldErrorText extends StatelessWidget {
  const FieldErrorText({
    super.key,
    required this.message,
    this.topSpacing = 6,
  });

  final String message;
  final double topSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12, top: topSpacing),
      child: Text(
        message,
        style: const TextStyle(color: _errorColor, fontSize: 12),
      ),
    );
  }
}
