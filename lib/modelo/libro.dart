class Libro {
  final String? id;

  final String portada;

  final String titulo;

  final String autor;

  final String genero;

  final String resena;

  Libro({
    this.id,

    required this.portada,

    required this.titulo,

    required this.autor,

    required this.genero,

    required this.resena,
  });

  Map<String, dynamic> toMap() {
    return {
      "portada": portada,

      "titulo": titulo,

      "autor": autor,

      "genero": genero,

      "resena": resena,
    };
  }

  factory Libro.fromMap(Map<String, dynamic> mapa, String id) {
    return Libro(
      id: id,

      portada: mapa["portada"],

      titulo: mapa["titulo"],

      autor: mapa["autor"],

      genero: mapa["genero"],

      resena: mapa["resena"],
    );
  }
}







/*
class Libro {
  final int? id;

  String portada;
  String titulo;
  String autor;
  String genero;
  String resena;

  Libro({
    this.id,
    required this.portada,
    required this.titulo,
    required this.autor,
    required this.genero,
    required this.resena,
  });

  // Convertir objeto a mapa para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'portada': portada,
      'titulo': titulo,
      'autor': autor,
      'genero': genero,
      'resena': resena,
    };
  }

  // Convertir datos de SQLite a objeto Libro
  factory Libro.fromMap(Map<String, dynamic> mapa) {
    return Libro(
      id: mapa['id'],

      portada: mapa['portada'],

      titulo: mapa['titulo'],

      autor: mapa['autor'],

      genero: mapa['genero'],

      resena: mapa['resena'],
    );
  }
}
*/