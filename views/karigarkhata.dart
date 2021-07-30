import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khatacheck/services/database.dart';
import 'package:khatacheck/views/showkarigardailydata.dart';
import 'package:khatacheck/widget/widgets.dart';

import 'addshirtlower.dart';

class KarigarKhata extends StatefulWidget {
  final String khataId;
  const KarigarKhata({Key? key,required this.khataId}) : super(key: key);

  @override
  _KarigarKhataState createState() => _KarigarKhataState();
}

class _KarigarKhataState extends State<KarigarKhata> {
  Stream<QuerySnapshot>? karigarDailyStream;
  DatabaseService databaseService = new DatabaseService();
  String b="";
  int balance=0;
  Widget karigarDailyDataList() {
    Widget save = Container(
      margin:EdgeInsets.symmetric(horizontal:18),
      child:StreamBuilder<QuerySnapshot>(
        stream: karigarDailyStream,
        builder: (context,snapshot){
          return snapshot.data==null?Center(
          ):GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
              itemCount: snapshot.data!.documents.length,
              itemBuilder: (context,index){
                balance = balance + int.parse(snapshot.data!.documents[index].data["aayi"])*int.parse(snapshot.data!.documents[index].data["rate"]);
                print(balance.toString());
                var collection = Firestore.instance.collection('khata');
                collection
                    .document(widget.khataId) // <-- Doc ID where data should be updated.
                    .updateData({'balance':balance.toString()});
                return ShowKarigarDailyData(
                  rate: snapshot.data!.documents[index].data["rate"],
                  lower: snapshot.data!.documents[index].data["lower"],
                  shirt: snapshot.data!.documents[index].data["shirt"],
                  dataId: snapshot.data!.documents[index].data["dataId"],
                  quantity: snapshot.data!.documents[index].data["quantity"],
                  aayi:snapshot.data!.documents[index].data["aayi"],
                  khataId:widget.khataId,
                );
              });
        },
      ),
    );
    // setState(() {
    //   print(balance.toString());
    //   print(widget.khataId);
    //   var collection = Firestore.instance.collection('khata');
    //   collection
    //       .document(widget.khataId) // <-- Doc ID where data should be updated.
    //       .updateData({'balance':"233"});
    // });
    return save;
  }
  @override
  void initState() {
    // TODO: implement initState

    databaseService.getKarigarDailyData(widget.khataId).then((val){
      setState(() {
        karigarDailyStream = val;
      });
    });
    // databaseService.getKarigarbalance(widget.khataId).then((val){  // for taking previous cache balance
    //   setState(() {
    //     b = val.data['balance'];
    //     print(b);
    //     balance = 0;
    //     karigarDailyDataList();  // for updating
    //   });
    // });
    print("${widget.khataId}");
    super.initState();
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
      body: karigarDailyDataList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddShirtLower(khataId: widget.khataId),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

