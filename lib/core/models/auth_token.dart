import '../../features/members/models/members.dart';

class AuthResponse {
  final String? token;
  final Members? user;

  AuthResponse({this.token, this.user});

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      token: map['token'] ?? '',
      user: map.containsKey('user') && map['user'] != null
          ? Members.fromMap(map['user'] ?? {})
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'token': token,
        if (user != null) 'user': user!.toMap(),
      };

  @override
  String toString() => 'AuthResponse(user: $user)';
}
