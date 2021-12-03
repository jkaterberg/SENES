import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';

class Weather {
  static var baseURL = "http://api.openweathermap.org";

  static Future<Map<dynamic, dynamic>> getCurrent(LatLng latlng) async {
    Uri url = Uri.http(baseURL, "/data/2.5/weather", {
      "lat": latlng.latitude.toString(),
      "lon": latlng.longitude.toString(),
      "appid": dotenv.env["WEATHER_KEY"]
    });

    http.Response res = await http.get(url);
    if (res.statusCode == 200) {
      Map<dynamic, dynamic> body = jsonDecode(res.body);
      return body;
    } else {
      throw res.statusCode;
    }
  }
}
