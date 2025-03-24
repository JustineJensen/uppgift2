
import 'package:uppgift1/models/vehicle.dart';
class Person {
  static int _idCounter = 0;
  late int _id;
  String _namn;
  int _personNummer;

  // Constructor
  Person({
    required String namn,
    required int personNummer,
    int? id, 
  })  : _namn = namn,
        _personNummer = personNummer {
    _id = id ?? ++_idCounter; 
  }

  // Getters
  String get namn => _namn;
  int get personNummer => _personNummer;
  int get id => _id;

  // Setters
  set namn(String namn) => _namn = namn;

  set personNummer(int personNummer) {
    if (personNummer.toString().length == 12) {
      _personNummer = personNummer;
    } else {
      throw Exception("Person number must be 12 digits");
    }
  }
   factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],  
      namn: json['namn'], 
      personNummer: json['personNummer'], 
    );
}
   Map <String,dynamic> toJson(){
    return{
      "id":id,
      "namn": namn,
      "personNummer":personNummer
    };

   }
  @override
  String toString() {
    return 'Person(namn: $namn, personNummer: $personNummer, id: $id)';
  }
}
