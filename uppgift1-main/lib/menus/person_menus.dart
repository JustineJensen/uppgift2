import 'dart:io';

import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/repositories/personRepository.dart';

class PersonMenu{
  static Future prompt() async{
    void handlePerson(PersonRepository personRepo) {
  while (true) {
    print("*****************************************");
    print("\n** Du har valt att hantera Personer. Vad vill du göra **");
    print("*****************************************");
    print("1. Skapa ny person");
    print("2. Visa alla personer");
    print("3. Uppdatera person");
    print("4. Ta bort person");
    print("5. Tillbaka till huvudmenyn");
    print("*****************************************");
    stdout.write("Välj ett alternativ (1-5): ");

    String? choice = stdin.readLineSync();
    switch (choice) {
      case "1":
        stdout.write("\n Ange namn: ");
        String? namn = stdin.readLineSync();
        if (namn == null || namn.isEmpty) {
          print("\n **Fel: Namn kan inte vara tomt!**");
          continue;
        }
        stdout.write("\n Ange Personnummer (12 siffror): ");
        String? personnummerStr = stdin.readLineSync();
        if (personnummerStr == null || personnummerStr.length != 12 || int.tryParse(personnummerStr) == null) {
          print("\n **Fel: Ange ett giltigt personnummer (12 siffror)!**");
          continue;
        }

       int personNummer = int.parse(personnummerStr);
        try {
          Person newPerson = Person(
            namn: namn, 
            personNummer: personNummer
          );

          personRepo.add(newPerson); 
          print("\nPerson skapad framgångsrikt!");
        } catch (e) {
          print("\nFel: ${e.toString()}");
        }

        break;

      case "2":
        final persons = personRepo.findAll();
        if (persons.isEmpty) {
          print("\n**Inga personer hittades**");
        } else {
          persons.forEach((p) => print("ID: ${p.id}, Namn: ${p.namn}, PersonNummer: ${p.personNummer}"));
        }
        break;

      case "3":
  stdout.write("\n Ange personens ID som du vill uppdatera: ");
  int? id = int.tryParse(stdin.readLineSync() ?? "");
  if (id == null) {
    print("\n **Fel: Ange ett giltigt ID!**");
    break;
  }

  try {
    Person person = personRepo.findById(id);
  
    print("\nPerson found: ID: ${person.id}, Namn: ${person.namn}, PersonNummer: ${person.personNummer}");

    stdout.write("Ange nytt namn: ");
    String newName = stdin.readLineSync() ?? person.namn;

    stdout.write("Ange nytt Personnummer: ");
    String? newPersonnummerStr = stdin.readLineSync();
    
    int newPersonnummer = (newPersonnummerStr != null && newPersonnummerStr.length == 12 && int.tryParse(newPersonnummerStr) != null)
        ? int.parse(newPersonnummerStr)
        : person.personNummer;
    personRepo.update(Person(
      namn: newName,
      personNummer: newPersonnummer,
      id: person.id, 
    ));

    print("\n **Person uppdaterad framgångsrikt!**");
  } catch (e) {
    print("\n Fel: ${e.toString()}");
  }
  break;

      case "4":
        stdout.write("\n Ange ID på personen du vill ta bort: ");
        int? deleteId = int.tryParse(stdin.readLineSync() ?? "");
        if (deleteId == null) {
          print("\n **Fel: Ange ett giltigt ID!**");
          break;
        }

        try {
          personRepo.deleteById(deleteId);
          print("\n **Person borttagen framgångsrikt!**");
        } catch (e) {
          print("\n Fel: ${e.toString()}");
        }
        break;

      case "5":
        print("\nTillbaka till huvudmenyn...");
        return;

      default:
        print("\n Ogiltigt val, försök igen.");
    }
  }
}
  }
}