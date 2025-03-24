import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/models/vehicleType.dart';
import 'package:uppgift1/repositories/repository.dart';

class VehicleRepository extends Repository<Vehicle,int> {
  final List<Vehicle> _vehicles =[];
  int _nextId = 1;

   VehicleRepository._internal();
 
   static final VehicleRepository _instance = VehicleRepository._internal();

   static VehicleRepository get instance => _instance;
    @override
    Future<Vehicle> add(Vehicle vehicle) async {
      final uri = Uri.parse("http://localhost:8080/vehicles");

      http.Response response = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(vehicle.toJson()));  
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Vehicle.fromJson(json);  
      } else {
        throw Exception("Failed to add vehicle (HTTP ${response.statusCode})");
      }
    }

    @override
    Future <void>deleteById(int id) async {
      final uri = Uri.parse("http://localhost:8080/vehicles/$id");
     http.Response response = await http.delete(
        uri,
        headers: {'Content-Type': 'application/json'},
        );
        if(response.statusCode == 200 || response.statusCode == 204){
          return;
        }else{
          throw Exception("Failed to delete Vehicle(Http ${response.statusCode})");
        }
    }
    
    @override
    Future <List<Vehicle>> findAll()async{
      return _vehicles;
    }
    @override
    Future<Vehicle>findById(int id)async{
      final uri = Uri.parse("http://localhost:8080/vehicles/${id}");
      http.Response response = await http.get(uri,
      headers:{'Content -Type': 'application/json'});
      if(response.statusCode == 200){
        final json =jsonDecode(response.body);
        return Vehicle.fromJson(json);
      }else{
        throw Exception("Vehicle with ID $id not found (HTTP ${response.statusCode})");
      }
      
    }

    @override
    Future<void> update(Vehicle entity)async {
      int index = _vehicles.indexWhere((vehicle)=>vehicle.id == entity.id);
      if(index != -1){
        _vehicles[index]= entity;
      }else{
        throw Exception("Vehicle med ID ${entity.id} hittades inte.");
      }
    }
    Future <int>getNextId() async{
      return _nextId;
    }
    Future <Vehicle> findByRegNum(String regNum)async{
    var vehicle = _vehicles.firstWhere((v) => v.registreringsNummer == regNum, orElse: () => throw Exception('Fordon inte hittat'));
      return vehicle;
  }
  Future<Vehicle?> getVehicleByRegNum(String regNum)async{
      return _vehicles.firstWhere(
        (vehicle) => vehicle.registreringsNummer == regNum,
        orElse: () => throw Exception("Registrerings Nummer hittades inte"),
      );
    }
    
}
