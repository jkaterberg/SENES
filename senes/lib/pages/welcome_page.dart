import 'package:flutter/material.dart';
import 'package:senes/pages/login.dart';
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: AssetImage('free.jpg'))),
            child: Center(
                child: ButtonBar(
                    buttonPadding: const EdgeInsets.all(150),
                    children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              child: const Text("Login"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                              },
                            )),
                        ElevatedButton(
                          child: const Text("Signup"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPage()));
                          },
                        )
                      ])
                ]))));
  }
}
