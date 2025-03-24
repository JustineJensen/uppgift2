import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/repositories/personRepository.dart';

class PersonHandler {
  PersonRepository repo = PersonRepository.instance;
  
  Future <Response> postPersonHandler(Request request)async{
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var person = Person.fromJson(json);

  person = await repo.add(person);

  return Response.ok(jsonEncode(person),
  headers:{'content-Type':'application/json'});

}
Future<Response> getAllPersonHandler(Request request) async{
  final person = await repo.findAll();

  final payload = person.map((e)=> e.toJson())

  .toList();
  return Response.ok(
    jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
}

//get by id
 Future<Response> getPersonHandlerById(Request request) async {
  final String? id = request.params["id"];

  if (id != null) {
    final int? parsedId = int.tryParse(id);
    if (parsedId != null) {
      var person = await repo.findById(parsedId);
      return Response.ok(
        jsonEncode(person),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Invalid ID format',
          'message': 'The "id" parameter must be a valid integer.',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
  return Response.badRequest(
    body: jsonEncode({
      'error': 'Invalid request',
      'message': 'The required field "id" is missing or invalid.',
    }),
    headers: {'Content-Type': 'application/json'},
  );
}
// update
Future<Response> updatePerson( Request request)async{
   final String? id = request.params["id"];

    if(id != null){
    final int? parsedId = int.tryParse(id);
    if(parsedId != null){
      final data = await request.readAsString();
      final json = jsonDecode(data);

      Person? person = Person.fromJson(json); 
       await repo.update(person);
      return Response.ok(
        jsonEncode(person),
        headers:{'Content-Type': 'application/json'},
     );
    }else{
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Invalid ID format',
          'message': 'The "id" parameter must be a valid integer.',
        }),
        headers: {'Content-Type': 'application/json'},
      ); 
    }
    
  }
    return Response.badRequest(
    body: jsonEncode({
      'error': 'Invalid request',
      'message': 'The required field "id" is missing or invalid.',
    }),
    headers: {'Content-Type': 'application/json'},
  );

}
// delete
Future<Response> deletePersonHandler(Request request) async {
  final String? id = request.params["id"];
 
  if (id != null) {
    final int? parsedId = int.tryParse(id); 
    if (parsedId != null) {
    
        await repo.deleteById(parsedId);

        return Response.ok(
          jsonEncode({'message':'person entry successfully deleted'}),
          headers: {'Content-Type': 'application/json'},
        );
      } 
    } else {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Invalid ID format',
          'message': 'The "id" parameter must be a valid integer.',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }
     return Response.badRequest(
    body: jsonEncode({
      'error': 'Missing ID',
      'message': 'The required field "id" is missing or invalid.',
    }),
    headers: {'Content-Type': 'application/json'},
  );
}
}
