import 'member_roles.dart';
import 'organizations.dart';

class AuthUser {
  final int? id;
  final String? name;
  final String? email;
  final MemberRoles? memberRole;
  final Organizations? organization;

  AuthUser({
    this.id,
    this.name,
    this.email,
    this.memberRole,
    this.organization,
  });

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      memberRole: map.containsKey('memberRole') && map['memberRole'] != null ? MemberRoles.fromMap(map['memberRole'] ?? {}) : null,
      organization: map.containsKey('organization') && map['organization'] != null ? Organizations.fromMap(map['organization'] ?? {}) : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    if (memberRole != null) 'memberRole': memberRole!.toMap(),
    if (organization != null) 'organization': organization!.toMap(),
  };

  @override
  String toString() => 'AuthUser(id: $id, name: $name, email: $email, role: ${memberRole?.name})';
}

class AuthResponse {
  final String? token;
  final AuthUser? user;

  AuthResponse({this.token, this.user});

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      token: map['token'] ?? '',
      user: map.containsKey('user') && map['user'] != null ? AuthUser.fromMap(map['user'] ?? {}) : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'token': token,
    if (user != null) 'user': user!.toMap(),
  };

  @override
  String toString() => 'AuthResponse(user: $user)';
}