import 'dart:io';

import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift1/repositories/parkingSpaceRepository.dart';

class ParkingSpaceOperation {
  static ParkingSpaceRepository repository = ParkingSpaceRepository.instance;

   
  static Future<void> create() async {
    try {
      stdout.write("\nAnge platsens adress: ");
      String? adress = stdin.readLineSync()?.trim();

      if (adress == null || adress.isEmpty) {
        print("\nFel: Adress kan inte vara tomt!");
        return;
      }

      stdout.write("\nAnge pris per timme: ");
      double? pricePerHour = double.tryParse(stdin.readLineSync() ?? "");

      if (pricePerHour == null) {
        print("\nFel: Ogiltigt pris per timme!");
        return;
      }
      int newId = await repository.getNextId();

      final parkingSpace = ParkingSpace(
        id: newId,
        adress: adress,
        pricePerHour: pricePerHour,
      );

      await repository.add(parkingSpace);
      print("\nParking space added: ${parkingSpace.adress} with price ${parkingSpace.pricePerHour}");
    } catch (e) {
      print("\nError adding parking space: ${e.toString()}");
    }
  }
  

  static Future<void> list() async {
    try {
      final parkingSpaces = await repository.findAll();
      if (parkingSpaces.isEmpty) {
        print("\nInga parkeringsplatser hittades.");
      } else {
        parkingSpaces.forEach((space) => print(space));
      }
    } catch (e) {
      print("\nFel: ${e.toString()}");
    }
  }

  static Future<void> update() async {
    stdout.write("\nAnge ID för parkeringsplatsen att uppdatera: ");
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null) {
      print("\nFel: Ogiltigt ID!");
      return;
    }

    try {
      final existingSpace = await repository.findById(id);
      print("Found parking space: ${existingSpace.toJson()}");  

      if (existingSpace == null) {
        print("\nParkeringsplats med ID $id hittades inte.");
        return;
      }
      stdout.write("\nAnge ny adress (lämna tomt för att behålla nuvarande): ");
      String? newAdress = stdin.readLineSync();

      stdout.write("\nAnge nytt pris per timme (lämna tomt för att behålla nuvarande): ");
      double? newPricePerHour = double.tryParse(stdin.readLineSync() ?? "");

      if (newPricePerHour == null) {
        print("\nFel: Ogiltigt pris per timme!");
        return;
      }
      final updatedSpace = ParkingSpace(
        id: existingSpace.id,
        adress: newAdress?.isEmpty ?? false ? existingSpace.adress : newAdress!,
        pricePerHour: newPricePerHour,
      );
      print("Updating parking space: ${updatedSpace.toJson()}");
      await repository.update(updatedSpace);
      print("\nParkeringsplats uppdaterad framgångsrikt!");

    } catch (e) {
      print("\nFel: ${e.toString()}");
    }
  }


   static Future<void> delete() async {
    stdout.write("\nAnge ID för parkeringsplatsen att ta bort: ");
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null) {
      print("\nFel: Ogiltigt ID!");
      return;
    }

    try {
      await repository.deleteById(id);
      print("\nParkeringsplats borttagen framgångsrikt!");
    } catch (e) {
      print("\nFel: ${e.toString()}");
    }
  }
}