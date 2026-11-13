/// Erro devolvido pela API (`{status, message}`).
class ErrorsAPI {
  final String status;
  final String message;

  const ErrorsAPI({required this.status, required this.message});

  factory ErrorsAPI.fromMap(Map<String, dynamic> json) {
    final message = json['message'];
    return ErrorsAPI(
      status: '${json['status'] ?? json['statusCode'] ?? ''}',
      // Validações podem vir como lista de mensagens.
      message: message is List ? message.join('\n') : '${message ?? ''}',
    );
  }

  Map<String, dynamic> toMap() => {'status': status, 'message': message};

  @override
  String toString() => message;
}

/// Mensagem da API ou da falha de rede; senão [fallback].
String errorMessageOf(Object error, String fallback) {
  if (error is ErrorsAPI && error.message.trim().isNotEmpty) {
    return error.message;
  }
  if (error is String && error.trim().isNotEmpty) return error;
  return fallback;
}
