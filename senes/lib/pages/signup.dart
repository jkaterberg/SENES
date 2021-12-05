import 'package:flutter/material.dart';
import 'package:senes/helpers/database_helper.dart';
import 'package:senes/helpers/user.dart';
import 'package:senes/pages/home_page.dart';

/*
Basic welcome page. Image is a placeholder, text inputs can be changed around depending on what we decide we need
TODO:
  - Take input when button pressed
  - Validate inputs
  - Insert validated data into the database
*/

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);

  static const routename = '/signup';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController fname = TextEditingController();
    TextEditingController lname = TextEditingController();
    TextEditingController age = TextEditingController();

    return Scaffold(
        body: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: const [
                    Image(
                        image: NetworkImage(
                            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.onlinewebfonts.com%2Fsvg%2Fimg_427844.png&f=1&nofb=1'),
                        width: 200,
                        color: Colors.orange),
                    Text("SENES",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 20))
                  ]),
                  const Text("Sign Up",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          controller: fname,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'First Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: lname,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Last Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: age,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: 'Age'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                            } else if (int.tryParse(value) == null) {
                              return "Value must be a number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          child: const Text("Submit"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              //create user from form data
                              User user = User.newUser(
                                  fname.text + " " + lname.text,
                                  int.parse(age.text));

                              //insert into db
                              DBHelper.dbHelper.insertUser(user);

                              //navigate to home page
                              Navigator.popAndPushNamed(
                                  context, HomePage.routename);
                            }
                          },
                        )
                      ]),
                  const SizedBox(height: 50)
                ])));
  }
}
