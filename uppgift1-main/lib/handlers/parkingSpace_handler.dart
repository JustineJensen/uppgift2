import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uppgift1/models/parkingSpace.dart';
import 'package:uppgift1/repositories/parkingSpaceRepository.dart';

class ParkingSpaceHandler{
  ParkingSpaceRepository  repo = ParkingSpaceRepository.instance;

  Future <Response> postParkingSpaceHandler(Request request)async{
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var parkingSpace = ParkingSpace.fromJson(json);

  parkingSpace = await repo.add(parkingSpace);

  return Response.ok(jsonEncode(parkingSpace),
  headers:{'content-Type':'application/json'});

}
Future<Response> getAllParkingSpaceHandler(Request request) async{
  final parkingSpace = await repo.findAll();

  final payload = parkingSpace.map((e)=> e.toJson())

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
      var parkingSpace = await repo.findById(parsedId);
      return Response.ok(
        jsonEncode(parkingSpace),
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
Future<Response> updateParkingSpace( Request request)async{
   final String? id = request.params["id"];

    if(id != null){
    final int? parsedId = int.tryParse(id);
    if(parsedId != null){
      final data = await request.readAsString();
      final json = jsonDecode(data);

      ParkingSpace parkingSpace = ParkingSpace.fromJson(json);
      //parkingSpace.id = parsedId;

      parkingSpace = await repo.update(parkingSpace);
      return Response.ok(
        jsonEncode(parkingSpace),
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
Future<Response> deleteParkingSpaceHandler(Request request) async {
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