import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<void> addKarigarData(
      Map<String, String> karigarData, String khataId) async {
    await Firestore.instance
        .collection("khata")
        .document(khataId)
        .setData(karigarData)
        .catchError((e) {
      print(e.toString());
    });
  }
  Future<void> addKarigarDailyData(Map<String,dynamic> dailyData,String khataId,String dataId)async{
    await Firestore.instance.collection("khata").document(khataId).collection("DailyData").document(dataId).setData(dailyData).catchError((e){
      print(e.toString());
    });
  }
   getKarigarData()async{
    return await Firestore.instance.collection("khata").snapshots();
  }
  getKarigarDataForSearch()async{
    var data = await Firestore.instance.collection("khata").getDocuments();
    return data.documents;
  }
  getKarigarbalance(String khataId)async{
    return await Firestore.instance.collection("khata").document(khataId).get();
  }
  getKarigarbalanceUpdate(String khataId)async{
    return await Firestore.instance.collection("khata");
  }
  getKarigarDailyData(String khataId)async{
    return await Firestore.instance.collection("khata").document(khataId).collection("DailyData").snapshots();
  }
}
