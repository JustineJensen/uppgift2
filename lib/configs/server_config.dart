
import 'package:uppgift1/configs/router_config.dart';
import 'package:uppgift1/handlers/parking_handler.dart';
import 'package:uppgift1/handlers/parkingspace_handler.dart';
import 'package:uppgift1/handlers/person_handler.dart';
import 'package:uppgift1/handlers/vehicle_handler.dart';
import 'package:shelf_router/shelf_router.dart';

class ServerConfig {
  ServerConfig._privateConstructor() {
    initialize();
  }

  static final ServerConfig _instance = ServerConfig._privateConstructor();
  static ServerConfig get instance => _instance;

  late Router router;

  final ParkingHandler parkingHandler = ParkingHandler();
  final PersonHandler personHandler = PersonHandler();
  final VehicleHandler vehicleHandler = VehicleHandler();
  final ParkingSpaceHandler parkingSpaceHandler = ParkingSpaceHandler();
  
  void initialize() {
    router = RouterConfig.initialize();
  }
}
