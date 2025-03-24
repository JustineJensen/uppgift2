import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uppgift1/models/car.dart';
import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift1/models/vehicle.dart';

class ParkingHandler {
  final String _filePath = 'parking.json';

  Future<List<Parking>> _readFromFile() async {
    final file = File(_filePath);
    if (!await file.exists()) {
      return [];
    }
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Parking.fromJson(json)).toList();
  }

  Future<void> _writeToFile(List<Parking> parkings) async {
    final file = File(_filePath);
    final jsonList = parkings.map((parking) => parking.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }
  Future<Response> postParkingHandler(Request request) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data) as Map<String, dynamic>;
    if (json['fordon'] == null || json['parkingSpace'] == null || json['startTime'] == null) {
      return Response(400, body: 'Missing required fields');
    }
    final parking = Parking(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch,
      fordon: Car.fromJson(json['fordon']),
      parkingSpace: ParkingSpace.fromJson(json['parkingSpace']),
      startTime: DateTime.parse(json['startTime']),
    );
    final parkings = await _readFromFile();
    parkings.add(parking);
    await _writeToFile(parkings);

    return Response.ok(
      jsonEncode(parking.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: 'Error creating parking: ${e.toString()}',
    );
  }
}
  Future<Response> getAllParkingHandler(Request request) async {
    try {
      final parkings = await _readFromFile();
      return Response.ok(
        jsonEncode(parkings.map((p) => p.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }
  Future<Response> getParkingHandlerById(Request request) async {
    try {
      final String? id = request.params['id'];
      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'ID is required'}),
        );
      }

      final parkings = await _readFromFile();
      final parking = parkings.firstWhere(
        (p) => p.id == int.parse(id),
        orElse: () => throw Exception('Parking not found'),
      );

      return Response.ok(
        jsonEncode(parking.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response(404,
        body: jsonEncode({'error': e.toString()}),
        headers: {"Content-Type": 'application/json'},
      );
    }
  }

  // Update a parking
  Future<Response> updateParking(Request request) async {
    try {
      final String? id = request.params['id'];
      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'ID is required'}),
        );
      }

      final data = await request.readAsString();
      final json = jsonDecode(data);
      final updatedParking = Parking.fromJson(json);

      final parkings = await _readFromFile();
      final index = parkings.indexWhere((p) => p.id == int.parse(id));
      if (index == -1) {
        throw Exception('Parking not found');
      }

      parkings[index] = updatedParking;
      await _writeToFile(parkings);

      return Response.ok(
        jsonEncode(updatedParking.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  // Delete a parking
  Future<Response> deleteParkingHandler(Request request) async {
    try {
      final String? id = request.params['id'];
      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'ID is required'}),
        );
      }

      final parkings = await _readFromFile();
      parkings.removeWhere((p) => p.id == int.parse(id));
      await _writeToFile(parkings);

      return Response.ok(
        jsonEncode({'message': 'Parking deleted successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }
}