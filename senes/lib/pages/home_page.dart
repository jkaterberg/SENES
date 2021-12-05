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

  @override
  Widget build(BuildContext context) {
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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            if (_tabController.index == 0) {
              Navigator.pushNamed(context, Tracker.routename);
              setState(() => print('updating'));
            } else if (_tabController.index == 1) {
              Navigator.pushNamed(context, ScheduleWorkoutPage.routename);
              setState(() => print("updating"));
            }
          },
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            FutureBuilder(
              future: DBHelper.dbHelper.getPrevious(),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: const Icon(Icons.add_task_outlined),
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
            // for past workouts
            // for scheduled workouts
            FutureBuilder(
                future: DBHelper.dbHelper.getFutures(),
                builder:
                    (context, AsyncSnapshot<List<FutureWorkout>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data!
                            .length, // set to scheduledWorkouts for production
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: const Icon(Icons.add_task_outlined),
                            trailing: Text(snapshot.data![index].goal
                                .toString()
                                .split('.')
                                .first
                                .padLeft(8, "0")),
                            title: Text(DateFormat('yyyy-MM-dd').format(snapshot
                                .data![index].time)), // from scheduledWorkouts
                          );
                        });
                  } else {
                    return const SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator());
                  }
                })
          ],
        ));
  }
}
