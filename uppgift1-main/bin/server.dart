import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:uppgift1/configs/server_config.dart';

Middleware corsMiddleware = (Handler handler) {
  return (Request request) async {
    if (request.method == 'OPTIONS') {
      return Response.ok('', headers: _corsHeaders);
    }

    final response = await handler(request);
    return response.change(headers: _corsHeaders);
  };
};

const Map<String, String> _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
};

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
  print('Server running on http://${server.address.address}:${server.port}');

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
