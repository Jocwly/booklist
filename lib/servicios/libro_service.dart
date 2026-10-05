import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelo/libro.dart';

class LibroService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> agregarLibro(Libro libro) async {
    await db.collection("libros").add({
      "portada": libro.portada,
      "titulo": libro.titulo,
      "autor": libro.autor,
      "genero": libro.genero,
      "resena": libro.resena,
    });
  }

  Stream<List<Libro>> obtenerLibros() {
    return db.collection("libros").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Libro.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> actualizarLibro(Libro libro) async {
    if (libro.id == null || libro.id!.isEmpty) {
      throw Exception("No se encontró el ID del libro.");
    }

    await db.collection("libros").doc(libro.id).update({
      "portada": libro.portada,
      "titulo": libro.titulo,
      "autor": libro.autor,
      "genero": libro.genero,
      "resena": libro.resena,
    });
  }

  Future<void> eliminarLibro(Libro libro) async {
    if (libro.id == null || libro.id!.isEmpty) {
      throw Exception("No se encontró el ID del libro.");
    }

    await db.collection("libros").doc(libro.id).delete();
  }
}
