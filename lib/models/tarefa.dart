class Tarefa {
  Tarefa({this.id="",required this.titulo, required this.realizado});

  String id;
  String titulo;
  bool realizado;

  Map<String, dynamic> toMap() {
    return {
      "titulo": titulo,
      "realizado": realizado,
    };
  }
}