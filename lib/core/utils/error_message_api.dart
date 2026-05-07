class ErrorsAPI {
  String status;
  String message;

  ErrorsAPI({
    required this.status,
    required this.message,
  });

  @override
  String toString() {
    return '$message';
  }

  factory ErrorsAPI.fromMap(Map<String, dynamic> json) => (ErrorsAPI(
    status: json["status"] ?? "",
    message: json["message"] ?? "",
  ));

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
  };

  map(Function(dynamic e) param0) {}
}
