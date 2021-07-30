import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'karigarkhata.dart';

class ShowKarigarDailyData extends StatefulWidget {
  final String rate,dataId,quantity,khataId,aayi;
  final bool lower,shirt;
  const ShowKarigarDailyData({Key? key,required this.rate,required this.lower,required this.shirt,required this.dataId,required this.quantity,required this.khataId,required this.aayi}) : super(key: key);

  @override
  _ShowKarigarDailyDataState createState() => _ShowKarigarDailyDataState();
}

class _ShowKarigarDailyDataState extends State<ShowKarigarDailyData> {
  String kiniAayi = "";
  String toAdd = "no";
  final _formKey = GlobalKey<FormState>();
  Future<Null> createDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              title: Text("Kinni Aayiyan?"),
              actions: [
                TextFormField(
                  validator: (val) {
                    print("inside");
                    print(val);
                    print(widget.quantity);
                    return int.parse(val!)>int.parse(widget.quantity) ? "Please enter correctly" : null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter no of shirts/lower",
                    contentPadding: EdgeInsets.all(10),
                  ),
                  onChanged: (val) {
                    kiniAayi = val;
                  },

                ),
                MaterialButton(
                  onPressed: () {
                    toAdd = 'Add';
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => KarigarKhata(khataId: widget.khataId,),
                    //     ));
                    Navigator.pop(context);
                  },
                  elevation: 5.0,
                  child: Text('Add'),
                )
              ],
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
        await createDialogBox(context);
        print(toAdd);
        if (toAdd == 'Add') {
          // String prev = "";
          // await Firestore.instance.collection('khata').document(widget.khataId)
          //     .get().then((documentSnapshot) =>
          //     prev = documentSnapshot.data['balance'].toString(),
          // );
          // int newBalance = int.parse(prev) - int.parse(widget.aayi)*int.parse(widget.rate);
          // var collectionss = Firestore.instance.collection('khata');
          // collectionss
          //     .document(widget.khataId) // <-- Doc ID where data should be updated.
          //     .updateData({'balance':newBalance.toString()});
          var collection = Firestore.instance.collection('khata');
          collection
              .document(widget.khataId).collection('DailyData').document(widget.dataId) // <-- Doc ID where data should be updated.
              .updateData({'aayi':kiniAayi});
        }
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          margin: EdgeInsets.symmetric(horizontal:8,vertical:8),
          child: Center(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 8,),
                Expanded(child: Image.network((widget.lower==true)?"https://5.imimg.com/data5/WJ/RV/MY-15195742/68807lowers3-500x500.jpg":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRA3uHD7A5rz3CsqRthsXumk1ew9dD-mUvrg&usqp=CAU",)),
                Text("Quantity: ${widget.quantity}",style:TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
                Text("Aayian: ${widget.aayi}",style:TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
                Text("Rate: Rs ${widget.rate}",style:TextStyle(fontSize: 18)),
                SizedBox(height: 8,),
              ],
          ),
          ),
      ),
    );
  }
}

/*
child: Card(
          color: Colors.blueGrey[200],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Image.network("https://i.pinimg.com/originals/53/47/7c/53477c063f0272c24721383ee2497e65.png"),
                title: Text("Rate: Rs${widget.rate}",style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold),),

                subtitle: Column(
                  children: [
                    Text((widget.lower==true)?"Lower":"Shirt",style: TextStyle(fontSize: 20,color: Colors.black54),),
                    Text("Quantity ${widget.quantity}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.red),),
                  ],
                ),
              ),
            ],
          ),
        ),
 */