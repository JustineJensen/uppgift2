import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/models/vehicleType.dart';
import 'package:uppgift1/repositories/repository.dart';

class VehicleRepository extends Repository<Vehicle,int> {
  final List<Vehicle> _vehicles =[];
 int _nextId =1;
  @override
  Vehicle add(Vehicle vehicle) {
    vehicle.id = _vehicles.length + 1;
    _vehicles.add(vehicle);
    return vehicle;
  }

  @override
  void deleteById(int id) {
    _vehicles.removeWhere((vehicle)=>vehicle.id == id);
  }
  
  @override
  List<Vehicle> findAll() {
    return _vehicles;
  }

  @override
  Vehicle findById(int id) {
    return _vehicles.firstWhere((vehicle)=> vehicle.id == id,orElse:()=>  throw Exception("Vehicle med ID $id hittades inte"),);
  }

  @override
  void update(Vehicle entity) {
    int index = _vehicles.indexWhere((vehicle)=>vehicle.id == entity.id);
    if(index != -1){
      _vehicles[index]= entity;
    }else{
      throw Exception("Vehicle med ID ${entity.id} hittades inte.");
    }
  }
   int getNextId(){
    return _nextId;
  }
  Vehicle findByRegNum(String regNum) {
  var vehicle = _vehicles.firstWhere((v) => v.registreringsNummer == regNum, orElse: () => throw Exception('Fordon inte hittat'));
    return vehicle;
}
 Vehicle? getVehicleByRegNum(String regNum) {
    return _vehicles.firstWhere(
      (vehicle) => vehicle.registreringsNummer == regNum,
      orElse: () => throw Exception("Registrerings Nummer hittades inte"),
    );
  }
}
