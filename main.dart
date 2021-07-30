// @dart=2.9
import 'package:flutter/material.dart';
import 'package:khatacheck/helper/functions.dart';
import 'package:khatacheck/views/home.dart';
import 'package:khatacheck/views/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    checkUserLoggedInStatus();
    super.initState();
  }
  checkUserLoggedInStatus()async{
    HelperFunctions.getUserLoggedInDetails().then((value) {
      setState(() {
        isLoggedIn = true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter dddDemo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (isLoggedIn ?? false) ?Home():SignIn(),
    );
  }
}
