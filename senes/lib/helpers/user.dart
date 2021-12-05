import 'package:uuid/uuid.dart';

class User {
  ///Class to hold all relevant information about our users

  // Member variables
  String name;
  int age;
  late String id;

  //Constructors
  User(this.name, this.age, this.id);
  User.newUser(this.name, this.age) {
    id = const Uuid().v4();
  }
}
