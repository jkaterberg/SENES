import 'package:flutter/material.dart';
import 'package:senes/helpers/workout.dart';
import 'package:senes/pages/past_workout.dart';
import 'package:senes/pages/tracker.dart';

class HomePage extends StatefulWidget{
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: (2), vsync: this);
  }

  // growable list containing all the past workouts
  var pastWorkoutList = <PastWorkout>[];
  var scheduledWorkouts = <Workout>[];

  // this is just a list that is not empty and the contents do not matter.
  var dummyWorkoutList = [0, 1, 3, 5, 1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1];
  /* To do */
  /* Get date and duration data from past workouts and insert into ListTile */

  Widget build(BuildContext context){
    if(dummyWorkoutList.isNotEmpty){ //reminder set to pastWorkoutList for production
      return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Track activity'),
              onTap: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context) => Tracker()),
                );
              }
            )
          ],),
      ),
      appBar: AppBar(
        title: const Text('S.E.N.E.S'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.favorite_border_outlined),
              text: ('PAST WORKOUT'),
            ),
            Tab(
              icon: Icon(Icons.alarm_on_outlined),
              text: ('SCHEDULED'),
            )
          ]
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // for past workouts
          ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: dummyWorkoutList.length, // set to pastWorkoutList for production
            itemBuilder: (BuildContext context, int index){
            return ListTile(
              leading: Icon(Icons.add_task_outlined),
              trailing: Text("Past workout duration"), // from pastWorkoutList
              title: Text("Past Workout date($index)"), // from pastWorkoutList
            );
            }
          ),
          // for scheduled workouts
          ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: dummyWorkoutList.length, // set to scheduledWorkouts for production
            itemBuilder: (BuildContext context, int index){
            return ListTile(
              leading: Icon(Icons.add_task_outlined),
              trailing: Text("Future duration"), // from scheduledWorkouts
              title: Text("workout date ($index)"), // from scheduledWorkouts
            );
            }
          ),
        ],
      )
      );
    }
    else{
      return Scaffold(
      appBar: AppBar(
        title: const Text('S.E.N.E.S')
      ),
      body: Text("No previous workouts")
      );
    }
  }
}