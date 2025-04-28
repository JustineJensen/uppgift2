import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:uppgift1/configs/server_config.dart';

Middleware corsMiddleware = createMiddleware(
  responseHandler: (Response response) =>
      response.change(headers: {'Access-Control-Allow-Origin': '*'}),
);

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final router = ServerConfig.instance.router;

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware)
      .addMiddleware(_errorMiddleware)
      .addHandler(router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8082');
  final server = await serve(handler, ip, port);
  print('Server running on port ${server.port}');


  ProcessSignal.sigint.watch().listen((_) async {
    print('Server shutting down...');
    await server.close(force: true);
    exit(0);
  });
}
Middleware _errorMiddleware = createMiddleware(
  errorHandler: (Object error, StackTrace stackTrace) {
    print('Error: $error');
    return Response.internalServerError(body: 'Internal Server Error');
  },
);
