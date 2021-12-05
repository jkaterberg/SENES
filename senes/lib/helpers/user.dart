import 'package:uuid/uuid.dart';

class User {
  String name;
  int age;
  late final String id;

  User(this.name, this.age) {
    id = const Uuid().v4();
  }
}
