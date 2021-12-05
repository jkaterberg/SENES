import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:senes/helpers/database_helper.dart';
import 'package:senes/helpers/future_workout.dart';

class ScheduleWorkoutPage extends StatefulWidget {
  static const String routename = '/schedule';

  @override
  _ScheduleWorkoutPageState createState() => _ScheduleWorkoutPageState();
}

class _ScheduleWorkoutPageState extends State<ScheduleWorkoutPage> {
  final TextEditingController timeController = TextEditingController();
  final DateFormat dayFormat = DateFormat('yyyy-MM-dd');
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //TODO I think somewhere in here might be the best place for notifications

  @override
  Widget build(BuildContext context) {
    MaterialLocalizations.of(context)
        .timeOfDayFormat(alwaysUse24HourFormat: true);
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
                      validator: (value) {
                        return null;
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today), labelText: 'Date'),
                    ),
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
                      validator: (value) {
                        return null;
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.access_time), labelText: 'Time'),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          icon: Icon(Icons.timer),
                          labelText: 'Goal Duration (mins)'),
                      controller: goalController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a goal";
                        } else if (int.tryParse(value) == null) {
                          return "Invalid Input";
                        }
                      },
                    ),
                    TextFormField(
                      controller: noteController,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.note_add), labelText: "Notes"),
                    ),
                    ElevatedButton(
                      child: const Text("Submit"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //Insert info into db
                          DBHelper.dbHelper.insertFuture(FutureWorkout(
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
