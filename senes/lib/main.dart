//@dart=2.10
import 'package:flutter/material.dart';
import 'package:senes/helpers/database_helper.dart';
import 'package:senes/pages/login.dart';
import 'package:senes/pages/newwp.dart';
import 'package:senes/pages/past_workout.dart';
import 'package:senes/pages/signup.dart';
import 'package:senes/pages/tracker.dart';
import 'package:senes/pages/home_page.dart';
import 'package:senes/helpers/location_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senes/helpers/globals.dart';

String start;
Future main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");

  if ((await DBHelper.dbHelper.getUser() != null)) {
    start = HomePage.routename;
  } else {
    start = SignupPage.routename;
  }

  // Check for proper permissions
  Global.LOCATION_PERMISSION = await LocationHelper.checkPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child),
        initialRoute: start,
        routes: {
          HomePage.routename: (context) => const HomePage(),
          Tracker.routename: (context) => Tracker(),
          PastWorkout.routename: (context) => PastWorkout(),
          SignupPage.routename: (context) => SignupPage(),
          ScheduleWorkoutPage.routename: (context) => ScheduleWorkoutPage()
        });
  }
}
