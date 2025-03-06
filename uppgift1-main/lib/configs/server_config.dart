
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
  
  Future initialize() async {
    router = RouterConfig.initialize();
    //parking
    router.post('/parkings',parkingHandler. postParkingHandler);
    router.get('/parkings', parkingHandler.getAllParkingHandler);
    router.get('/parkings/<id>',parkingHandler.getParkingHandlerById);
    router.put('/parkings/<id>', parkingHandler.updateParking);
    router.delete('/parkings/<id>',parkingHandler.deleteParkingHandler);

    //Person
   router.post('/person',personHandler.postPersonHandler);
   router.get('/person', personHandler.getAllPersonHandler);
   router.get('/person/<id>', personHandler.getPersonHandlerById);
   router.put('/person/<id>',personHandler.updatePerson);
   router.delete('/person/<id>', personHandler.deletePersonHandler);

    //Vehicle
    router.get('/vehicles', vehicleHandler.getAllVehicleHandler);
    router.get('/vehicles', vehicleHandler.getAllVehicleHandler);
    router.get('/vehicles<id>', vehicleHandler.getVehicleHandlerById);
    router.put('/vehicles/<id>', vehicleHandler.updateVehicle);
    router.delete('/vehicles<id>', vehicleHandler.deleteVehicleHandler);

    //Parkingspace 
    router.post('/parkingspaces',parkingSpaceHandler.postParkingSpaceHandler);
    router.get('/parkingspaces', parkingSpaceHandler.getAllParkingSpaceHandler);
    router.get('/parkingspaces/<id>',parkingSpaceHandler.getParkingHandlerById);
    router.put('/parkingspaces/<id>', parkingSpaceHandler.updateParkingSpace);
    router.delete('/parkingspaces/<id>', parkingSpaceHandler.deleteParkingSpaceHandler); 
  }
}
