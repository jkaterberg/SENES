import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:senes/widgets/map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senes/helpers/openweather_wrapper.dart';

class Tracker extends StatelessWidget {
  const Tracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime startTime = DateTime.now();
    Future<Map<dynamic, dynamic>> weather = Weather.getCurrent();

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        // Save the workout information, return to main screen
        print(startTime);
        print(await weather);
      }),
      body: MapWidget(
        dotenv.env["MAP_URL"]!,
        dotenv.env["MAP_TOKEN"]!,
      ),
    );
  }
}
