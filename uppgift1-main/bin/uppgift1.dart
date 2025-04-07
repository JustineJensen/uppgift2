import 'dart:io';
import 'package:uppgift1/cli_operations/parking_operation.dart';
import 'package:uppgift1/cli_operations/parkingspace_operation.dart';

import 'package:uppgift1/cli_operations/person_operation.dart';
import 'package:uppgift1/cli_operations/vehicle_operation.dart';
import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/repositories/parkingRepository.dart';
import 'package:uppgift1/repositories/parkingSpaceRepository.dart';
import 'package:uppgift1/repositories/personRepository.dart';
import 'package:uppgift1/repositories/vehicleRepository.dart';
  
Future <void> main() async {
  var personRepo = PersonRepository.instance;
  var vehicleRepo = VehicleRepository.instance;
  var parkingSpaceRepo = ParkingSpaceRepository.instance;
  var parkingRepo = ParkingRepository.instance;

  while(true){
     print('**** Välkommen till Parkeringsappen! ****');
     print('Vad vill du hantera? ');
     print("1. Personer");
     print("2. Fordon");
     print("3. Parkeringsplatser");
     print("4. Parkeringar");
     print("5. Avsluta");
     stdout.write("Välj ett alternativ (1-5): ");
      
    String? choice = stdin.readLineSync();
     switch(choice){
      case "1":
      await handlePerson();
      break;
      case "2":
      await handleVehicles();
      break;
      case "3":
      await handleParkingPlaces();
      break;
      case "4":
      await handleParking(parkingRepo, vehicleRepo, parkingSpaceRepo);
      break;
      case "5":
      print("\n Avslutar programmet");
      exit(0);
      default:
      print("\nOgiltigt val! ");
     }
  }
}

Future<void> handlePerson() async {
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
        await PersonOperation.create();
        break;
      case "2":
        await PersonOperation.list();
        break;
      case "3":
        await PersonOperation.update();
        break;
      case "4":
        await PersonOperation.delete();
        break;
      case "5":
        print("\nTillbaka till huvudmenyn...");
        return;
      default:
        print("\nOgiltigt val, försök igen.");
    }
  }
}

Future<void> handleVehicles() async {
  while (true) {
    print("*****************************************");
    print("\nDu har valt att hantera Fordon. Vad vill du göra?");
    print("*****************************************");
    print("1. Registrera nytt fordon");
    print("2. Visa alla fordon");
    print("3. Uppdatera fordon");
    print("4. Ta bort fordon");
    print("5. Tillbaka till huvudmenyn");
    print("*****************************************");
    stdout.write("Välj ett alternativ (1-5): ");

    String? choice = stdin.readLineSync();
    switch (choice) {
      case "1":
        await VehicleOperation.create();
        break;
      case "2":
        await VehicleOperation.list();
        break;
      case "3":
        await VehicleOperation.update();
        break;
      case "4":
        await VehicleOperation.delete();
        break;
      case "5":
        print("\nTillbaka till huvudmenyn...");
        return;
      default:
        print("\n**Ogiltigt val, försök igen.**");
    }
  }
}

Future<void> handleParkingPlaces() async {
  while (true) {
    print("*****************************************");
    print("\nDu har valt att hantera Parkeringsplatser. Vad vill du göra?");
    print("*****************************************");
    print("1. Lägg till en ny parkeringsplats");
    print("2. Visa alla parkeringsplatser");
    print("3. Uppdatera en parkeringsplats");
    print("4. Ta bort en parkeringsplats");
    print("5. Tillbaka till huvudmenyn");
    print("*****************************************");
    stdout.write("Välj ett alternativ (1-5): ");

    String? choice = stdin.readLineSync();
    switch (choice) {
      case "1":
        await ParkingSpaceOperation.create();
        break;
      case "2":
        await ParkingSpaceOperation.list();
        break;
      case "3":
        await ParkingSpaceOperation.update();
        break;
      case "4":
        await ParkingSpaceOperation.delete();
        break;
      case "5":
        return;
      default:
        print("\nOgiltigt val, försök igen.");
    }
  }
}

Future<void> handleParking(
  ParkingRepository parkingRepo,
  VehicleRepository vehicleRepo,
  ParkingSpaceRepository parkingSpaceRepo,
) async {
  final parkingOperation = ParkingOperation();

  while (true) {
    print("\n*****************************************");
    print(" Du har valt att hantera Parkeringar. Vad vill du göra?");
    print("*****************************************");
    print(" 1. Skapa ny parkering");
    print(" 2. Visa alla parkeringar");
    print(" 3. Ta bort parkering");
    print(" 4. Beräkna kostnad för parkeringen");
    print(" 5. Uppdatera parkering");
    print(" 6. Tillbaka till huvudmenyn");
    print("*****************************************");

    stdout.write(" Välj ett alternativ (1-6): ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case "1":
        await ParkingOperation.create(vehicleRepo: vehicleRepo, parkingSpaceRepo: parkingSpaceRepo);
        break;
      case "2":
        await ParkingOperation.list();
        break;
      case "3":
        await ParkingOperation.delete();
        break;
      case "4":
        await ParkingOperation.calculateParkingCost();
        break;
      case "5":
        await ParkingOperation.update(parkingSpaceRepo: parkingSpaceRepo);
        break;
      case "6":
        print("\n Återgår till huvudmenyn...");
        return;
      default:
        print("\n Ogiltigt val, försök igen.");
    }
  }
}
