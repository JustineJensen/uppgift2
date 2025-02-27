import 'dart:convert';

import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/models/vehicleType.dart';

class Car extends Vehicle{
  late String _color;
  //Constructor 
    Car({
    required String registreringsNummer,
    required VehicleType typ,
    required Person owner,
    required String color,
    required int id,
  }) : super(id:id,registreringsNummer: registreringsNummer, typ: typ, owner: owner) {
    _color = color;
  }
  // Getters
  String get color => _color;

  // Setters
  set color( String color){
    if (color.isNotEmpty){
      _color = color;
    }else{
      throw Exception("Color cannot be empty.");
    }
  }
   factory Car.fromJson(Map<String,dynamic>json){
    return Car(
      id:json['id'],
    registreringsNummer: json['registreringsNummer'], 
    typ: VehicleTypeExtension.fromJson(json['vehicleTyp']),
    owner: Person.fromJson(json['owner']),color: json['color'],
    );
    }
 
    Map<String,dynamic> toJson(){
      return{
        "id": id,
        "registreringsNummer":registreringsNummer,
        "typ": VehicleType,
        "owner" : Person
      };

    }
}

  /* @override
  String toString() {
    return 'Car{id: $id,registreringsnummer: $registreringsNummer, typ: $typ, owner: ${owner.namn}, color: $_color}';
  }
*/