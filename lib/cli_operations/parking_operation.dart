import 'dart:io';
import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/repositories/parkingRepository.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/repositories/vehicleRepository.dart';
import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift1/repositories/parkingSpaceRepository.dart';

class ParkingOperation {
  static ParkingRepository repository = ParkingRepository.instance;

  static Future<void> create({
  required VehicleRepository vehicleRepo,
  required ParkingSpaceRepository parkingSpaceRepo,
}) async {
  try {
    print("\nTillgängliga parkeringsplatser:");
    final spaces = await parkingSpaceRepo.findAll();
    spaces.forEach((space) => print("ID: ${space.id}, Adress: ${space.adress}"));
    stdout.write("\nAnge parkeringsplatsens ID: ");
    final parkingSpaceId = int.tryParse(stdin.readLineSync() ?? "");
    if (parkingSpaceId == null) {
      print("\nFel: Ogiltigt ID!");
      return;
    }
    final parkingSpace = await parkingSpaceRepo.findById(parkingSpaceId);
    print("Hittade parkeringsplats: ${parkingSpace.adress}");
    stdout.write("\nAnge registreringsnummer för fordonet: ");
    final regNum = stdin.readLineSync()?.trim();
    if (regNum == null || regNum.isEmpty) {
      print("\nFel: Registreringsnummer måste anges!");
      return;
    }
    final vehicle = await vehicleRepo.getVehicleByRegNum(regNum);
    if (vehicle == null) {
      print("\nFel: Fordonet med registreringsnummer $regNum hittades inte!");
      return;
    }
    stdout.write("\nAnge starttid (YYYY-MM-DD HH:MM): ");
    final startTimeInput = stdin.readLineSync()?.trim();
    if (startTimeInput == null || startTimeInput.isEmpty) {
      print("\nFel: Starttid måste anges!");
      return;
    }
    final parking = Parking(
      id: await repository.getNextId(),
      fordon: vehicle,
      parkingSpace: parkingSpace,
      startTime: DateTime.parse(startTimeInput),
    );
    await repository.add(parking);
    print("\nParkering skapad framgångsrikt!");
    print("Skapad parkering: ${parking.toString()}");
  } catch (e) {
    print("\nFel vid skapande av parkering: ${e.toString()}");
  }
}

  static Future<void> list() async {
    try {
      final parkings = await repository.findAll();
      if (parkings.isEmpty) {
        print("\nInga parkeringar hittades.");
      } else {
        parkings.forEach((parking) => print(parking));
      }
    } catch (e) {
      print("\nFel: ${e.toString()}");
    }
  }

  static Future<void> update({
    required ParkingSpaceRepository parkingSpaceRepo,
  }) async {
    stdout.write("\nAnge ID för parkeringen att uppdatera: ");
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null) {
      print("\nFel: Ogiltigt ID!");
      return;
    }

    try {
      final existingParking = await repository.findById(id);
      if (existingParking == null) {
        print("\nParkering med ID $id hittades inte.");
        return;
      }
      stdout.write("\nAnge nytt parkeringsplats ID (lämna tomt för att behålla nuvarande): ");
      String? newParkingSpaceIdInput = stdin.readLineSync();
      int? newParkingSpaceId = newParkingSpaceIdInput != null && newParkingSpaceIdInput.isNotEmpty
          ? int.tryParse(newParkingSpaceIdInput)
          : null;

      ParkingSpace? newParkingSpace;
      if (newParkingSpaceId != null) {
        newParkingSpace = await parkingSpaceRepo.findById(newParkingSpaceId);
      }
      final updatedParking = Parking(
        id: existingParking.id,
        fordon: existingParking.fordon,
        parkingSpace: newParkingSpace ?? existingParking.parkingSpace,
        startTime: existingParking.startTime,
        endTime: existingParking.endTime,
      );
      await repository.update(updatedParking);
      print("\nParkering uppdaterad framgångsrikt!");
    } catch (e) {
      print("\nFel: ${e.toString()}");
    }
  }

  static Future<void> delete() async {
    stdout.write("\nAnge ID för parkeringen att ta bort: ");
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null) {
      print("\nFel: Ogiltigt ID!");
      return;
    }

    try {
      await repository.deleteById(id);
      print("\nParkering borttagen framgångsrikt!");
    } catch (e) {
      print("\nFel: ${e.toString()}");
    }
  }
  static Future<void> calculateParkingCost() async {
  stdout.write("\nAnge ID för parkeringen att beräkna kostnaden: ");
  int? parkingId = int.tryParse(stdin.readLineSync() ?? "");

  if (parkingId == null) {
    print("\nFel: Ogiltigt ID!");
    return;
  }

  try {
    Parking parking = await repository.findById(parkingId);
    stdout.write("\nAnge sluttid (YYYY-MM-DD HH:MM): ");
    String? endTimeInput = stdin.readLineSync();

    if (endTimeInput == null) {
      print("\nFel: Sluttid måste anges!");
      return;
    }

    DateTime endTime = DateTime.parse(endTimeInput);
    Duration duration = endTime.difference(parking.startTime);

    double ratePerHour = parking.parkingSpace.pricePerHour ?? 0.0; 
    double totalCost = (duration.inMinutes / 60) * ratePerHour;
    print("\nParkeringen har varat i ${duration.inHours} timmar och ${duration.inMinutes % 60} minuter.");
    print("Totalkostnad: ${totalCost.toStringAsFixed(2)} SEK");
  } catch (e) {
    print("\nFel: ${e.toString()}");
  }
}
}