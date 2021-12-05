import 'package:flutter/material.dart';

/*
Basic welcome page. Image is a placeholder, text inputs can be changed around depending on what we decide we need
TODO:
  - Take input when button pressed
  - Validate inputs
  - Insert validated data into the database
*/
class Workout extends StatefulWidget {
  NewWorkoutPage createState() => NewWorkoutPage();
}

class NewWorkoutPage extends State<Workout> {
  DateTime? _dateTime;
  TimeOfDay? _time = TimeOfDay(hour: 15, minute: 1);
  TimeOfDay? picked;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(children: <Widget>[
        Container(
            child: Align(
                alignment: Alignment(-1, -1),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                ))),
        Text("Add Workout",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
      ]),
      const SizedBox(height: 10),
      Center(
        child: Column(children: <Widget>[
          Text(_dateTime == null ? '---- -- --' : _dateTime.toString()),
          ElevatedButton(
              child: Text('Pick a date'),
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2001),
                        lastDate: DateTime(2222))
                    .then((date) {
                  setState(() {
                    _dateTime = date;
                  });
                });
              }),
          Text(_time == null ? '-- --' : _time.toString()),
          ElevatedButton(
              child: Text('Pick a time'),
              onPressed: () {
                showTimePicker(context: context, initialTime: TimeOfDay.now())
                    .then((time) {
                  setState(() {
                    _time = time;
                  });
                });
              }),
          ElevatedButton(
            child: const Text("Submit"),
            onPressed: () {},
          ),
          const SizedBox(height: 300),
          const SizedBox(height: 10),
        ]),
      )
    ]));
  }
}
