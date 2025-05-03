

import '../enums/enums.dart';

class Record {
  final int id;
  final addictionTypes type;
  final bool isActive;
  final DateTime activated;
  DateTime? desactivated;

  // Using positional parameters to match your original constructor
  Record(this.id, this.type, this.isActive, this.activated, {this.desactivated});

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      map['id'] as int,
      addictionTypes.values[map['type'] as int],
      map['is_active'] == 1, // Convert integer to boolean
      DateTime.parse(map['activeted'] as String),
      desactivated: map['desactivated'] != null
          ? DateTime.parse(map['desactivated'] as String)
          : null,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index, // Convert enum to integer
      'is_active': isActive ? 1 : 0, // Convert boolean to integer
      'activeted': activated.toIso8601String(),
      'desactivated': desactivated?.toIso8601String(),
    };
  }
}