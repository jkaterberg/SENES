import 'package:flutter/material.dart';
import 'package:senes/helpers/database_helper.dart';
import 'package:senes/helpers/future_workout.dart';
import 'package:senes/helpers/workout.dart';
import 'package:senes/pages/newwp.dart';
import 'package:senes/pages/past_workout.dart';
import 'package:senes/pages/tracker.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routename = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: (2), vsync: this);
  }

  // growable list containing all the past workouts
  var pastWorkoutList = <PastWorkout>[];
  var scheduledWorkouts = <Workout>[];

  /* To do */
  /* Get date and duration data from past workouts and insert into ListTile */

  List<String> _pastSelected = [];
  List<String> _futureSelected = [];

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() {
      print('reset');
      setState(() {
        if (_tabController.index == 1) {
          _pastSelected.clear();
        } else if (_tabController.index == 0) {
          print('clear');
          _futureSelected.clear();
        }
      });
    });

    //reminder set to pastWorkoutList for production
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
        appBar: AppBar(
          title: const Text('SENES'),
          bottom: TabBar(controller: _tabController, tabs: const [
            Tab(
              icon: Icon(Icons.favorite_border_outlined),
              text: ('PAST WORKOUT'),
            ),
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
          child: _pastSelected.isEmpty && _futureSelected.isEmpty
              ? const Icon(Icons.add)
              : const Icon(Icons.delete),
          onPressed: () {
            if (_pastSelected.isNotEmpty || _futureSelected.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text("Confirm"),
                        content: Text("Deleting selected workouts"),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                              },
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  for (String i in _pastSelected) {
                                    DBHelper.dbHelper.deletePastWorkout(i);
                                  }
                                  for (String i in _futureSelected) {
                                    DBHelper.dbHelper.deleteFutureWorkout(i);
                                  }
                                });
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text("OK"))
                        ],
                      ));
            } else {
              if (_tabController.index == 0) {
                Navigator.pushNamed(context, Tracker.routename);
                setState(() => print('updating'));
              } else if (_tabController.index == 1) {
                Navigator.pushNamed(context, ScheduleWorkoutPage.routename);
                setState(() => print("updating"));
              }
            }
          },
        ),
        /*
        Tab to view past workouts. Pulls workouts from database and generates 
        a ListTile object to display in ListView
        */
        body: TabBarView(
          controller: _tabController,
          children: [
            FutureBuilder(
              future: DBHelper.dbHelper.getPrevious(),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  //Build the ListView

                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        //Build the List Tile object
                        return ListTile(
                          leading: _pastSelected
                                  .contains(snapshot.data![index]['workoutid'])
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                )
                              : const Icon(Icons.add_task_outlined),
                          trailing: Text(Duration(
                                  milliseconds: snapshot.data![index]
                                      ['duration'])
                              .toString()
                              .split('.')
                              .first
                              .padLeft(8, "0")),
                          title: Text(
                            DateFormat('yyyy-MM-dd').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    snapshot.data![index]['start'])),
                          ),
                          subtitle: Text(DateFormat('HH:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  snapshot.data![index]['start']))),
                          onTap: () => Navigator.pushNamed(
                              context, PastWorkout.routename,
                              arguments: snapshot.data![index]['workoutid']),
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
              future: DBHelper.dbHelper.getFutures(),
              builder: (context, AsyncSnapshot<List<FutureWorkout>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!
                        .length, // set to scheduledWorkouts for production
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading:
                            _futureSelected.contains(snapshot.data![index].id)
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                  )
                                : const Icon(Icons.add_task_outlined),
                        trailing: Text(snapshot.data![index].goal
                            .toString()
                            .split('.')
                            .first
                            .padLeft(8, "0")),
                        title: Text(DateFormat('yyyy-MM-dd')
                            .format(snapshot.data![index].time)),
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
