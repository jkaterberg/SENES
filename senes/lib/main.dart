//@dart=2.10
import 'package:flutter/material.dart';
import 'package:senes/helpers/database_helper.dart';
import 'package:senes/pages/schedule_workout.dart';
import 'package:senes/pages/past_workout.dart';
import 'package:senes/pages/signup.dart';
import 'package:senes/pages/tracker.dart';
import 'package:senes/pages/home.dart';
import 'package:senes/helpers/location_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senes/helpers/globals.dart';

Future main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Determine if this is first time startup
  String start;
  if ((await DBHelper.dbHelper.getUser() != null)) {
    start = HomePage.routename;
  } else {
    start = SignupPage.routename;
  }

  // Check for proper permissions
  Global.LOCATION_PERMISSION = await LocationHelper.checkPermissions();

  // Start the application
  runApp(MyApp(start));
}

class MyApp extends StatelessWidget {
  MyApp(this.start, {Key key}) : super(key: key);

  String start;

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
          PastWorkout.routename: (context) => const PastWorkout(),
          SignupPage.routename: (context) => SignupPage(),
          ScheduleWorkoutPage.routename: (context) =>
              const ScheduleWorkoutPage()
        });
  }
}
