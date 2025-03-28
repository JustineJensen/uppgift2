import 'dart:convert';

import 'package:uppgift1/models/car.dart';
import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift1/models/vehicle.dart';

class Parking {
  late int _id;
  late Vehicle  _fordon;
  late ParkingSpace _parkingSpace;
  late DateTime _startTime;
  DateTime? _endTime;

  Parking ({
  required int id,
  required Vehicle fordon,
  required ParkingSpace parkingSpace,
  required DateTime startTime,
  DateTime? endTime,
  
  }) : _id= id,
  _fordon = fordon,
  _parkingSpace = parkingSpace,
  _startTime= startTime,
  _endTime = endTime;

  // Getters
  int get id => _id;
  Vehicle get vehicle => _fordon;
  ParkingSpace get parkingSpace =>_parkingSpace;
  DateTime get startTime => _startTime;
  DateTime? get endTime => _endTime;

  //setter
  set id(int id)=> _id = id;
  set fordon(Vehicle value) => _fordon = value;
  set parkingSpace (ParkingSpace value)=> _parkingSpace = parkingSpace;
  set startTime(DateTime startTime)=> _startTime = startTime;
  set endTime (DateTime? endTime)=> _endTime = endTime;
  
 factory Parking.fromJson(Map<String,dynamic>json){
 return Parking(
  id:json['id'], 
  fordon: json['fordon'], 
  parkingSpace: json['parkingSpace'], 
  startTime: json['startTime']);
   }

   Map <String ,dynamic> toJson(){
    return{
      "id":id,
      "fordon":Vehicle,
      "parkingSpace":ParkingSpace,
      "starTime": startTime
    };
   }
  @override
  String toString(){
    return 'Parking{id: $_id, vehicle: ${_fordon.registreringsNummer}, parkingSpace: ${_parkingSpace.id}, startTime: $_startTime, endTime: $_endTime}';
    }
} 
