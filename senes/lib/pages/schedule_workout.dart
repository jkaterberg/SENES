import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:senes/helpers/database_helper.dart';
import 'package:senes/helpers/future_workout.dart';

class ScheduleWorkoutPage extends StatefulWidget {
  /// Page to allow user to schedule a workout in the future

  // Route for navigation
  static const String routename = '/schedule';

  const ScheduleWorkoutPage({Key? key}) : super(key: key);

  @override
  _ScheduleWorkoutPageState createState() => _ScheduleWorkoutPageState();
}

class _ScheduleWorkoutPageState extends State<ScheduleWorkoutPage> {
  // Controllers for each text field
  // TODO: Might be cleaner to put these in a list
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController goalController = TextEditingController();

  // Other member variables
  final DateFormat dayFormat = DateFormat('yyyy-MM-dd');
  final _formKey = GlobalKey<FormState>();

  //TODO I think somewhere in here might be the best place for notifications

  @override
  Widget build(BuildContext context) {
    // Force use of superior 24hr clock :)
    MaterialLocalizations.of(context)
        .timeOfDayFormat(alwaysUse24HourFormat: true);

    // Set default text for each field
    dateController.text = dayFormat.format(DateTime.now());
    timeController.text = MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.now(), alwaysUse24HourFormat: true);

    return Scaffold(
        appBar: AppBar(),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Center(
            child: Column(children: <Widget>[
              const Text("Add Workout",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              Form(
                  key: _formKey,
                  child: Column(children: [
                    // Date form field
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2222),
                        ).then((date) {
                          dateController.text = dayFormat.format(date!);
                        });
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today), labelText: 'Date'),
                    ),
                    // Time form field
                    TextFormField(
                      controller: timeController,
                      readOnly: true,
                      onTap: () {
                        showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        ).then((time) {
                          timeController.text =
                              MaterialLocalizations.of(context).formatTimeOfDay(
                                  time!,
                                  alwaysUse24HourFormat: true);
                        });
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.access_time), labelText: 'Time'),
                    ),

                    // Goal duration form field
                    TextFormField(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.timer),
                          labelText: 'Goal Duration (mins)'),
                      controller: goalController,
                      validator: (value) {
                        // Validate that input is a number
                        if (value == null || value.isEmpty) {
                          return "Please enter a goal";
                        } else if (int.tryParse(value) == null) {
                          return "Invalid Input";
                        }
                      },
                    ),

                    // Notes field, for whatever I guess
                    TextFormField(
                      controller: noteController,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.note_add), labelText: "Notes"),
                    ),

                    //Submission button
                    ElevatedButton(
                      child: const Text("Submit"),
                      onPressed: () {
                        // Validate each field
                        if (_formKey.currentState!.validate()) {
                          //Insert info into db
                          DBHelper.dbHelper.insertFuture(FutureWorkout(
                              // Super awful way to parse the date, but it works
                              DateTime.parse(dateController.text +
                                  "T" +
                                  timeController.text),
                              Duration(
                                  milliseconds: int.parse(goalController.text)),
                              noteController.text));

                          Navigator.pop(context);
                        }
                      },
                    ),
                  ])),
            ]),
          )
        ]));
  }
}
