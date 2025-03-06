import 'package:uppgift1/configs/router_config.dart';
import 'package:uppgift1/configs/server_config.dart';

class ServerConfig {
  ServerConfig._privateConstructor() {
    initialize();
  }

  static final ServerConfig _instance = ServerConfig._privateConstructor();
  static ServerConfig get instance => _instance;

  late RouterConfig router;

  Future initialize() async {
    router = RouterConfig();

    // Parking Routes
    router.post('/parkings', postParkingHandler);
    router.get('/parkings', getParkingHandler);
    router.get('/parkings/:id', getParkingHandler); // Fixing placeholder
    router.put('/parkings/:id', updateParkingHandler); // Fixing placeholder
    router.delete('/parkings/:id', deleteParkingHandler); // Fixing placeholder

    // Person Routes
    router.post('/person', postPersonHandler);
    router.get('/person', getPersonHandler);
    router.get('/person/:id', getPersonHandler); // Fixing placeholder
    router.put('/person/:id', updatePersonHandler); // Fixing placeholder
    router.delete('/person/:id', deletePersonHandler); // Fixing placeholder

    // Vehicle Routes
    router.post('/vehicles', postVehicleHandler);
    router.get('/vehicles', getVehicleHandler);
    router.get('/vehicles/:id', getVehicleHandler); // Fixing placeholder
    router.put('/vehicles/:id', updateVehicleHandler); // Fixing placeholder
    router.delete('/vehicles/:id', deleteVehicleHandler); // Fixing placeholder

    // ParkingSpace Routes
    router.post('/parkingSpaces', postParkingSpaceHandler);
    router.get('/parkingSpaces', getParkingSpaceHandler);
    router.get('/parkingSpaces/:id', getParkingSpaceHandler); // Fixing placeholder
    router.put('/parkingSpaces/:id', updateParkingSpaceHandler); // Fixing placeholder
    router.delete('/parkingSpaces/:id', deleteParkingSpaceHandler); // Fixing placeholder
  }
}
