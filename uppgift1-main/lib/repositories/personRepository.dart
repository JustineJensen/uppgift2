import 'package:uppgift1/models/person.dart';
import 'package:uppgift1/repositories/repository.dart';

class PersonRepository extends Repository<Person,int> {
  
  final List<Person> _persons =[];
  int _nextId = 1;

 @override
Person add(Person person) {
  person = Person(namn: person.namn, personNummer: person.personNummer);
  _persons.add(person); 
  return person; 
}


  @override
  void deleteById(int id) {
    _persons.removeWhere((person)=> person.id ==id);
  }

  @override
  List<Person> findAll() {
   return _persons;
  }

  @override
  Person findById(int id) {
  return _persons.firstWhere((person)=> person.id ==id, orElse:()=>
  throw Exception("Person med ID $id hittades inte"),);
  }

  @override
void update(Person entity) {
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
  int getNextId(){
    return _nextId;
  }

}