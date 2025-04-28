import 'package:shelf_router/shelf_router.dart';
import 'package:uppgift1/handlers/parkingspace_handler.dart';
import 'package:uppgift1/handlers/person_handler.dart';
import 'package:uppgift1/handlers/vehicle_handler.dart';
import 'package:uppgift1/handlers/parking_handler.dart'; 

class RouterConfig {
  static Router initialize() {
    final router = Router();

    final parkingHandler = ParkingHandler();
    final personHandler = PersonHandler();
    final vehicleHandler = VehicleHandler();
    final parkingSpaceHandler = ParkingSpaceHandler();

    // Parking Routes
    router.post('/parking', parkingHandler.postParkingHandler);
    router.get('/parking', parkingHandler.getAllParkingHandler);
    router.get('/parking/<id>', parkingHandler.getParkingHandlerById);
    router.put('/parking/<id>', parkingHandler.updateParking);
    router.delete('/parking/<id>', parkingHandler.deleteParkingHandler);

    // Person Routes
    router.post('/person', personHandler.postPersonHandler);
    router.get('/person', personHandler.getAllPersonHandler);
    router.get('/person/<id>', personHandler.getPersonHandlerById);
    router.put('/person/<id>', personHandler.updatePerson);
    router.delete('/person/<id>', personHandler.deletePersonHandler);

    // Vehicle Routes
    router.post('/vehicles', vehicleHandler.postVehicleHandler);
    router.get('/vehicles', vehicleHandler.getAllVehicleHandler);
    router.get('/vehicles/<id>', vehicleHandler.getVehicleHandlerById);
    router.put('/vehicles/<id>', vehicleHandler.updateVehicle);
    router.delete('/vehicles/<id>', vehicleHandler.deleteVehicleHandler);

    // Parking Space Routes
    router.post('/parkingSpaces', parkingSpaceHandler.postParkingSpaceHandler);
    router.get('/parkingSpaces', parkingSpaceHandler.getAllParkingSpaceHandler);
    router.get('/parkingSpaces/<id>', parkingSpaceHandler.getParkingHandlerById);
    router.put('/parkingSpaces/<id>', parkingSpaceHandler.updateParkingSpace);
    router.delete('/parkingSpaces/<id>', parkingSpaceHandler.deleteParkingSpaceHandler);

    return router;
  }
}
