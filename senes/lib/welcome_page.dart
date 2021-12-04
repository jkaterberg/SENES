import 'package:flutter/material.dart';
import 'package:senes/login.dart';
import 'package:senes/signup.dart';
/*
Basic welcome page. Image is a placeholder, text inputs can be changed around depending on what we decide we need
TODO:
  - Take input when button pressed
  - Validate inputs
  - Insert validated data into the database
*/

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    //Update the yaml file to have an asset: - free.jp
                    image: AssetImage("free.jpg"),
                    fit: BoxFit.cover)),
            child: Column(children: <Widget>[
              ElevatedButton(
                child: const Text("Login"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
              ElevatedButton(
                child: Text("Signup"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupPage()));
                },
              )
            ])));
  }
}
