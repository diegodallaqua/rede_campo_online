/// Erro devolvido pela API (`{status, message}`).
class ErrorsAPI {
  final String status;
  final String message;

  const ErrorsAPI({required this.status, required this.message});

  factory ErrorsAPI.fromMap(Map<String, dynamic> json) => ErrorsAPI(
        status: '${json['status'] ?? ''}',
        message: '${json['message'] ?? ''}',
      );

  Map<String, dynamic> toMap() => {'status': status, 'message': message};

  @override
  String toString() => message;
}
