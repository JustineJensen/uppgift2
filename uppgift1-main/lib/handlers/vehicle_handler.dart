import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uppgift1/models/vehicle.dart';
import 'package:uppgift1/repositories/vehicleRepository.dart';

class VehicleHandler {
  VehicleRepository repo = VehicleRepository.instance;

  
  Future <Response> postVehicleHandler(Request request)async{
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var vehicle = Vehicle.fromJson(json);

  vehicle = await repo.add(vehicle);

  return Response.ok(jsonEncode(vehicle),
  headers:{'content-Type':'application/json'});

}
Future<Response> getAllVehicleHandler(Request request) async{
  final vehicle = await repo.findAll();

  final payload = vehicle.map((e)=> e.toJson())

  .toList();
  return Response.ok(
    jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
}

//get by id
 Future<Response> getVehicleHandlerById(Request request) async {
  final String? id = request.params["id"];

  if (id != null) {
    final int? parsedId = int.tryParse(id);
    if (parsedId != null) {
      var vehicle = await repo.findById(parsedId);
      return Response.ok(
        jsonEncode(vehicle),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Invalid ID format',
          'message': 'The "id" parameter must be a valid integer.',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
  return Response.badRequest(
    body: jsonEncode({
      'error': 'Invalid request',
      'message': 'The required field "id" is missing or invalid.',
    }),
    headers: {'Content-Type': 'application/json'},
  );
}
// update
Future<Response> updateVehicle( Request request)async{
   final String? id = request.params["id"];

    if(id != null){
    final int? parsedId = int.tryParse(id);
    if(parsedId != null){
      final data = await request.readAsString();
      final json = jsonDecode(data);

      Vehicle? vehicle = Vehicle.fromJson(json); 
       await repo.update(vehicle);
      return Response.ok(
        jsonEncode(vehicle),
        headers:{'Content-Type': 'application/json'},
     );
    }else{
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Invalid ID format',
          'message': 'The "id" parameter must be a valid integer.',
        }),
        headers: {'Content-Type': 'application/json'},
      ); 
    }
    
  }
    return Response.badRequest(
    body: jsonEncode({
      'error': 'Invalid request',
      'message': 'The required field "id" is missing or invalid.',
    }),
    headers: {'Content-Type': 'application/json'},
  );

}
// delete
Future<Response> deleteVehicleHandler(Request request) async {
  final String? id = request.params["id"];
 
  if (id != null) {
    final int? parsedId = int.tryParse(id); 
    if (parsedId != null) {
    
        await repo.deleteById(parsedId);

        return Response.ok(
          jsonEncode({'message':'vehicle entry successfully deleted'}),
          headers: {'Content-Type': 'application/json'},
        );
      } 
    } else {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Invalid ID format',
          'message': 'The "id" parameter must be a valid integer.',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }
     return Response.badRequest(
    body: jsonEncode({
      'error': 'Missing ID',
      'message': 'The required field "id" is missing or invalid.',
    }),
    headers: {'Content-Type': 'application/json'},
  );
}
}
