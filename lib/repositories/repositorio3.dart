import 'package:lista_tarefas_firebase/models/tarefa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Repositorio3 {
  Repositorio3();

  var db = FirebaseFirestore.instance;

  Future<String> salvarTarefa(Tarefa tarefa) async{
    if (tarefa.id==""){
      var id = await db.collection('tarefas').add(tarefa.toMap()).then((documentSnapshot) => documentSnapshot.id);
      return id.toString();
    }
    else{
      await db.collection('tarefas').doc(tarefa.id).set(tarefa.toMap());
      return tarefa.id;
    }
  }

  Future<void> atualizarTarefa(Tarefa tarefa) async{
    if (tarefa.id!=null){
      //await db.collection('tarefas').doc(tarefa.id).update({"realizado":tarefa.realizado});
      await db.collection('tarefas').doc(tarefa.id).set(tarefa.toMap());
    }
  }

  Future<void> deletarTarefa(Tarefa tarefa) async{
    await db.collection('tarefas').doc(tarefa.id).delete();
  }

  Future<List<Tarefa>> recuperarLista() async{
    List<Tarefa> tarefas = [];
    await db.collection('tarefas').get().then((querySnapshot){
      for (var documento in querySnapshot.docs){
        tarefas.add(Tarefa(titulo:
        documento["titulo"].toString(),
          realizado: documento["realizado"],
          id: documento.id
        ));
      }
    });
    return tarefas;
  }
}