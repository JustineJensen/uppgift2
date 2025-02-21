import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/repositories/repository.dart';
import 'package:uppgift1/models/parkingSpace.dart';

class ParkingSpaceRepository extends Repository<ParkingSpace,int> {
  final List<ParkingSpace>_parkingSpace =[];
      int _nextId=1;
    
      @override
    Future <ParkingSpace> add(ParkingSpace entity) async {
      ParkingSpace parkingSpace = ParkingSpace(
        adress: entity.adress,
        pricePerHour: entity.pricePerHour ?? 0.0, 
        id: _nextId++,  
      );
      _parkingSpace.add(parkingSpace);
      return parkingSpace;
    }
   
     @override
    Future <void> deleteById(int id)async {
       _parkingSpace.removeWhere((space)=> space.id == id);
     }
   
     @override
     Future <List<ParkingSpace>> findAll() async {
       return _parkingSpace;
     }
   
     @override
     Future <ParkingSpace> findById(int id) async {
      return _parkingSpace.firstWhere((space)=> space.id == id, orElse:() =>
      throw Exception("Parking Space med ID $id hittades inte"),);
     }
   
     @override
     Future <void> update(ParkingSpace entity) async{
       int index = _parkingSpace.indexWhere((space)=>space.id == entity.id);
       if(index != -1){
        _parkingSpace[index] = entity;
       }else{
        throw Exception("Parkeringsplats med ID ${entity.id} finns inte.");
       }
     }
   
  }