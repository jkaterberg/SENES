import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

class Weather {
  /// Wrapper for OpenWeatherMap REST api
  ///  Currently only supports requesting the current weather conditions at a
  ///   specified longitude and latitude

  //Member variables
  static const String _baseURL = "api.openweathermap.org";
  Weather(this.temp, this.clouds, this.pressure, this.humidity, this.wind);
  double? temp;
  String? clouds;
  int? pressure;
  int? humidity;
  Map<dynamic, dynamic>? wind;
  String weatherid = const Uuid().v4();

  Weather.fromJSON(Map<dynamic, dynamic> weather) {
    /// Constructor to create a Weather object from JSON directly obtained from
    /// OpenWeatherMap (Converted into a Map<dynamic, dynamic>)
    temp = weather['main']['temp'].toDouble();
    clouds = weather['weather'][0]['description'];
    pressure = weather['main']['pressure'];
    humidity = weather['main']['humidity'];
    wind = weather['wind'];
  }

  @override
  String toString() {
    /// String representation of this object
    return "$temp $clouds $pressure $humidity $wind";
  }

  static Future<Weather> getCurrent(LatLng latlng) async {
    /// Get the current weather conditions at specified position
    ///
    /// Parameter:
    /// LatLng latlng   -   Latitude and longitude of area
    ///
    /// Return:
    /// Future<Weather>

    // Create url for the request
    Uri url = Uri.http(_baseURL, "/data/2.5/weather", {
      "lat": latlng.latitude.toString(),
      "lon": latlng.longitude.toString(),
      "appid": dotenv.env["WEATHER_KEY"]
    });

    // Send GET request, retrieve response
    http.Response res = await http.get(url);

    // Handle response
    if (res.statusCode == 200) {
      Map<dynamic, dynamic> body = jsonDecode(res.body);
      return Weather.fromJSON(body);
    } else {
      throw res.statusCode;
    }
  }
}
