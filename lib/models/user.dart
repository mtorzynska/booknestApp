import 'dart:convert';

class User {
  final String username;
  final String email;
  final String uid;
  User({
    required this.username,
    required this.email,
    required this.uid,
  });

  User copyWith({
    String? username,
    String? email,
    String? uid,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'uid': uid,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      email: map['email'] as String,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(username: $username, email: $email, uid: $uid)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.email == email &&
        other.uid == uid;
  }

  @override
  int get hashCode => username.hashCode ^ email.hashCode ^ uid.hashCode;
}
