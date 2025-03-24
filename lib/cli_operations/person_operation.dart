import 'dart:io';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/repositories/personRepository.dart';

class PersonOperation {
  static final PersonRepository repository = PersonRepository.instance;

  // Add a new person
  static Future<void> create() async {
    try {
      stdout.write("\nAnge namn: ");
      String? namn = stdin.readLineSync()?.trim();
      if (namn == null || namn.isEmpty) {
        print("\n**Fel: Namn kan inte vara tomt!**");
        return;
      }

      stdout.write("\nAnge Personnummer (12 siffror): ");
      String? personnummerStr = stdin.readLineSync()?.trim();
      if (personnummerStr == null || personnummerStr.length != 12 || int.tryParse(personnummerStr) == null) {
        print("\n**Fel: Ange ett giltigt personnummer (12 siffror)!**");
        return;
      }

      int personNummer = int.parse(personnummerStr);
      final person = Person(namn: namn, personNummer: personNummer);
      await repository.add(person);
      print('\nPerson added: ${person.namn} with Personnummer: ${person.personNummer}');
    } catch (e) {
      print('\nError adding person: $e');
    }
  }

  // List all persons
  static Future<void> list() async {
    try {
      final persons = await repository.findAll();
      if (persons.isEmpty) {
        print('\nNo persons found.');
      } else {
        print('\nList of all persons:');
        for (var p in persons) {
          print('ID: ${p.id}, Name: ${p.namn}, SSN: ${p.personNummer}');
        }
      }
    } catch (e) {
      print('\nError fetching persons: $e');
    }
  }

  // Update a person
  static Future<void> update() async {
    try {
      stdout.write("\nAnge personens ID som du vill uppdatera: ");
      int? id = int.tryParse(stdin.readLineSync() ?? "");
      if (id == null) {
        print("\n**Fel: Ange ett giltigt ID!**");
        return;
      }

      final person = await repository.findById(id);
      if (person == null) {
        print("\nPerson with ID $id not found.");
        return;
      }

      stdout.write("Ange nytt namn (lämna tomt för att behålla nuvarande): ");
      String? nyttNamn = stdin.readLineSync()?.trim();

      stdout.write("Ange nytt Personnummer (lämna tomt för att behålla nuvarande): ");
      String? nyttPersonnummerStr = stdin.readLineSync()?.trim();
      int? nyttPersonnummer = (nyttPersonnummerStr != null && nyttPersonnummerStr.length == 12 && int.tryParse(nyttPersonnummerStr) != null)
          ? int.parse(nyttPersonnummerStr)
          : null;

      if (nyttNamn != null && nyttNamn.isNotEmpty) person.namn = nyttNamn;
      if (nyttPersonnummer != null) person.personNummer = nyttPersonnummer;

      await repository.update(person);
      print('\nPerson updated: ID ${person.id}, Name: ${person.namn}, SSN: ${person.personNummer}');
    } catch (e) {
      print('\nError updating person: $e');
    }
  }

  // Delete a person
  static Future<void> delete() async {
    try {
      stdout.write("\nAnge ID på personen du vill ta bort: ");
      int? deleteId = int.tryParse(stdin.readLineSync() ?? "");
      if (deleteId == null) {
        print("\n**Fel: Ange ett giltigt ID!**");
        return;
      }

      await repository.deleteById(deleteId);
      print('\nPerson with ID $deleteId deleted.');
    } catch (e) {
      print('\nError deleting person: $e');
    }
  }
}