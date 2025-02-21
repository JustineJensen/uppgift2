import 'dart:io';

import 'package:uppgift1/models/car.dart';
import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/models/vehicleType.dart';
import 'package:uppgift1/repositories/parkingRepository.dart';
import 'package:uppgift1/repositories/parkingSpaceRepository.dart';
import 'package:uppgift1/repositories/personRepository.dart';
import 'package:uppgift1/repositories/vehicleRepository.dart';

  
Future <void> main() async {
  var personRepo = PersonRepository();
  var vehicleRepo = VehicleRepository();
  var parkingSpaceRepo = ParkingSpaceRepository();
  var parkingRepo = ParkingRepository();

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
      handlePerson(personRepo);
      break;
      case "2":
      handleVehicles(vehicleRepo, personRepo);
      break;
      case "3":
      handleParkingPlaces(parkingSpaceRepo);
      break;
      case "4":
      handleParking(parkingRepo, vehicleRepo, parkingSpaceRepo);
      break;
      case "5":
      print("\n Avslutar programmet");
      exit(0);
      default:
      print("\nOgiltigt val! ");
     }
  }
}

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
    // Find person by ID first
    Person person = personRepo.findById(id);
    
    // Print details of the person to be updated
    print("\nPerson found: ID: ${person.id}, Namn: ${person.namn}, PersonNummer: ${person.personNummer}");

    stdout.write("Ange nytt namn: ");
    String newName = stdin.readLineSync() ?? person.namn;

    stdout.write("Ange nytt Personnummer: ");
    String? newPersonnummerStr = stdin.readLineSync();
    
    int newPersonnummer = (newPersonnummerStr != null && newPersonnummerStr.length == 12 && int.tryParse(newPersonnummerStr) != null)
        ? int.parse(newPersonnummerStr)
        : person.personNummer;

    // Update person using existing ID
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


void handleVehicles(VehicleRepository vehicleRepo, PersonRepository personRepo) {
  while (true) {
    print("*****************************************");
    print("\n Du har valt att hantera Fordon. Vad vill du göra?");
    print("*****************************************");
    print("1. Registrera nytt fordon");
    print("2. Visa alla fordon");
    print("3. Ta bort fordon");
    print("4. Tillbaka till huvudmenyn");
    print("*****************************************");
    stdout.write("Välj ett alternativ (1-4): ");

    String? choice = stdin.readLineSync();
    switch (choice) {
      case "1":
        stdout.write("\nAnge registreringsnummer: ");
        String? regNum = stdin.readLineSync();

        stdout.write("\nAnge person-ID för fordonsägaren: ");
        int? ownerId = int.tryParse(stdin.readLineSync() ?? "");

        stdout.write("\nAnge fordonstyp (1 = Bil, 2 = Motorcykel, 3 = Lastbil): ");
        int? typeChoice = int.tryParse(stdin.readLineSync() ?? "");
        VehicleType? vehicleType;

        if (typeChoice == 1) {
          vehicleType = VehicleType.Car;
        } else if (typeChoice == 2) {
          vehicleType = VehicleType.Motorcycle;
        } else if (typeChoice == 3) {
          vehicleType = VehicleType.Lastbil;
        } else {
          print("\n**Fel: Ogiltig fordonstyp!**");
          break;
        }

        stdout.write("\nAnge bilens färg: ");
        String? color = stdin.readLineSync();

        if (regNum == null || regNum.isEmpty || ownerId == null || color == null || color.isEmpty) {
          print("\n**Fel: Alla fält måste fyllas i!**");
          break;
        }

        try {
          Person? owner = personRepo.findById(ownerId);
          if (owner == null) {
            print("\nFel: Ägaren med ID $ownerId hittades inte!");
            break;
          }
          Car newCar = Car(
            registreringsNummer: regNum,
            typ: vehicleType, 
            owner: owner,
            color: color,
            id: vehicleRepo.getNextId(),
          );

  vehicleRepo.add(newCar);
          print("\nFordon registrerat framgångsrikt!");
        } catch (e) {
          print("\nFel: ${e.toString()}");
        }
        break;

      case "2":
        final vehicles = vehicleRepo.findAll();
        if (vehicles.isEmpty) {
          print("\nInga fordon hittades.");
        } else {
          for (var v in vehicles) {
            print("Reg.nr: ${v.registreringsNummer}, Ägare: ${v.owner.namn}, Typ: ${v.typ.name}, Färg: ${(v as Car).color}");
          }
        }
        break;

      case "3":
        stdout.write("\nAnge registreringsnummer för fordonet att ta bort: ");
        String? regNumToDelete = stdin.readLineSync();

        if (regNumToDelete == null || regNumToDelete.isEmpty) {
          print("\nFel: Ange ett giltigt registreringsnummer!");
          break;
        }
        try {
             Vehicle vehicleToDelete = vehicleRepo.getVehicleByRegNum(regNumToDelete)!;
            vehicleRepo.deleteById(vehicleToDelete.id);
            print("\nFordon borttaget!");
          } catch (e) {
            print("\nFel: ${e.toString()}");
          }
      case "4":
        print("\nTillbaka till huvudmenyn...");
        return;

      default:
        print("\nOgiltigt val, försök igen.");
    }
  }
}

void handleParkingPlaces(ParkingSpaceRepository parkingSpaceRepo) {
  while (true) {
    print("*****************************************");
    print("\nDu har valt att hantera Parkeringsplatser. Vad vill du göra?");
    print("*****************************************");
    print("1. Lägg till en ny parkeringsplats");
    print("2. Visa alla parkeringsplatser");
    print("3. Ta bort en parkeringsplats");
    print("4. Tillbaka till huvudmenyn");
    print("*****************************************");
    stdout.write("Välj ett alternativ (1-4): ");

    String? choice = stdin.readLineSync();
    switch (choice) {
      case "1":
   // stdout.write("\nAnge platsens ID: ");
    int? spaceId = int.tryParse(stdin.readLineSync() ?? "");

    if (spaceId == null) {
      print("\nFel: Ange ett giltigt ID!");
      break;
    }

    stdout.write("\nAnge area parkeringsplatsen: ");
    String? adress = stdin.readLineSync();

    if (adress == null || adress.isEmpty) {
      print("\nFel: Ange en giltig adress!");
      break;
    }

    stdout.write("\nAnge pris per timme för parkeringsplatsen: ");
    double? pricePerHour = double.tryParse(stdin.readLineSync() ?? "");

    if (pricePerHour == null || pricePerHour <= 0) {
      print("\nFel: Ange ett giltigt pris större än 0!");
      break;
    }

    try {
      parkingSpaceRepo.add(ParkingSpace(
        id: spaceId, 
        adress: adress,
        pricePerHour: pricePerHour,  
      ));
      print("\nParkeringsplats skapad framgångsrikt!");
    } catch (e) {
      print("\nFel: ${e.toString()}");
    }
    break;


      case "2":
        final spaces = parkingSpaceRepo.findAll();
        if (spaces.isEmpty) {
          print("\nInga parkeringsplatser hittades.");
        } else {
          spaces.forEach((s) => print("Plats ID: ${s.id}"));
        }
        break;

      case "3":
        stdout.write("\nAnge ID på parkeringsplatsen att ta bort: ");
        int? spaceIdToDelete = int.tryParse(stdin.readLineSync() ?? "");

        if (spaceIdToDelete == null) {
          print("\nFel: Ange ett giltigt ID!");
          break;
        }

        parkingSpaceRepo.deleteById(spaceIdToDelete);
        print("\nParkeringsplats borttagen!");
        break;

      case "4":
        print("\nTillbaka till huvudmenyn...");
        return;

      default:
        print("\nOgiltigt val, försök igen.");
    }
  }
}

void handleParking(ParkingRepository parkingRepo, VehicleRepository vehicleRepo, ParkingSpaceRepository parkingSpaceRepo) {
  while (true) {
    print("*****************************************");
    print("\nDu har valt att hantera Parkeringar. Vad vill du göra?");
    print("*****************************************");
    print("1. Skapa ny parkering");
    print("2. Visa alla parkeringar");
    print("3. Ta bort parkering");
    print("4. Beräkna kostnad för parkeringen");
    print("5. Uppdatera parkering");
    print("6. Tillbaka till huvudmenyn");
    print("*****************************************");
    stdout.write("Välj ett alternativ (1-5): ");

    String? choice = stdin.readLineSync();
    switch (choice) {
      case "1":
        stdout.write("\nAnge parkeringsplatsens ID: ");
        int? parkingSpaceId = int.tryParse(stdin.readLineSync() ?? "");
        stdout.write("\nAnge registreringsnummer för fordonet: ");
        String? regNum = stdin.readLineSync();
        stdout.write("\nAnge starttid (YYYY-MM-DD HH:MM): ");
        String? startTime = stdin.readLineSync();

        if (parkingSpaceId == null || regNum == null || startTime == null) {
          print("\nFel: Alla fält måste fyllas i!");
          break;
        }

        try {
          Vehicle? vehicle = vehicleRepo.getVehicleByRegNum(regNum);
           if (vehicle == null) {
              print("\nFel: Fordonet med registreringsnummer $regNum hittades inte!");
              break;
            }
          
          ParkingSpace parkingSpace = parkingSpaceRepo.findById(parkingSpaceId);
          Parking parking = Parking(
            id:parkingRepo.getNextId(),
            fordon: vehicle,
            parkingSpace: parkingSpace,
            startTime: DateTime.parse(startTime),
          );
          parkingRepo.add(parking);
          print("\nParkering skapad framgångsrikt!");
        } catch (e) {
          print("\nFel: ${e.toString()}");
        }
        break;

      case "2":
        final parkings = parkingRepo.findAll();
        if (parkings.isEmpty) {
          print("\nInga parkeringar hittades.");
        } else {
          parkings.forEach((p) => print("ID: ${p.id}, Fordon: ${p.vehicle.registreringsNummer}, Parkeringsplats: ${p.parkingSpace.id}, Starttid: ${p.startTime}"));
        }
        break;

      case "3":
        stdout.write("\nAnge ID för parkeringen att ta bort: ");
        int? parkingId = int.tryParse(stdin.readLineSync() ?? "");

        if (parkingId == null) {
          print("\nFel: Ange ett giltigt ID!");
          break;
        }
         case "4": // Calculate Parking Cost
        stdout.write("\nAnge ID för parkeringen att beräkna kostnaden: ");
        int? parkingId = int.tryParse(stdin.readLineSync() ?? "");

        if (parkingId == null) {
          print("\nFel: Ange ett giltigt ID!");
          break;
        }

        try {
          Parking parking = parkingRepo.findById(parkingId);
          stdout.write("\nAnge sluttid (YYYY-MM-DD HH:MM): ");
          String? endTimeInput = stdin.readLineSync();

          if (endTimeInput == null) {
            print("\nFel: Sluttid måste anges!");
            break;
          }

          DateTime endTime = DateTime.parse(endTimeInput);
          parking.endTime = endTime;
          double ratePerHour = 10.0;
          Duration duration = endTime.difference(parking.startTime);
          double totalCost = (duration.inMinutes / 60) * ratePerHour;

          print("\nParkeringen har varat i ${duration.inHours} timmar och ${duration.inMinutes % 60} minuter.");
          print("Totalkostnad: ${totalCost.toStringAsFixed(2)} SEK");

        } catch (e) {
          print("\nFel: ${e.toString()}");
        }
        break;
      case "5": 
        stdout.write("\nAnge ID för parkeringen att uppdatera: ");
        int? parkingId = int.tryParse(stdin.readLineSync() ?? "");

        if (parkingId == null) {
          print("\nFel: Ange ett giltigt ID!");
          break;
        }
        try {
          Parking parking = parkingRepo.findById(parkingId);
          print("\nParkering hittades: ID: ${parking.id}, Fordon: ${parking.vehicle.registreringsNummer}, Parkeringsplats: ${parking.parkingSpace.id}, Starttid: ${parking.startTime}");

          stdout.write("\nAnge nytt parkeringsplats ID: ");
          int? newParkingSpaceId = int.tryParse(stdin.readLineSync() ?? "");

          if (newParkingSpaceId == null) {
            print("\nFel: Ange ett giltigt parkeringsplats ID!");
            break;
          }

          ParkingSpace newParkingSpace = parkingSpaceRepo.findById(newParkingSpaceId);
          parking.parkingSpace = newParkingSpace;
          parkingRepo.update(parking);
          print("\nParkeringens parkeringsadress uppdaterad!");
        } catch (e) {
          print("\nFel: ${e.toString()}");
        }
        break;

      case "6":
        print("\nÅtergår till huvudmenyn...");
        return;

      default:
        print("\nOgiltigt val, försök igen.");
    }
  }
}
