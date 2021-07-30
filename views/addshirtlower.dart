
import 'package:flutter/material.dart';
import 'package:khatacheck/services/database.dart';
import 'package:khatacheck/views/karigarkhata.dart';
import 'package:khatacheck/widget/widgets.dart';
import 'package:random_string/random_string.dart';

class AddShirtLower extends StatefulWidget {
  final String khataId;

   AddShirtLower({ Key? key, required this.khataId}) : super(key: key);

  @override
  _AddShirtLowerState createState() => _AddShirtLowerState();
}

class _AddShirtLowerState extends State<AddShirtLower> {
  final _formKey = GlobalKey<FormState>();
  late String rate,quantity,dataId,money;
  bool isShirt=false; // by default shirt
  bool isLower=false,_isloading = false;
  DatabaseService databaseService = new DatabaseService();
  uploadKarigarData() async{
    if(_formKey.currentState!.validate()){
      setState(() {
        _isloading = true;
      });
      dataId = randomAlphaNumeric(16);
      int sample = int.parse(rate)*int.parse(quantity);
      money = sample.toString() ;
      Map<String,dynamic> dailyData={
        "rate":rate,
        "dataId":dataId,
        "shirt":isShirt,
        "lower":isLower,
        "quantity":quantity,
        "money":money,
        "aayi":"0",
      };
      await databaseService.addKarigarDailyData(dailyData, widget.khataId, dataId)
      .then((value){
        setState(() {
          _isloading = false;
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
      body: _isloading? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ):Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            TextFormField(
              validator: (val) => val!.isEmpty ? "Qunatity karo fill" : null,
              decoration:
              InputDecoration(hintText: "Qunatity"),
              onChanged: (val) {
                quantity = val;
              },
            ),
            SizedBox(
              height: 6,
            ),
            TextFormField(
              validator: (val) =>
              val!.isEmpty ? "Please enter rate" : null,
              decoration: InputDecoration(hintText: "rate of shirt/lower"),
              onChanged: (val) {
                rate = val;
              },
            ),
            SizedBox(
              height: 20,
            ),


              Row(
                children: [
                  Text('Choose type of worker!',style: TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                children: [
                  Checkbox(value: isShirt, onChanged: (bool?value){
                    setState(() {
                      isShirt  = !isShirt;
                      isLower = !isShirt;
                    });
                  }),
                  Text('Shirt'),
                ],
              ),
              Row(
                children: [
                  Checkbox(value: isLower, onChanged: (bool?value){
                    setState(() {
                      isLower  = !isLower;
                      isShirt  = !isLower;
                    });
                  }),
                  Text('Lower'),
                ],
              ),


            Spacer(),
            GestureDetector(
                onTap: (){
                  uploadKarigarData();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KarigarKhata(khataId: widget.khataId),
                      ));
                },
                child: blueButton(context, "Add")),
            SizedBox(height: 40,)
          ],),
        ),
      ),
    );
  }
}
