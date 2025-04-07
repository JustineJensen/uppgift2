import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift1/repositories/parkingSpaceRepository.dart';

class ParkingSpaceHandler{
  ParkingSpaceRepository  repo = ParkingSpaceRepository.instance;

  final String _filePath = 'parkingSpace.json';

  Future<List<ParkingSpace>> _readFromFile() async {
    final file = File(_filePath);
    if (!await file.exists()) {
      return [];
    }
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => ParkingSpace.fromJson(json)).toList();
  }

  Future<void> _writeToFile(List<ParkingSpace> parkingSpaces) async {
    final file = File(_filePath);
    final jsonList = parkingSpaces.map((parkingSpace) => parkingSpace.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }


  Future <Response> postParkingSpaceHandler(Request request)async{
 try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    var parkingSpace = ParkingSpace.fromJson(json);

    final parkingSpaces = await _readFromFile();
    final newId = parkingSpaces.isEmpty ? 1 : parkingSpaces.last.id + 1;
    parkingSpace = parkingSpace.copyWith(id: newId);

   parkingSpaces.add(parkingSpace);
    await _writeToFile(parkingSpaces);

    return Response.ok(
      jsonEncode(parkingSpace.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': e.toString()}),
    );
  }

}
Future<Response> getAllParkingSpaceHandler(Request request) async{
  try {
      final parkingSpaces = await _readFromFile();
      return Response.ok(
        jsonEncode(parkingSpaces.map((p) => p.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }

}

//get by id
Future<Response> getParkingHandlerById(Request request) async {
  try {
    final id = request.params['id'];
    if (id == null) return Response(400, body: 'ID is required');

    final spaces = await _readFromFile();
    final space = spaces.firstWhere(
      (p) => p.id == int.parse(id),
      orElse: () => throw Exception('Not found'),
    );

    return Response.ok(
      jsonEncode(space.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } on StateError {
    return Response.notFound('Parking space not found');
  } catch (e) {
    return Response.internalServerError(
      body: 'Error: ${e.toString()}',
    );
  }
}
// update
Future<Response> updateParkingSpace(Request request) async {
  try {
    final String? id = request.params['id'];
    if (id == null) {
      return Response.badRequest(
        body: jsonEncode({'error': 'ID is required'}),
      );
    }

    final int parsedId = int.parse(id);
    final data = await request.readAsString();
    final json = jsonDecode(data);
    
    final List<ParkingSpace> parkingSpaces = await _readFromFile();
    final int index = parkingSpaces.indexWhere((p) => p.id == parsedId);
    if (index == -1) {
      return Response.notFound(
        jsonEncode({'error': 'Parking space not found'}),
      );
    }

    final double newPricePerHour = _parseDouble(json['pricePerHour'], parkingSpaces[index].pricePerHour);

    final updatedParkingSpace = ParkingSpace(
      id: parsedId,  
      adress: json['adress'] ?? parkingSpaces[index].adress,
      pricePerHour: newPricePerHour,  
    );
    parkingSpaces[index] = updatedParkingSpace;
    await _writeToFile(parkingSpaces);

    return Response.ok(
      jsonEncode(updatedParkingSpace.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': 'Server Error: ${e.toString()}'}),
    );
  }
}

double _parseDouble(dynamic value, double defaultValue) {
  if (value is num) return value.toDouble();   
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed ?? defaultValue;  
  }
  return defaultValue; 
}


// delete
Future<Response> deleteParkingSpaceHandler(Request request) async {
   try {
      final String? id = request.params['id'];
      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'ID is required'}),
        );
      }

      final parkingSpaces = await _readFromFile();
      parkingSpaces.removeWhere((p) => p.id == int.parse(id));
      await _writeToFile(parkingSpaces);

      return Response.ok(
        jsonEncode({'message': 'Parking space deleted successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }


}