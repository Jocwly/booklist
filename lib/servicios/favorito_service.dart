import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../modelo/libro.dart';

class FavoritoService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _coleccionFavoritos() {
    final usuario = auth.currentUser;

    if (usuario == null) {
      throw Exception("No hay ningún usuario iniciado sesión.");
    }

    return db.collection("favoritos").doc(usuario.uid).collection("libros");
  }

  Future<void> agregarFavorito(Libro libro) async {
    if (libro.id == null || libro.id!.isEmpty) {
      throw Exception("El libro no tiene un ID válido.");
    }

    await _coleccionFavoritos().doc(libro.id).set({
      "idLibro": libro.id,
      "portada": libro.portada,
      "titulo": libro.titulo,
      "autor": libro.autor,
      "genero": libro.genero,
      "resena": libro.resena,
    });
  }

  Stream<List<Libro>> obtenerFavoritos() {
    final usuario = auth.currentUser;

    if (usuario == null) {
      return Stream.value([]);
    }

    return db
        .collection("favoritos")
        .doc(usuario.uid)
        .collection("libros")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final datos = doc.data();

            return Libro(
              id: datos["idLibro"] ?? doc.id,
              portada: datos["portada"] ?? "",
              titulo: datos["titulo"] ?? "",
              autor: datos["autor"] ?? "",
              genero: datos["genero"] ?? "",
              resena: datos["resena"] ?? "",
            );
          }).toList();
        });
  }

  Future<void> eliminarFavorito(Libro libro) async {
    if (libro.id == null || libro.id!.isEmpty) {
      throw Exception("El libro no tiene un ID válido.");
    }

    await _coleccionFavoritos().doc(libro.id).delete();
  }

  // ==========================================================
  // COMPROBAR SI ES FAVORITO
  // ==========================================================

  Future<bool> esFavorito(Libro libro) async {
    if (libro.id == null || libro.id!.isEmpty) {
      return false;
    }

    final documento = await _coleccionFavoritos().doc(libro.id).get();

    return documento.exists;
  }
}
