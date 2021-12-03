import 'dart:convert';

class WorkoutConditions {
  WorkoutConditions(
      this.temp, this.clouds, this.pressure, this.humidity, this.wind);
  double? temp;
  String? clouds;
  double? pressure;
  int? humidity;
  Map<String, dynamic>? wind;

  WorkoutConditions.fromJSON(String json) {
    Map<dynamic, dynamic> weather = jsonDecode(json);
    temp = weather['main']['temp'];
    clouds = weather['weather']['description'];
    pressure = weather['main']['pressure'];
    humidity = weather['main']['humidity'];
    wind = weather['wind'];
  }
}
