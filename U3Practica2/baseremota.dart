import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

var baseRemota = FirebaseFirestore.instance;

class DB{

  static Future insertar(Map<String, dynamic> persona) async {
    return await baseRemota.collection("AEROPUERTO").add(persona);
  }

  static Future <List> mostrarTodos() async {
    List temporal = [];
    var query = await baseRemota.collection("AEROPUERTO").get();

    query.docs.forEach((element) {
      Map<String, dynamic> dataTemp = element.data();
      dataTemp.addAll({'id': element.id});
      temporal.add(dataTemp);
    });
    return temporal;
  }

  static Future eliminar (String id) async{
    return await baseRemota.collection("AEROPUERTO").doc(id).delete();
  }

  static Future actualizar (Map<String, dynamic> vuelo) async{
    String idActualizar = vuelo['id'];
    vuelo.remove('id');
    return await baseRemota.collection("AEROPUERTO").doc(idActualizar).update(vuelo);
  }

}