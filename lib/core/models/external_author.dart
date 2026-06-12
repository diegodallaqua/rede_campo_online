class ExternalAuthors {
  ExternalAuthors({this.id, this.name, this.email, this.orcid});

  int? id;
  String? name;
  String? email;
  String? orcid;

  @override
  String toString() {
    return 'ExternalAuthors{id: $id, name: $name, email: $email, orcid: $orcid}';
  }

  factory ExternalAuthors.fromMap(Map<String, dynamic> map) {
    return ExternalAuthors(
      id: map['id'],
      name: (map['name'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      orcid: (map['orcid'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'orcid': orcid,
      };
}
