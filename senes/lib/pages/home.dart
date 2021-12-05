import 'package:flutter/material.dart';
import 'package:senes/helpers/database_helper.dart';
import 'package:senes/helpers/future_workout.dart';
import 'package:senes/helpers/workout.dart';
import 'package:senes/pages/schedule_workout.dart';
import 'package:senes/pages/past_workout.dart';
import 'package:senes/pages/tracker.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  /// Main page of the SENES app.
  /// Has two tabs,
  ///   one to display completed workouts
  ///   one to display scheduled workouts
  ///
  /// Hub for all the other pages

  //constructor
  const HomePage({Key? key}) : super(key: key);

  // route name for navigation
  static const String routename = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Member variables
  late TabController _tabController;
  final List<String> _pastSelected = [];
  final List<String> _futureSelected = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: (2), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // Add listener that clears the selected items whenever tabs are switched
    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 1) {
          _pastSelected.clear();
        } else if (_tabController.index == 0) {
          _futureSelected.clear();
        }
      });
    });

    // Widget to return
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                  title: const Text('Track activity'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Tracker()),
                    );
                  })
            ],
          ),
        ),
        /*
        App bar for the page. Holds the title and tab bar
        */
        appBar: AppBar(
          title: const Text('SENES'),
          bottom: TabBar(controller: _tabController, tabs: const [
            //Past Workout Tab
            Tab(
              icon: Icon(Icons.favorite_border_outlined),
              text: ('PAST WORKOUT'),
            ),
            // Scheduled Workout Tab
            Tab(
              icon: Icon(Icons.alarm_on_outlined),
              text: ('SCHEDULED'),
            )
          ]),
        ),

        /*
        Floating action button - serves two purposes
          1. If no items are selected, then it will take actions to add new 
              items
          2. If items are selected, will remove them from the database
        */
        floatingActionButton: FloatingActionButton(
          // display the appropriate icon depending on if items are selected
          child: _pastSelected.isEmpty && _futureSelected.isEmpty
              ? const Icon(Icons.add)
              : const Icon(Icons.delete),

          // Button action
          onPressed: () {
            // If items are selected, try to delete them
            if (_pastSelected.isNotEmpty || _futureSelected.isNotEmpty) {
              //Show confirmation dialog
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text("Deleting selected workouts"),
                        actions: <Widget>[
                          // Cancel delete operation
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                              },
                              child: const Text("Cancel")),

                          // Proceed with delete operation
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  // Remove selected items from database
                                  for (String i in _pastSelected) {
                                    DBHelper.dbHelper.deletePastWorkout(i);
                                  }
                                  for (String i in _futureSelected) {
                                    DBHelper.dbHelper.deleteFutureWorkout(i);
                                  }
                                });
                                //close alert
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text("OK"))
                        ],
                      ));
              //No items selected
            } else {
              //First tab, go to Tracker page to start a new workout
              if (_tabController.index == 0) {
                Navigator.pushNamed(context, Tracker.routename);

                //Second tab, go to page to schedule new workout
              } else if (_tabController.index == 1) {
                Navigator.pushNamed(context, ScheduleWorkoutPage.routename);
              }
            }
          },
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            /*
            Tab to view past workouts. Pulls workouts from database and generates 
            a ListTile object to display in ListView
            */
            // Wait for the app to load info from database
            FutureBuilder(
              // Get all the saved, completed workouts
              future: DBHelper.dbHelper.getPrevious(),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  //Build the ListView once we have data
                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        //Build the List Tile object
                        return ListTile(
                          // Show different icon if item is selected
                          leading: _pastSelected
                                  .contains(snapshot.data![index]['workoutid'])
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                )
                              : const Icon(Icons.task),

                          // Generate text to display duration of workout
                          trailing: Text(Duration(
                                  milliseconds: snapshot.data![index]
                                      ['duration'])
                              .toString()
                              .split('.')
                              .first
                              .padLeft(8, "0")),

                          // Generate text to display date of workout
                          title: Text(
                            DateFormat('yyyy-MM-dd').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    snapshot.data![index]['start'])),
                          ),

                          // Generate text to display time of workout
                          subtitle: Text(DateFormat('HH:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.data![index]['start']))),

                          // If item is tapped, push page to display workout info
                          onTap: () => Navigator.pushNamed(
                              context, PastWorkout.routename,
                              arguments: snapshot.data![index]['workoutid']),

                          // On long press, select item to be deleted
                          onLongPress: () {
                            setState(() {
                              if (!_pastSelected.contains(
                                  snapshot.data![index]['workoutid'])) {
                                _pastSelected
                                    .add(snapshot.data![index]['workoutid']);
                              } else {
                                _pastSelected
                                    .remove(snapshot.data![index]['workoutid']);
                              }
                            });
                          },
                        );
                      });
                } else {
                  // Loading widget
                  return const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator());
                }
              },
            ),
            /*
            Tab for scheduled workouts. Retrieves them from a database and 
            builds them as a list tile for display in a ListView
            */
            FutureBuilder(
              // Get all scheduled workouts from db
              future: DBHelper.dbHelper.getFutures(),

              //Build handle results
              builder: (context, AsyncSnapshot<List<FutureWorkout>> snapshot) {
                if (snapshot.hasData) {
                  // Build listview
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!
                        .length, // set to scheduledWorkouts for production
                    itemBuilder: (BuildContext context, int index) {
                      // Build list tile form each workout
                      return ListTile(
                        // Show different icon if selected
                        leading:
                            _futureSelected.contains(snapshot.data![index].id)
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                  )
                                : const Icon(Icons.access_time),

                        // Generate text for duration
                        trailing: Text(snapshot.data![index].goal
                            .toString()
                            .split('.')
                            .first
                            .padLeft(8, "0")),

                        // Generate text for planned date
                        title: Text(DateFormat('yyyy-MM-dd')
                            .format(snapshot.data![index].time)),

                        // Mark item for deletion
                        onLongPress: () {
                          setState(() {
                            if (!_futureSelected
                                .contains(snapshot.data![index].id)) {
                              _futureSelected.add(snapshot.data![index].id);
                            } else {
                              _futureSelected.remove(snapshot.data![index].id);
                            }
                          });
                        }, // from scheduledWorkouts
                      );
                    },
                  );
                } else {
                  //Loading widget
                  return const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator());
                }
              },
            )
          ],
        ));
  }
}
