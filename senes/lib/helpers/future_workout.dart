import 'package:uuid/uuid.dart';

class FutureWorkout {
  DateTime time;
  late final String id;
  String? route;

  FutureWorkout(this.time, [this.route]) {
    id = const Uuid().v4();
  }
}
