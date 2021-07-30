import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khatacheck/helper/functions.dart';
import 'package:khatacheck/main.dart';
import 'package:khatacheck/services/auth.dart';
import 'package:khatacheck/services/database.dart';
import 'package:khatacheck/views/signin.dart';
import 'package:khatacheck/widget/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'create_khata.dart';
import 'karigarkhata.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot>? karigarStream;
  DatabaseService databaseService = new DatabaseService();
  AuthServices authServices = new AuthServices();

  Widget karigarList(){
    return Container(
      child:StreamBuilder<QuerySnapshot>(
      stream: karigarStream,
      builder: (context,snapshot){
        return snapshot.data==null?Center(
          child: Text('Add Khata'),
        ):ListView.builder(
            itemCount: snapshot.data!.documents.length,
            itemBuilder: (context,index){
              return KarigarTile(
                karigarName: snapshot.data!.documents[index].data["name"],
                balance: snapshot.data!.documents[index].data["balance"],
                khataId: snapshot.data!.documents[index].data["khataId"],
                phoneNo:snapshot.data!.documents[index].data["phoneNo"],
                idx:index,
              );
            });
      },
    ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    databaseService.getKarigarData().then((val){
      setState(() {
        karigarStream = val;
      });
    });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        brightness: Brightness.light,

        actions: [
          IconButton(onPressed: () async{
            await authServices.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
          }, icon: Icon(Icons.logout,color: Colors.indigo,))
        ],
      ),
      body: karigarList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateKhata()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
List allImages = [
  'https://carnegieendowment.org/sada/img/photo-essay/20170105/01.jpg',
  'https://images.theconversation.com/files/344067/original/file-20200625-33538-v5k8ab.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=496&fit=clip',
  'https://cdn.vox-cdn.com/thumbor/lpwSX9UMxgoBTKxQJZA2ykGfzvM=/0x0:2400x1600/1200x0/filters:focal(0x0:2400x1600):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/10234535/conscious_001.jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSL1bKbBxb5TpxsTuuoNoDuSabvkboV5pWstQ&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQllesI37KwaKOt1Oz8i4ieUH4ybFGPmp8PKA&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhjXWXjuld_YZqCWqIHpwxsa3RIY6QXZ0iCA&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5Eel608WpjjkS4uc_NBZyyTlVOiSWawYCHA&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5o2EQvEktw4gXSPy_VQfJX7yL3l9xS_QRqw&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9td8S63d1T2GcHYNwv-0R1YEw7dOY1pm4EA&usqp=CAU',
];
String toDelete = "";
Future<Null> createDialogBox(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Do you want to delete?"),
          actions: [
            MaterialButton(
              onPressed: () {
                toDelete = 'cancel';
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ));
              },
              elevation: 5.0,
              child: Text('Cancel'),
            ),
            MaterialButton(
              onPressed: () {
                toDelete = 'delete';
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ));
              },
              elevation: 5.0,
              child: Text('Delete'),
            )
          ],
        );
      });
}
class KarigarTile extends StatelessWidget {
  final String karigarName,balance,khataId,phoneNo;
  final int idx;
  const KarigarTile({Key? key,required this.karigarName,required this.balance,required this.khataId,required this.idx,required this.phoneNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>KarigarKhata(khataId: khataId,)));
      },
      child: Container(
        child: Card(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Image.network(allImages[idx%allImages.length]),
                title: Text(karigarName,style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold),),

                subtitle: Row(
                  children: [
                    Text('Balance  ',style: TextStyle(fontSize: 20,color: Colors.black54),),
                    Text(balance,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: (int.parse(balance)>=0)?Colors.green:Colors.red),),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Details',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w800,fontSize: 18),),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios_outlined,color: Colors.blue,
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: ()async{
                        await createDialogBox(context);
                        print(toDelete);
                        if (toDelete == 'delete') {
                          Firestore.instance
                              .collection("khata")
                              .document(khataId)
                              .delete()
                              .catchError((e) {
                            print(e);
                          });
                          Firestore.instance
                              .collection("khata").document(khataId).collection("DailyData")
                                  .getDocuments().then((snapshot) {
                              for (DocumentSnapshot ds in snapshot.documents){
                              ds.reference.delete();
                              }},);
                        }
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 8,),
                          Text('Delete',style: TextStyle(color: Colors.black,fontSize: 18),),
                          SizedBox(width: 8,),
                          Icon(Icons.delete,color: Colors.red,),
                        ],
                      ),
                    ),
                  Spacer(),
                  GestureDetector(
                    onTap:
                        () => launch("tel:$phoneNo"),
                    child: Row(
                      children: [
                        Text('Call',style: TextStyle(color: Colors.black,fontSize: 18),),
                        SizedBox(width: 8,),
                        Icon(Icons.call),
                      ],
                    ),
                  ),
                    SizedBox(width: 18,),
                ],),
                const SizedBox(height: 16),

            ],
          ),
        ),)
    );
  }
}



/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khatacheck/helper/functions.dart';
import 'package:khatacheck/main.dart';
import 'package:khatacheck/services/auth.dart';
import 'package:khatacheck/services/database.dart';
import 'package:khatacheck/views/signin.dart';
import 'package:khatacheck/widget/widgets.dart';

import 'create_khata.dart';
import 'karigarkhata.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot>? karigarStream;
  DatabaseService databaseService = new DatabaseService();
  AuthServices authServices = new AuthServices();
  TextEditingController _searchContoller = TextEditingController();


  Widget karigarList(){
    return Container(
      child:Column(
        children: [
          TextField( controller: _searchContoller,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
          ),
          ),
          SizedBox(height: 8,),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: karigarStream,
              builder: (context,snapshot){
                return snapshot.data==null?Container():ListView.builder(
                      itemCount: snapshot.data!.documents.length,
                    itemBuilder: (context,index){
                  return KarigarTile(
                    karigarName: snapshot.data!.documents[index].data["name"],
                    balance: snapshot.data!.documents[index].data["balance"],
                    khataId: snapshot.data!.documents[index].data["khataId"],
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
     databaseService.getKarigarData().then((val){
      setState(() {
        karigarStream = val;
      });
    });
     _searchContoller.addListener(_onSearchChanged);
    super.initState();
  }
  _onSearchChanged(){
    print(_searchContoller.text);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _searchContoller.removeListener(_onSearchChanged);
    _searchContoller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        brightness: Brightness.light,
        actions: [
          IconButton(onPressed: () async{
            await authServices.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
          }, icon: Icon(Icons.logout,color: Colors.indigo,))
        ],
      ),
      body: karigarList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateKhata()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class KarigarTile extends StatelessWidget {
  final String karigarName,balance,khataId;
  const KarigarTile({Key? key,required this.karigarName,required this.balance,required this.khataId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>KarigarKhata(khataId: khataId,)));
      },
      child: Container(
        child: Card(
          color: Colors.blueGrey[200],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
               ListTile(
                leading: Image.network("https://i.pinimg.com/originals/53/47/7c/53477c063f0272c24721383ee2497e65.png"),
                title: Text(karigarName,style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold),),

                 subtitle: Row(
                  children: [
                    Text('Balance  ',style: TextStyle(fontSize: 20,color: Colors.black54),),
                    Text(balance,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: (int.parse(balance)>=0)?Colors.green:Colors.red),),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Details',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w800,fontSize: 18),),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios_outlined
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

 */
