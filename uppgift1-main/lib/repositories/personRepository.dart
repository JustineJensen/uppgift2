import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/repositories/repository.dart';

class PersonRepository extends Repository<Person, int> {
  final List<Person> _persons = [];
  int _nextId = 1;

  PersonRepository._internal();

  static final PersonRepository _instance = PersonRepository._internal();

  static PersonRepository get instance => _instance;

  @override
  Future<Person> add(Person person) async {
    final uri = Uri.parse("http://localhost:8080/person");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(person.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Person.fromJson(json);
    } else {
      throw Exception("Failed to add person (HTTP ${response.statusCode})");
    }
  }

  @override
  Future<void> deleteById(int id) async {
    final uri = Uri.parse("http://localhost:8080/person/$id");

    final response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else {
      throw Exception("Failed to delete person (HTTP ${response.statusCode})");
    }
  }

  @override
  Future<List<Person>> findAll() async {
    final uri = Uri.parse("http://localhost:8080/person");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json as List).map((person) => Person.fromJson(person)).toList();
    } else {
      throw Exception("Failed to fetch persons (HTTP ${response.statusCode})");
    }
  }

  @override
  Future<Person> findById(int id) async {
    final uri = Uri.parse("http://localhost:8080/person/$id");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Person.fromJson(json);
    } else {
      throw Exception("Person with ID $id not found (HTTP ${response.statusCode})");
    }
  }

  @override
  Future<void> update(Person entity) async {
    final uri = Uri.parse("http://localhost:8080/person/${entity.id}");
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(entity.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update person (HTTP ${response.statusCode})");
    }
  }
  Future<int> getNextId() async {
  return _nextId++;
}

}
