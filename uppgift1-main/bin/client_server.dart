import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String>args)async{
  final ip = InternetAddress.anyIPv4;
  Router router = ServerConfig.instance.router;
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');

  ProcessSignal.sigint.watch().listen((ProcessSignal signal) {
    print('clean shutdown');
    server.close(force: true);
    exit(0);
  });

}