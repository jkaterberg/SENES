import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

class Weather {
  static const String _baseURL = "api.openweathermap.org";
  Weather(this.temp, this.clouds, this.pressure, this.humidity, this.wind);
  double? temp;
  String? clouds;
  int? pressure;
  int? humidity;
  Map<dynamic, dynamic>? wind;
  String weatherid = Uuid().v4();

  Weather.fromJSON(Map<dynamic, dynamic> weather) {
    temp = weather['main']['temp'].toDouble();
    clouds = weather['weather'][0]['description'];
    pressure = weather['main']['pressure'];
    humidity = weather['main']['humidity'];
    wind = weather['wind'];
  }

  @override
  String toString() {
    return "$temp $clouds $pressure $humidity $wind";
  }

  static Future<Weather> getCurrent(LatLng latlng) async {
    Uri url = Uri.http(_baseURL, "/data/2.5/weather", {
      "lat": latlng.latitude.toString(),
      "lon": latlng.longitude.toString(),
      "appid": dotenv.env["WEATHER_KEY"]
    });

    http.Response res = await http.get(url);
    if (res.statusCode == 200) {
      Map<dynamic, dynamic> body = jsonDecode(res.body);
      return Weather.fromJSON(body);
    } else {
      throw res.statusCode;
    }
  }
}
