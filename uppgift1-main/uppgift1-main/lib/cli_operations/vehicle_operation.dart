import 'dart:io';
import 'package:uppgift1/models/car.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/models/vehicleType.dart';
import 'package:uppgift1/repositories/personRepository.dart';
import 'package:uppgift1/repositories/vehicleRepository.dart';

class VehicleOperation {
  static final VehicleRepository vehicleRepository = VehicleRepository.instance;
  static final PersonRepository personRepository = PersonRepository.instance;

  // Create a new vehicle
static Future<void> create() async {
  try {
    print("\nAnge registreringsnummer:");
    String? regNum = stdin.readLineSync()?.trim();
    if (regNum == null || regNum.isEmpty) {
      print("\n**Fel: Registreringsnummer får ej vara tomt!**");
      return;
    }

    print("\nAnge fordonstyp (1 = Bil, 2 = Lastbil, 3 = Motorcykel):");
    int? typeChoice = int.tryParse(stdin.readLineSync() ?? "");
    VehicleType? vehicleType;
    switch (typeChoice) {
      case 1:
        vehicleType = VehicleType.Bil;
        break;
      case 2:
        vehicleType = VehicleType.Lastbil;
        break;
      case 3:
        vehicleType = VehicleType.Motorcycle;
        break;
      default:
        print("\n**Fel: Ogiltig fordonstyp!**");
        return;
    }

    print("\nAnge ägarens ID:");
    int? ownerId = int.tryParse(stdin.readLineSync() ?? "");
    if (ownerId == null) {
      print("\n**Fel: ID måste vara ett nummer!**");
      return;
    }

    Person? owner = await personRepository.findById(ownerId);
    if (owner == null) {
      print("\n**Fel: Ägaren med ID $ownerId hittades ej!**");
      return;
    }

    print("\nAnge bilens färg:");
    String? color = stdin.readLineSync()?.trim();
    if (color == null || color.isEmpty) {
      print("\n**Fel: Färg får ej vara tom!**");
      return;
    }

    final vehicles = await vehicleRepository.findAll();
    final id = vehicles.isEmpty ? 1 : vehicles.last.id + 1;
    Vehicle vehicle = Car(
      id: id,
      registreringsNummer: regNum,
      typ: vehicleType,
      owner: owner,
      color: color,
    );
    print('Creating vehicle: $vehicle');
    final addedVehicle = await vehicleRepository.add(vehicle);
    print("\nFordonet har registrerats framgångsrikt: ${addedVehicle.registreringsNummer}");
    } catch (e) {
    print("\n**Fel: ${e.toString()}**");
  }
}
  static Future<void> list() async {
    try {
      final vehicles = await vehicleRepository.findAll();
      if (vehicles.isEmpty) {
        print("\nInga fordon hittades.");
      } else {
        print("\nLista över alla fordon:");
        for (var v in vehicles) {
          print("ID: ${v.id}, Reg.nr: ${v.registreringsNummer}, Typ: ${v.typ}, Ägare: ${v.owner.namn}, Färg: ${v is Car ? v.color : 'N/A'}");
        }
      }
    } catch (e) {
      print("\n**Fel: ${e.toString()}**");
    }
  }

  // Update a vehicle
  static Future<void> update() async {
    try {
      print("\nAnge fordonets ID som ska uppdateras:");
      int? id = int.tryParse(stdin.readLineSync() ?? "");
      if (id == null) {
        print("\n**Fel: Ogiltigt ID!**");
        return;
      }

      final vehicle = await vehicleRepository.findById(id);

      print("\nAnge nytt registreringsnummer:");
      String? regNum = stdin.readLineSync()?.trim();
      if (regNum != null && regNum.isNotEmpty) {
        vehicle.registreringsNummer = regNum;
      }

      print("\nAnge ny färg:");
      String? color = stdin.readLineSync()?.trim();
      if (color != null && color.isNotEmpty && vehicle is Car) {
        (vehicle).color = color;
      }

      await vehicleRepository.update(vehicle.id, vehicle);
      print("\nFordonet har uppdaterats framgångsrikt: ${vehicle.registreringsNummer}");

    } catch (e) {
      print("\n**Fel: ${e.toString()}**");
    }
  }

  // Delete a vehicle
  static Future<void> delete() async {
    try {
      print("\nAnge fordonets ID som ska raderas:");
      int? id = int.tryParse(stdin.readLineSync() ?? "");
      if (id == null) {
        print("\n**Fel: Ogiltigt ID!**");
        return;
      }

      await vehicleRepository.deleteById(id);
      print("\nFordonet med ID $id har raderats framgångsrikt.");
    } catch (e) {
      print("\n**Fel: ${e.toString()}**");
    }
  }
}