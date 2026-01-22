class User {
  final String username;
  final String? password;
  final String? email;
  final int xp;
  final int level;
  final int character;
  final DateTime joinDate;
  final int status;

  const User({
    required this.username,
    this.password,
    this.email,
    required this.xp,
    required this.level,
    required this.character,
    required this.joinDate,
    required this.status,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      password: map['password'] as String?,
      email: map['email'] as String?,
      xp: map['xp'] as int,
      level: map['level'] as int,
      character: map['character'] as int,
      joinDate: DateTime.parse(map['join_date'] as String),
      status: map['status'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'xp': xp,
      'level': level,
      'character': character,
      'join_date': joinDate.toIso8601String(),
      'status': status,
    };
  }

  User copyWith({
    String? username,
    String? password,
    String? email,
    int? xp,
    int? level,
    int? character,
    DateTime? joinDate,
    int? status,
  }) {
    return User(
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      character: character ?? this.character,
      joinDate: joinDate ?? this.joinDate,
      status: status ?? this.status,
    );
  }
}