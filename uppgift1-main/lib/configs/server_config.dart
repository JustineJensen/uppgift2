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
  //router = RouterConfig();
  //router.post('/parkings,postParkingHandler');
}
}