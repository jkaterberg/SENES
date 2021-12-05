//@dart=2.10
import 'package:flutter/material.dart';
import 'package:senes/pages/newwp.dart';
import 'package:senes/pages/past_workout.dart';
import 'package:senes/pages/signup.dart';
import 'package:senes/pages/tracker.dart';
import 'package:senes/pages/home_page.dart';
import 'package:senes/helpers/location_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senes/helpers/globals.dart';

Future main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");

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
          primarySwatch: Colors.blue,
        ),
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child),
        initialRoute: HomePage.routename,
        routes: {
          HomePage.routename: (context) => const HomePage(),
          Tracker.routename: (context) => Tracker(),
          PastWorkout.routename: (context) => PastWorkout(),
          SignupPage.routename: (context) => const SignupPage(),
          ScheduleWorkoutPage.routename: (context) => ScheduleWorkoutPage()
        });
  }
}
