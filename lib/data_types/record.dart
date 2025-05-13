import '../enums/enums.dart';

class Record {
  final int id;
  final AddictionTypes type;
  final bool isActive;
  final DateTime activated;
  DateTime? desactivated;

  Record(
    this.id,
    this.type,
    this.isActive,
    this.activated, {
    this.desactivated,
  });

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      map['id'] as int,
      AddictionTypes.values[map['type'] as int],
      map['is_active'] == 1,
      DateTime.parse(map['activated'] as String),
      desactivated:
          map['desactivated'] != null
              ? DateTime.parse(map['desactivated'] as String)
              : null,
    );
  }
  Map<String, dynamic> toMapForInsert() {
    return {
      'type': type.index,
      'is_active': isActive ? 1 : 0,
      'activated': activated.toIso8601String(),
      'desactivated': desactivated?.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'is_active': isActive ? 1 : 0,
      'activeted': activated.toIso8601String(),
      'desactivated': desactivated?.toIso8601String(),
    };
  }
}
