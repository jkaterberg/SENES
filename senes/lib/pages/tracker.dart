import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:senes/widgets/map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Tracker extends StatelessWidget {
  const Tracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime startTime = DateTime.now();
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        // Save the workout information, return to main screen
      }),
      body: MapWidget(
        dotenv.env["MAP_URL"]!,
        dotenv.env["MAP_TOKEN"]!,
      ),
    );
  }
}
