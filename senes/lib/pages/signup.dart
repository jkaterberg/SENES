import 'package:flutter/material.dart';

/*
Basic welcome page. Image is a placeholder, text inputs can be changed around depending on what we decide we need
TODO:
  - Take input when button pressed
  - Validate inputs
  - Insert validated data into the database
*/

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  static const routename = '/signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(children: [
        Container(
            child: Align(
                alignment: Alignment(-1, -1),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                ))),
        const Image(
            image: NetworkImage(
                'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.onlinewebfonts.com%2Fsvg%2Fimg_427844.png&f=1&nofb=1'),
            width: 200,
            color: Colors.orange),
        Text("SENES",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20))
      ]),
      const Text("Sign Up",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        const TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'First Name')),
        const SizedBox(height: 10),
        const TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Last Name')),
        const SizedBox(height: 10),
        const TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'E-Mail')),
        const SizedBox(height: 10),
        ElevatedButton(
          child: const Text("Submit"),
          onPressed: () {},
        )
      ]),
      const SizedBox(height: 50)
    ]));
  }
}
