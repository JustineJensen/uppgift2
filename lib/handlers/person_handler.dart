import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uppgift1/models/person.dart';

class PersonHandler {
  final String _filePath = 'person.json';

  Future<List<Person>> _readFromFile() async {
    final file = File(_filePath);
    if (!await file.exists()) {
      return [];
    }
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Person.fromJson(json)).toList();
  }

  Future<void> _writeToFile(List<Person> persons) async {
    final file = File(_filePath);
    final jsonList = persons.map((person) => person.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

Future<Response> postPersonHandler(Request request) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    var person = Person.fromJson(json);

    final persons = await _readFromFile();
    final newId = persons.isEmpty ? 1 : persons.last.id + 1;
    person = person.copyWith(id: newId);

    persons.add(person);
    await _writeToFile(persons);

    return Response.ok(
      jsonEncode(person.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': e.toString()}),
    );
  }
}


  // Get all persons
  Future<Response> getAllPersonHandler(Request request) async {
    try {
      final persons = await _readFromFile();
      return Response.ok(
        jsonEncode(persons.map((p) => p.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  // Get a person by ID
  Future<Response> getPersonHandlerById(Request request) async {
    try {
      final String? id = request.params['id'];
      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'ID is required'}),
        );
      }

      final persons = await _readFromFile();
      final person = persons.firstWhere(
        (p) => p.id == int.parse(id),
        orElse: () => throw Exception('Person not found'),
      );

      return Response.ok(
        jsonEncode(person.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.badRequest(
        body: jsonEncode({
          'error': 'Invalid ID format',
          'message': 'The "id" parameter must be a valid integer.',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // Update a person
  Future<Response> updatePerson(Request request) async {
    try {
      final String? id = request.params['id'];
      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'ID is required'}),
        );
      }

      final data = await request.readAsString();
      final json = jsonDecode(data);
      final updatedPerson = Person.fromJson(json);

      final persons = await _readFromFile();
      final index = persons.indexWhere((p) => p.id == int.parse(id));
      if (index == -1) {
        throw Exception('Person not found');
      }

      persons[index] = updatedPerson;
      await _writeToFile(persons);

      return Response.ok(
        jsonEncode(updatedPerson.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  // Delete a person
  Future<Response> deletePersonHandler(Request request) async {
    try {
      final String? id = request.params['id'];
      if (id == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'ID is required'}),
        );
      }

      final persons = await _readFromFile();
      persons.removeWhere((p) => p.id == int.parse(id));
      await _writeToFile(persons);

      return Response.ok(
        jsonEncode({'message': 'Person deleted successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }
}