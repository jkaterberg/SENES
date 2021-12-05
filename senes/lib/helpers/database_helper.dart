// plugin imports
import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

// helper objects
import 'package:senes/helpers/future_workout.dart';
import 'package:senes/helpers/openweather_wrapper.dart';
import 'package:senes/helpers/route_point.dart';
import 'package:senes/helpers/user.dart';
import 'package:senes/helpers/workout.dart';

class DBHelper {
  /// Object to help work with the database
  /// Has getters, setters and removers for the major tables.

  DBHelper._privateConstructor();

  static DBHelper dbHelper = DBHelper._privateConstructor();

  late Database _database;

  Future<Database> get database async {
    _database = await _createDatabase();

    return _database;
  }

  Future<Database> _createDatabase() async {
    /// Create a database object
    /// If database doesn't exist, it will create all the tables. Otherwise it
    /// will access an existing database
    ///
    /// return:
    /// Future<Database>    -   Future for database object
    return await openDatabase(join(await getDatabasesPath(), 'senes.db'),
        onCreate: (Database db, int version) {
      for (String table in _createDatabaseSQL) {
        db.execute(table);
      }
    }, version: 1);
  }

  void _deleteDatabase() async {
    /// DANGEROUS: DELETES ALL TABLES AND ALL DATA STORED IN THE DATABASE
    deleteDatabase(join(await getDatabasesPath(), 'senes.db'));
  }

  Future<void> deletePastWorkout(String id) async {
    /// Deletes specified past workout from database
    ///
    /// Parameters:
    /// String id   -   unique identifier of desired database
    //connect to db
    Database db = await _createDatabase();

    //send the query
    db.delete('pastworkout', where: 'workoutid = ?', whereArgs: [id]);
  }

  Future<User?> getUser() async {
    /// Gets user from db
    ///
    /// returns Future<User?>   -   user information

    //connect to db
    Database db = await _createDatabase();

    //query the database
    List<Map<String, dynamic>> data = await db.query('user');

    // Construct and return user object
    if (data.isNotEmpty) {
      return User(data[0]['name'], data[0]['age'], data[0]['userid']);
    }
    return null;
  }

  void insertUser(User data) async {
    /// Inserts user information into db
    ///
    /// parameters:
    /// User data   -   User object containing user's info

    //Connect to db
    Database db = await _createDatabase();

    // insert the info
    db.insert('user', {'age': data.age, 'name': data.name, 'userid': data.id});
  }

  void insertFuture(FutureWorkout data) async {
    /// Inserts a new Scheduled workout into the database
    ///
    /// Parameters:
    /// FutureWorkout data  -   data for scheduled workout

    //Connect to db
    Database db = await _createDatabase();

    // Insert into db
    await db.insert('futureworkout', {
      'workoutid': data.id,
      'time': data.time.millisecondsSinceEpoch,
      'goal': data.goal.inMilliseconds,
      'route': data.route,
    });

    //cleanup
    await db.close();
  }

  Future<void> deleteFutureWorkout(String id) async {
    /// Removes scheduled workout from database asynchronously
    ///
    /// Parameters:
    ///  String id    -   Unique identifier for FutureWorkout object

    // Connect to database
    Database db = await _createDatabase();

    //Delete specified object from table
    db.delete('futureworkout', where: 'workoutid = ?', whereArgs: [id]);
  }

  Future<List<FutureWorkout>> getFutures() async {
    /// Retrieve all scheduled workouts in database
    ///
    /// Return:
    ///  List of FutureWorkout objects

    // Connect to database
    Database db = await _createDatabase();

    // Perform query
    List<Map<String, dynamic>> data = await db.query('futureworkout');

    // Construct object from query result
    List<FutureWorkout> futures = [];
    for (Map<String, dynamic> future in data) {
      futures.add(FutureWorkout.existing(
          DateTime.fromMillisecondsSinceEpoch(future['time']),
          Duration(minutes: future['goal']),
          future['note'],
          future['workoutid']));
    }

    // return list of workouts
    return futures;
  }

  Future<FutureWorkout?> getFuture(String id) async {
    /// Retrieve scheduled workout from database
    ///
    /// Parameters:
    /// String id   -   id of scheduled workout
    ///
    /// Return
    /// FutureWorkout

    //Connect to db
    Database db = await _createDatabase();

    //Perform query
    List<Map<String, dynamic>> data = await db
        .query('futureworkout', where: "workoutid = ?", whereArgs: [id]);

    await db.close();

    // Construct object from query results
    if (data.isNotEmpty) {
      return FutureWorkout(data[0]['time'], data[0]['goal'], data[0]['notes']);
    }
    return null;
  }

  Future<void> insertWorkout(Workout data) async {
    /// insertWorkout(Workout data)
    /// Inserts the given workout into the database
    /// All info stored by workout object is put into appropriate database tables
    ///
    /// Parameters:
    /// Workout data    -   Workout object that holds all relevant data

    //Connect to db
    Database db = await _createDatabase();

    //Things to go into weather table
    String wid = data.weather.weatherid;
    double temp = data.weather.temp!;
    String clouds = data.weather.clouds!;
    double windSpeed = data.weather.wind!["speed"];
    int windDir = data.weather.wind!['deg'];
    int pressure = data.weather.pressure!;
    int humidity = data.weather.humidity!;

    //Create weather tuple
    await db.insert('weather', {
      'weatherid': wid,
      'clouds': clouds,
      'pressure': pressure,
      'humidity': humidity,
      'wind_speed': windSpeed,
      'wind_direction': windDir,
      'temperature': temp,
    });

    String rid = const Uuid().v4();
    // Generate each point individually
    for (RoutePoint point in data.route) {
      //Things for point to store
      String pid = const Uuid().v4();
      double latitude = point.latlng.latitude;
      double longitude = point.latlng.longitude;
      double altitude = point.altitude;
      int time = point.time.millisecondsSinceEpoch;

      // Construct and insert point tuple into table
      await db.insert('points', {
        'pointid': pid,
        'routeid': rid,
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'time': time
      });
    }

    //Things to go into workout table
    String id = data.workoutID;
    int start = data.startTime.millisecondsSinceEpoch;
    int end = data.endTime.millisecondsSinceEpoch;
    int duration = data.duration.inMilliseconds;

    // Construct and insert workout tuple
    await db.insert('pastworkout', {
      'workoutid': id,
      'start': start,
      'end': end,
      'duration': duration,
      'weather': wid,
      'route': rid
    });

    await db.close();
  }

  Future<List<Map<String, dynamic>>> getPrevious() async {
    /// Retrieve all saved workouts that have been completed
    ///
    /// Return:
    /// List<Map<String,dynamic>> -  Map of relevant information for the workout
    ///     Has indices 'workoutid', 'start', 'duration'

    //Connect to db
    Database db = await _createDatabase();

    // query db for all past workouts
    List<Map<String, dynamic>> data = await db
        .query('pastworkout', columns: ['workoutid', 'start', 'duration']);

    await db.close();

    // return list
    return data;
  }

  Future<Workout?> getWorkout(String id) async {
    ///getWorkout(String id)
    ///Fetches workout with specified id from database
    ///returns Future for Workout object

    // connect to db
    Database db = await _createDatabase();

    //get data from workout table
    Map<String, dynamic> data = (await db
        .query("pastworkout", where: 'workoutid = ?', whereArgs: [id]))[0];

    // successfully found data
    if (data.isNotEmpty) {
      // get data for Weather object
      Map<String, dynamic> weatherData = (await db.query('weather',
          where: 'weatherid = ?', whereArgs: [data['weather']]))[0];

      //Construct weather object
      Weather weather = Weather(
          weatherData['temperature'],
          weatherData['clouds'],
          weatherData['pressure'],
          weatherData['humidity'], {
        'speed': weatherData['wind_speed'],
        'deg': weatherData['wind_direction']
      });

      // get data for route
      List<Map<String, dynamic>> routeData = await db
          .query('points', where: 'routeid = ?', whereArgs: [data['route']]);

      //close db
      await db.close();

      //Generate list of points
      List<RoutePoint> points = List.generate(routeData.length, (int i) {
        return RoutePoint.withTime(
            LatLng(routeData[i]['latitude'], routeData[i]['longitude']),
            routeData[i]['altitude'].toDouble(),
            DateTime.fromMillisecondsSinceEpoch(routeData[i]['time']));
      });

      // Construct workout object
      Workout workout = Workout(
          DateTime.fromMillisecondsSinceEpoch(data['start']),
          DateTime.fromMillisecondsSinceEpoch(data['end']),
          weather,
          points);

      return workout;
    } else {
      return null;
    }
  }

  // List of all queries required to generate the database
  // Database was designed in DB Browser for SQLite
  // Much of the sql was also generated using this program, although
  // modifications were made to make it play nice with sqflite
  final List<String> _createDatabaseSQL = [
    """
CREATE TABLE "user" (
	"userid"	TEXT NOT NULL,
	"name"	TEXT NOT NULL,
	"age"	INTEGER NOT NULL,
	PRIMARY KEY("userid")
);""",
    """CREATE TABLE "futureworkout" (
	"workoutid"	TEXT NOT NULL,
	"time"	INTEGER NOT NULL,
  "goal"  INTEGER NOT NULL,
  "notes" STRING,
	"route"	INTEGER,
	FOREIGN KEY("route") REFERENCES "route"("routeid"),
	PRIMARY KEY("workoutid")
);""",
    """CREATE TABLE "pastworkout" (
	"workoutid"	TEXT NOT NULL,
	"start"	INTEGER NOT NULL,
	"end"	INTEGER NOT NULL,
	"duration"	INTEGER NOT NULL,
	"weather"	TEXT NOT NULL,
	"route"	TEXT NOT NULL,
	FOREIGN KEY("route") REFERENCES "points"("routeid"),
	FOREIGN KEY("weather") REFERENCES "weather"("weatherid"),
	PRIMARY KEY("workoutid")
);""",
    """CREATE TABLE "points" (
	"pointid"	TEXT NOT NULL,
	"routeid"	TEXT NOT NULL,
	"latitude"	NUMERIC NOT NULL,
	"longitude"	NUMERIC NOT NULL,
	"time"	INTEGER NOT NULL,
	"altitude"	NUMERIC NOT NULL
);""",
    """CREATE TABLE "weather" (
	"weatherid"	TEXT NOT NULL,
	"clouds"	TEXT NOT NULL,
	"pressure"	INTEGER NOT NULL,
	"humidity"	INTEGER NOT NULL,
	"wind_speed"	NUMERIC NOT NULL,
	"wind_direction"	INTEGER NOT NULL,
	"temperature"	NUMERIC NOT NULL,
	PRIMARY KEY("weatherid")
);"""
  ];
}
