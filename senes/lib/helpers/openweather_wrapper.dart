import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Weather {
  static var baseURL = "http://api.openweathermap.org";

  static Future<Map<dynamic, dynamic>> getCurrent(
      double lat, double lon) async {
    Uri url = Uri.http(baseURL, "/data/2.5/weather", {
      "lat": lat.toString(),
      "lon": lon.toString(),
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
