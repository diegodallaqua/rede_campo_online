import '../../../features/members/models/members.dart';
import '../../../features/publications/models/publications.dart';
import 'contributor_roles.dart';
import 'external_author.dart';

class Contributors {
  Contributors({
    this.id,
    this.publication,
    this.member,
    this.contributor_role,
    this.external_author,
    this.order,
  });

  int? id;
  Publications? publication;
  Members? member;
  ContributorRoles? contributor_role;
  ExternalAuthors? external_author;
  int? order;

  @override
  String toString() {
    return 'Contributors{id: $id, publication: $publication, member: $member, contributor_role: $contributor_role, external_author: $external_author, order: $order}';
  }

  factory Contributors.fromMap(Map<String, dynamic> map) {
    return Contributors(
      id: map['id'],
      publication: map.containsKey('publication') && map['publication'] != null
          ? Publications.fromMap(map['publication'] ?? {})
          : null,
      member: map.containsKey('member') && map['member'] != null
          ? Members.fromMap(map['member'] ?? {})
          : null,
      contributor_role:
          map.containsKey('contributor_role') && map['contributor_role'] != null
              ? ContributorRoles.fromMap(map['contributor_role'] ?? {})
              : null,
      external_author:
          map.containsKey('external_author') && map['external_author'] != null
              ? ExternalAuthors.fromMap(map['external_author'] ?? {})
              : null,
      order: (map['author_order'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() => {
        'publication_id': publication?.id,
        'member_id': member?.id,
        'contributor_role_id': contributor_role?.id,
        'external_author_id': external_author?.id,
        'author_order': order,
      };
}
