import 'package:uuid/uuid.dart';

class User {
  String name;
  int age;
  late String id;

  User(this.name, this.age, this.id);
  User.newUser(this.name, this.age) {
    id = const Uuid().v4();
  }
}
