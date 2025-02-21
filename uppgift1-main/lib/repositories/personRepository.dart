import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/repositories/repository.dart';

class PersonRepository extends Repository<Person,int> {
  
  final List<Person> _persons =[];
  int _nextId = 1;

  @override
  Future <Person> add(Person person)async{
    person = Person(namn: person.namn, personNummer: person.personNummer);
    _persons.add(person); 
    return person; 
  }

  @override
  Future <void> deleteById(int id)async{
    _persons.removeWhere((person)=> person.id ==id);
  }

  @override
  Future <List<Person>> findAll()async{
    return _persons;
  }
  @override
  Future <Person> findById(int id)async {
    return _persons.firstWhere((person)=> person.id ==id, orElse:()=>
    throw Exception("Person med ID $id hittades inte"),);
  }

    @override
  Future<void>update(Person entity)async {
    int index = _persons.indexWhere((p) => p.id == entity.id);
    if (index != -1) {
      print("Updating person with ID: ${entity.id}");
      _persons[index].namn = entity.namn;
      _persons[index].personNummer = entity.personNummer;
      print("Updated person: ${_persons[index]}");
    } else {
      print("Person with ID ${entity.id} not found.");
      throw Exception("Person med ID ${entity.id} hittades inte.");
    }
  }
    Future <int> getNextId()async{
      return _nextId;
    }

}