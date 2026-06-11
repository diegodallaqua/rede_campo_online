import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';

/// Decide entre os estados de carregamento, erro, vazio e conteúdo de uma
/// listagem, centralizando o encadeamento repetido em todas as listas do
/// painel administrativo. O [builder] só é chamado quando há itens.
class ListStatusBuilder extends StatelessWidget {
  const ListStatusBuilder({
    super.key,
    required this.loading,
    required this.error,
    required this.isEmpty,
    required this.emptyMessage,
    required this.onRetry,
    required this.builder,
  });

  final bool loading;
  final String? error;
  final bool isEmpty;
  final String emptyMessage;
  final VoidCallback onRetry;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: ListLoadingState());
    }
    if (error != null && isEmpty) {
      return Center(
        child: ListErrorState(message: error!, onRetry: onRetry),
      );
    }
    if (isEmpty) {
      return Center(child: ListEmptyState(message: emptyMessage));
    }
    return builder(context);
  }
}
