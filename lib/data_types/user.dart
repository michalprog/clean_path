class User {
  final String username;
  final String? password;
  final String? email;
  final int xp;
  final int level;
  final int character;
  final int streak;
  final DateTime joinDate;
  final DateTime lastSeen;
  final int status;

  const User({
    required this.username,
    this.password,
    this.email,
    required this.xp,
    required this.level,
    required this.character,
    required this.streak,
    required this.joinDate,
    required this.lastSeen,
    required this.status,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    final lastSeenRaw = map['last_seen'] as String?;
    final lastSeen = (lastSeenRaw == null || lastSeenRaw.isEmpty)
        ? DateTime.now()
        : DateTime.parse(lastSeenRaw);
    return User(
      username: map['username'] as String,
      password: map['password'] as String?,
      email: map['email'] as String?,
      xp: map['xp'] as int,
      level: map['level'] as int,
      character: map['character'] as int,
      streak: map['streak'] as int? ?? 0,
      joinDate: DateTime.parse(map['join_date'] as String),
      lastSeen: lastSeen,
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
      'streak': streak,
      'join_date': joinDate.toIso8601String(),
      'last_seen': lastSeen.toIso8601String(),
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
    int? streak,
    DateTime? joinDate,
    DateTime? lastSeen,
    int? status,
  }) {
    return User(
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      character: character ?? this.character,
      streak: streak ?? this.streak,
      joinDate: joinDate ?? this.joinDate,
      lastSeen: lastSeen ?? this.lastSeen,
      status: status ?? this.status,
    );
  }
}