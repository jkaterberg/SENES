import 'package:flutter/material.dart';
import 'package:senes/map_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final String url = 'MAPBOX_URL_HERE';
  final String token = 'MAPBOX_ACCESS_TOKEN_HERE';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapWidget(url, token),
    );
  }
}
