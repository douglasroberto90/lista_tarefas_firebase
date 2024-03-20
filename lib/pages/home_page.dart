import 'package:flutter/material.dart';
import 'package:lista_tarefas_firebase/models/tarefa.dart';
import 'package:lista_tarefas_firebase/repositories/repositorio3.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controlerTarefa = TextEditingController();

  Repositorio3 _repositorio = Repositorio3();
  List<Tarefa> tarefas = [];

  @override
  void initState() {
    super.initState();
    _repositorio.recuperarLista().then((dados) {
      setState(() {
        tarefas = dados;
      });
    });
  }

  Future<void> _adicionarTarefa() async {
    Tarefa tarefa = Tarefa(titulo: controlerTarefa.text, realizado: false);
    tarefa.id = await _repositorio.salvarTarefa(tarefa);
    setState(() {
      tarefas.add(tarefa);
      controlerTarefa.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        title: Text(
          "Lista de tarefas"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 10.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: "Nova tarefa"),
                      controller: controlerTarefa,
                    )),
                ElevatedButton(onPressed: _adicionarTarefa, child: Text("ADD"))
              ],
            ),
          ),
          Expanded(child: ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: contruirListView))
        ],
      ),
    );
  }

  Widget contruirListView(BuildContext context, int index) {
    return Dismissible(
        key: Key(DateTime
            .now()
            .microsecondsSinceEpoch
            .toString()),
        background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        direction: DismissDirection.startToEnd,
        child: CheckboxListTile(
          title: Text(tarefas[index].titulo),
          value: tarefas[index].realizado,
          secondary: CircleAvatar(
            child: Icon(tarefas[index].realizado ? Icons.check : Icons.error),
          ),
          onChanged: (checked) {
            setState(() {
              tarefas[index].realizado = checked!;
              _repositorio.atualizarTarefa(tarefas[index]);
            });
          },
        ),
        onDismissed: (direction) {
          setState(() {
            Tarefa tarefaRemovida = tarefas[index];
            tarefas.removeAt(index);
            _repositorio.deletarTarefa(tarefaRemovida);
            int indiceTarefaRemovida = index;

            final snack = SnackBar(
              content: Text("Tarefa ${tarefaRemovida.titulo} removida"),
              action: SnackBarAction(
                  label: "Desfazer",
                  onPressed: () {
                    setState(() {
                      tarefas.insert(indiceTarefaRemovida, tarefaRemovida);
                      _repositorio.salvarTarefa(tarefaRemovida);
                    });
                  }),
              duration: Duration(seconds: 3),
            );

            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snack);
          });
        },
    );
  }
}
