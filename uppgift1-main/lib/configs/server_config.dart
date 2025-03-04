import 'package:uppgift1/configs/router_config.dart';
import 'package:uppgift1/configs/server_config.dart';

class ServerConfig {
  ServerConfig._privateConstructor(){
    initialize();
  }
  static final ServerConfig _instance = ServerConfig._privateConstructor();
  static ServerConfig get instance =>_instance;

  late RouterConfig router;
  
Future initialize()async {
  router = RouterConfig();
  //Parking
 /* router.post('/parkings',postParkingHandler); 
  router.get('/parkings',getParkingHandler);
  router.get('/parkings'/<id>',getParkingHandler);
  router.put('/parking<id>',updateParkingHandler);
  router.delete('parkings/<id>',deleteParkingHandler);

  //Person
  router.post('/person',postPersonHandler); 
  router.get('/person',getPersonHandler);
  router.get('/person/<id>',getPersonHandler);
  router.put('/person<id>',updatePersonHandler);
  router.delete('person/<id>',deletePersonHandler);

  // Vehicle
  router.post('/vehicles',postVehicleHandler'); 
  router.get('/vehicles',getVehicleHandler);
  router.get('/parkings/<id>',getVehicleHandler);
  router.put('/parking<id>',updateVehicleHandler);
  router.delete('parkings/<id>',deleteVehicleHandler);
 
 // ParkingSpace
  router.post('/parkingSpaces',postParkingspaceHandler'); 
  router.get('/parkingSpaces',getParkingSpaceHandler);
  router.get('/parkingSpace/<id>',getParkingspaceHandler);
  router.put('/parkingSpace<id>',updateParkingSpaceHandler);
  router.delete('parkingSpaces/<id>',deleteParkingSpaceHandler);
*/
}
}