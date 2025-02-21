import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/repositories/repository.dart';

class ParkingRepository extends Repository<Parking,int> {
  final List<Parking> _parkings =[];
  int _nextId = 1;
 
  @override
 Future <Parking>add(Parking parking)async {
    parking.id = _nextId++;
    _parkings.add(parking);
    return parking;
  }

  @override
  Future <void> deleteById(int id) async {
    _parkings.removeWhere((Parking)=>Parking.id == id);
  }

  @override
  Future <List<Parking>> findAll() async{
    return _parkings;
  }

  @override
  Future <Parking> findById(int id)async {
    return _parkings.firstWhere((parking)=> parking.id == id, orElse: ()=>
    throw Exception("Parking med ID $id hittades inte"),);
  }
  @override
  Future <void> update(Parking entity) async {
    int index = _parkings.indexWhere((p)=>p.id ==entity.id);
    if(index != -1){
      _parkings[index] = entity;
    }else{
      throw Exception("Parking med ID ${entity.id} hittades inte.");
    }
    
  }
  Future <int> getNextId() async{
    return _nextId;
  }
}
