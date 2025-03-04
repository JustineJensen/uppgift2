import 'dart:convert';

import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/repositories/repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ParkingRepository extends Repository<Parking,int> {
  final List<Parking> _parkings =[];
  int _nextId = 1;
  
  ParkingRepository._internal();
 
   static final ParkingRepository _instance = ParkingRepository._internal();

   static ParkingRepository get instance => _instance;
  
  @override
 Future <Parking>add(Parking parking)async {
   final uri = Uri.parse("http://localhost:8080/parking");
    Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parking.toJson()),
    );

    final json = jsonDecode(response.body);
    return Parking.fromJson(json);
  }

  @override
  Future <void> deleteById(int id) async {
      final uri = Uri.parse("http://localhost:8080/parking/$id");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else {
      throw Exception("Failed to delete parking (HTTP ${response.statusCode})");
    }
  }

  @override
  Future <List<Parking>> findAll() async{
   final uri = Uri.parse("http://localhost:8080/parking");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);
    return (json as List).map((parking) => Parking.fromJson(parking)).toList();
  }

  @override
  Future <Parking> findById(int id)async {
    final uri = Uri.parse("http://localhost:8080/parking/$id");
    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Parking.fromJson(json);
    } else {
      throw Exception("Person with ID $id not found (HTTP ${response.statusCode})");
    }
  }
  @override
  Future <Parking> update(Parking entity) async {
     final uri = Uri.parse("http://localhost:8080/parking/${entity.id}");
    Response response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(entity.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Parking.fromJson(json);
    } else {
      throw Exception("Failed to update person (HTTP ${response.statusCode})");
    }
  }
  Future<int> getNextId() async {
  return _nextId++;
}

    
}

