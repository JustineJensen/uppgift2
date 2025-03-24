import 'package:uppgift1/models/car.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicleType.dart';

 abstract class Vehicle{
  late int _id;
  late String _registreringsNummer;
  late VehicleType _typ;
  late Person _owner;
  
 
 // constructor
  Vehicle({required int id,required String registreringsNummer, required  VehicleType typ, required Person owner})
  :_id =id,
  _registreringsNummer = registreringsNummer, 
  _typ = typ,
  _owner = owner;

  //Getters
  int get id => _id;
  String get registreringsNummer => _registreringsNummer;
  VehicleType get typ => _typ;
  Person get owner => _owner;
  //Setters
  set id(int id)=>_id =id;
  set registreringsNummer (String registreringsNummer)=>_registreringsNummer =registreringsNummer;
  set typ(VehicleType typ) => _typ = typ;
  set owner (Person owner) => _owner = owner;
 
 factory Vehicle.fromJson(Map<String,dynamic>json){
  if(json['typ'] == 'car'){
    return Car.fromJson(json);
  }
  throw Exception("unknown vehicle type");
 }
  Map<String, dynamic> toJson();
@override
  String toString() {
    return 'Vehicle{id:$_id,registreringsnummer: $registreringsNummer, typ: $typ, owner: ${owner.namn}}';
  }
 }