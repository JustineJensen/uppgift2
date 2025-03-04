import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/repositories/repository.dart';
import 'package:uppgift1/models/parkingSpace.dart';

class ParkingSpaceRepository extends Repository<ParkingSpace,int> {
  final List<ParkingSpace>_parkingSpace =[];
      int _nextId=1;

       ParkingSpaceRepository._internal();
 
   static final ParkingSpaceRepository _instance = ParkingSpaceRepository._internal();

   static ParkingSpaceRepository get instance => _instance;
    
      @override
    Future <ParkingSpace> add(ParkingSpace parkingSpace) async {
     final uri = Uri.parse("http://localhost:8080/parkingSpace");
    Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parkingSpace.toJson()),
    );

    final json = jsonDecode(response.body);
    return ParkingSpace.fromJson(json);
    }
   
     @override
    Future <void> deleteById(int id)async {
       final uri = Uri.parse("http://localhost:8080/parkingspace/$id");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else {
      throw Exception("Failed to delete person (HTTP ${response.statusCode})");
    }
     }
   
     @override
     Future <List<ParkingSpace>> findAll() async {
      final uri = Uri.parse("http://localhost:8080/parkingSpace");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);
    return (json as List).map((person) => ParkingSpace.fromJson(person)).toList();
     }
   
     @override
     Future <ParkingSpace> findById(int id) async {
       final uri = Uri.parse("http://localhost:8080/parkingSpace/$id");
      Response response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ParkingSpace.fromJson(json);
      } else {
        throw Exception("Person with ID $id not found (HTTP ${response.statusCode})");
      }
    }
   
     @override
     Future <ParkingSpace> update(ParkingSpace entity) async{
      final uri = Uri.parse("http://localhost:8080/parkingSpace/${entity.id}");
      Response response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(entity.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ParkingSpace.fromJson(json);
      } else {
        throw Exception("Failed to update person (HTTP ${response.statusCode})");
    }
  }
  Future<int> getNextId() async {
  return _nextId++;
}

   
  }