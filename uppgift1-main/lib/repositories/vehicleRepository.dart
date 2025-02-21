import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/models/vehicleType.dart';
import 'package:uppgift1/repositories/repository.dart';

class VehicleRepository extends Repository<Vehicle,int> {
  final List<Vehicle> _vehicles =[];
  int _nextId =1;
    @override
    Future <Vehicle> add(Vehicle vehicle)async {
      vehicle.id = _vehicles.length + 1;
      _vehicles.add(vehicle);
      return vehicle;
    }

    @override
  Future <void>deleteById(int id) async {
      _vehicles.removeWhere((vehicle)=>vehicle.id == id);
    }
    
    @override
    Future <List<Vehicle>> findAll()async{
      return _vehicles;
    }

    @override
    Future<Vehicle>findById(int id)async{
      return _vehicles.firstWhere((vehicle)=> vehicle.id == id,orElse:()=>  throw Exception("Vehicle med ID $id hittades inte"),);
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
