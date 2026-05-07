import '../../../core/utils/models/member_roles.dart';
import '../../../core/utils/models/organizations.dart';

class Members {
  Members({
    this.id,
    this.memberRole,
    this.organization,
    this.name,
    this.email,
    this.description,
    this.lattesUrl,
    this.linkedInUrl,
    this.profilePicture,
    this.password,
  });

  String? id;
  MemberRoles? memberRole;
  Organizations? organization;
  String? name;
  String? email;
  String? description;
  String? lattesUrl;
  String? linkedInUrl;
  String? profilePicture;
  String? password;

  @override
  String toString() {
    return 'Members{'
        'id: $id, '
        'memberRole: $memberRole, '
        'organization: $organization, '
        'name: $name, '
        'email: $email, '
        'description: $description, '
        'lattesUrl: $lattesUrl, '
        'linkedInUrl: $linkedInUrl, '
        'profilePicture: $profilePicture'
        '}';
  }

  factory Members.fromMap(Map<String, dynamic> map) {
    return Members(
      id: map['id'],
      memberRole: map.containsKey('member_role') && map['member_role'] != null ? MemberRoles.fromMap(map['member_role'] ?? {}) : null,
      organization: map.containsKey('organization') && map['organization'] != null ? Organizations.fromMap(map['organization'] ?? {}) : null,
      name: (map['name'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      lattesUrl: (map['lattes_url'] ?? '') as String,
      linkedInUrl: (map['linked_in_url'] ?? '') as String,
      profilePicture: (map['profile_picture'] ?? '') as String,
      password: map.containsKey('password') ? map['password'] as String? : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'member_role_id': memberRole?.id,
    'organization_id': organization?.id,
    'name': name!,
    'email': email!,
    'description': description,
    'lattes_url': lattesUrl,
    'linked_in_url': linkedInUrl,
    'profile_picture': profilePicture,
  };
}