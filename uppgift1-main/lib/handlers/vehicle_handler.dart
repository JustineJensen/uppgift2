import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uppgift1/models/car.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/repositories/vehicleRepository.dart';

class VehicleHandler {
  final String _filePath = 'vehicles.json';
  VehicleRepository vehicleRepository = VehicleRepository.instance;
  List<Vehicle>? _cachedVehicles;

  Future<List<Vehicle>> _readFromFile() async {
    final file = File(_filePath);
    if (!await file.exists()) {
      return [];
    }
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Car.fromJson(json)).toList();
  }
  

  Future<void> _writeToFile(List<Vehicle> persons) async {
    final file = File(_filePath);
    final jsonList = persons.map((person) => person.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Future<Response> postVehicleHandler(Request request) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    if (!json.containsKey('registreringsNummer') ||
        !json.containsKey('typ') ||
        !json.containsKey('owner') ||
        !json.containsKey('color')) {
      return Response.badRequest(
        body: jsonEncode({'error': 'Missing required fields: registreringsNummer, typ, owner, color'}),
      );
    }
    var car = Car.fromJson(json);
    final vehicles = await _readFromFile();
    final newId = vehicles.isEmpty ? 1 : vehicles.last.id + 1;
    car = car.copyWith(id: newId);
    vehicles.add(car);
    await _writeToFile(vehicles);
    return Response.ok(
      jsonEncode(car.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': 'Failed to create vehicle: $e'}),
    );
  }
}


  // Get all vehicles
  Future<Response> getAllVehicleHandler(Request request) async {
    try {
      final vehicles = await _readFromFile();
      return Response.ok(
        jsonEncode(vehicles.map((v) => v.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }
  // Get a vehicle by ID
  Future<Response> getVehicleHandlerById(Request request) async {
    try {
      final String? id = request.params['id'];
      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'ID is required'}),
        );
      }

      final vehicles = await _readFromFile();
      final vehicle = vehicles.firstWhere(
        (v) => v.id == int.parse(id),
        orElse: () => throw Exception('Vehicle not found'),
      );

      return Response.ok(
        jsonEncode(vehicle.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Invalid ID format',
          'message': 'The "id" parameter must be a valid integer.',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // Update a vehicle
  Future<Response> updateVehicle(Request request) async {
    try {
      final String? id = request.params['id'];
      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'ID is required'}),
        );
      }

      final data = await request.readAsString();
      final json = jsonDecode(data);
      final updatedVehicle = Car.fromJson(json); 

      final vehicles = await _readFromFile();
      final index = vehicles.indexWhere((v) => v.id == int.parse(id));
      if (index == -1) {
        throw Exception('Vehicle not found');
      }

      vehicles[index] = updatedVehicle;
      await _writeToFile(vehicles);

      return Response.ok(
        jsonEncode(updatedVehicle.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  // Delete a vehicle
  Future<Response> deleteVehicleHandler(Request request) async {
    try {
      final String? id = request.params['id'];
      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'ID is required'}),
        );
      }

      final vehicles = await _readFromFile();
      vehicles.removeWhere((v) => v.id == int.parse(id));
      await _writeToFile(vehicles);

      return Response.ok(
        jsonEncode({'message': 'Vehicle deleted successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }
}