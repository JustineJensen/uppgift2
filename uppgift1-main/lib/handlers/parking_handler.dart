import 'dart:convert';

import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/repositories/parkingRepository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
class ParkingHandler {

ParkingRepository repo = ParkingRepository.instance;

Future <Response> postParkingHandler(Request request)async{
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var parking = Parking.fromJson(json);

  parking = await repo.add(parking);

  return Response.ok(jsonEncode(parking),
  headers:{'content-Type':'application/json'});

}
Future<Response> getAllParkingHandler(Request request) async{
  final parking = await repo.findAll();

  final payload = parking.map((e)=> e.toJson())

.toList();
return Response.ok(
  jsonEncode(payload),
  headers: {'Content-Type': 'application/json'},
);
}

//get by id
 Future<Response> getParkingHandlerById(Request request) async {
  final String? id = request.params["id"];

  if (id != null) {
    final int? parsedId = int.tryParse(id);
    if (parsedId != null) {
      var parking = await repo.findById(parsedId);
      return Response.ok(
        jsonEncode(parking),
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
Future<Response> updateParking( Request request)async{
   final String? id = request.params["id"];

    if(id != null){
    final int? parsedId = int.tryParse(id);
    if(parsedId != null){
      final data = await request.readAsString();
      final json = jsonDecode(data);

      Parking parking = Parking.fromJson(json);
      parking.id = parsedId;

      parking = await repo.update(parking);
      return Response.ok(
        jsonEncode(parking),
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
Future<Response> deleteParkingHandler(Request request) async {
  final String? id = request.params["id"];
 
  if (id != null) {
    final int? parsedId = int.tryParse(id); 
    if (parsedId != null) {
    
        await repo.deleteById(parsedId);

        return Response.ok(
          jsonEncode({'message':'Parking entry successfully deleted'}),
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