import 'package:flutter/material.dart';
import 'package:khatacheck/services/database.dart';
import 'package:khatacheck/views/showkarigardailydata.dart';
import 'package:khatacheck/widget/widgets.dart';
import 'package:random_string/random_string.dart';

import 'addshirtlower.dart';
import 'karigarkhata.dart';

class CreateKhata extends StatefulWidget {
  const CreateKhata({Key? key}) : super(key: key);

  @override
  _CreateKhataState createState() => _CreateKhataState();
}

class _CreateKhataState extends State<CreateKhata> {
  final _formKey = GlobalKey<FormState>();
  late String karigarName, phoneNo, khataNo, balance, khataId;
  DatabaseService databaseService = new DatabaseService();
  bool _isloading = false;
  CreateKhataOnline() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      khataId = randomAlphaNumeric(16);
      Map<String, String> KarigarMap = {
        "khataId": khataId,
        "name": karigarName,
        "phoneNo": phoneNo,
        "balance": balance,
        "khataNo": khataNo,
      };
      await databaseService.addKarigarData(KarigarMap, khataId).then((value) {
        setState(() {
          _isloading = false;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => KarigarKhata(khataId: khataId,),
              ));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        brightness: Brightness.light,
      ),
      body: _isloading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Enter name" : null,
                      decoration:
                          InputDecoration(hintText: "Karigar/worker name"),
                      onChanged: (val) {
                        karigarName = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter valid phone number" : null,
                      decoration: InputDecoration(hintText: "Phone Number"),
                      onChanged: (val) {
                        phoneNo = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter valid Khata number" : null,
                      decoration: InputDecoration(hintText: "Khata Number"),
                      onChanged: (val) {
                        khataNo = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Balance is Required" : null,
                      decoration: InputDecoration(hintText: "Balance"),
                      onChanged: (val) {
                        balance = val;
                      },
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          CreateKhataOnline();
                        },
                        child: blueButton(context, "Create Khata")),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
