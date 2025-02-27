import 'dart:convert';

import 'package:uppgift1/models/parking.dart';
import 'package:uppgift1/repositories/parkingRepository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
class ParkingHandler {

ParkingRepository repo = ParkingRepository();

Future <Response> postParkingHandler(Request request)async{
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var parking = Parking.fromJson(json);

  parking = await repo.add(parking);

  return Response.ok(jsonEncode(parking),
  headers:{'content-Type':'application/json'});

}
}