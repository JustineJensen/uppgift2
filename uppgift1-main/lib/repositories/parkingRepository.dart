import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/repositories/repository.dart';

class ParkingRepository extends Repository<Parking,int> {
  final List<Parking> _parkings =[];
  int _nextId = 1;
 
  @override
  Parking add(Parking parking) {
    parking.id = _nextId++;
    _parkings.add(parking);
    return parking;
  }

  @override
  void deleteById(int id) {
    _parkings.removeWhere((Parking)=>Parking.id == id);
  }

  @override
  List<Parking> findAll() {
    return _parkings;
  }

  @override
  Parking findById(int id) {
    return _parkings.firstWhere((parking)=> parking.id == id, orElse: ()=>
    throw Exception("Parking med ID $id hittades inte"),);
  }
  @override
  void update(Parking entity) {
    int index = _parkings.indexWhere((p)=>p.id ==entity.id);
    if(index != -1){
      _parkings[index] = entity;
    }else{
      throw Exception("Parking med ID ${entity.id} hittades inte.");
    }
    
  }
  int getNextId(){
    return _nextId;
  }
}
