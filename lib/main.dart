import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'otp.dart';
import 'package:otp_generator/otp.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'User Registration Form';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        backgroundColor: Color(0xff84FFFF),
        appBar: AppBar(
          title: Text(appTitle),
          backgroundColor: Colors.blueGrey,
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

//class HomePageState extends State<HomePage> {

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  var pwd;



  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _controller = TextEditingController();

  String value = "";
  bool disabledropdown = true;
  List<DropdownMenuItem<String>> menuitems = List();


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value.isEmpty ||
                  RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'email'),
            validator: (value) {
              if (value.isEmpty ||
                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                return 'Enter a valid email id';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Phone Number'),
            validator: (value) {
              String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
              RegExp regExp = new RegExp(pattern);
              if (value.length == 0) {

                return 'Please enter mobile number';
              }
              else if (!regExp.hasMatch(value)) {
                return 'Please enter valid mobile number';
              }
              return null;
            },
            controller: _controller,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'User name'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your initials or nick name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _pass,
            key: passKey,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              //var pwd = value;
              if (value.isEmpty) {
                return 'Please enter a combination of letters, numbers and symbols';
              }
              return null;
            },
          ),
          TextFormField(
              controller: _confirmPass,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) return 'Empty';
                if (value != _pass.text) return 'Not Match';
                return null;
              }
            //_form.currentState.validate()
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder:(context)=>OTPScreen(_controller.text))
                  );
                }
              },
              child: Text('Submit'),
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.orange),
              ),
            ),
          ),
        ],
      ),
    );
  }
}