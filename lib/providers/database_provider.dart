import 'package:flutter/material.dart';
import '../enums/enums.dart';
import '../sqlflite/sql_class.dart';
import '/data_types/record.dart';

class DatabaseProvider extends ChangeNotifier{
  final SqlClass _sqlClass = SqlClass.instance;

  List<Record> _records = [];
  List<Record> get records => _records;

  Future<void> loadAllRecords() async {
    _records = await _sqlClass.getAllRecords();
    notifyListeners();
  }

// Funkcja tworząca nowy rekord z wymaganym typem (void - bez zwracania ID)
  Future<void> createNewRecord(addictionTypes type) async {
    // Tworzymy aktualną datę
    final DateTime now = DateTime.now();

    // Tworzymy nowy rekord - id=0 zostanie zastąpione przez autoinkrementację w bazie
    final Record newRecord = Record(
      0,
      type,
      true, // rekord jest aktywny
      now, // przechowujemy DateTime
    );

    // Dodajemy rekord do bazy danych
    await _sqlClass.insertRecord(newRecord);

    // Odświeżamy listę rekordów
    await loadAllRecords();
  }

}