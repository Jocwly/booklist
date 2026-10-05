import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:booklistt/modelo/libro.dart';

class LibrosGenero extends StatefulWidget {
  final String genero;

  const LibrosGenero({super.key, required this.genero});

  @override
  State<LibrosGenero> createState() => _LibrosGeneroState();
}

class _LibrosGeneroState extends State<LibrosGenero> {
  void mostrarResena(Libro libro) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(libro.titulo),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (libro.portada.isNotEmpty)
                  Image.network(
                    libro.portada,
                    height: 180,
                    width: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.book, size: 100);
                    },
                  ),

                const SizedBox(height: 15),

                Text(
                  "Autor: ${libro.autor}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text(
                  "Género: ${libro.genero}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Reseña:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 5),

                Text(libro.resena),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.genero,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 136, 42, 62),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection("libros")
                .where("genero", isEqualTo: widget.genero)
                .snapshots(),

        builder: (context, snapshot) {
          // Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Ocurrió un error:\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          // No hay datos
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No hay libros de ${widget.genero}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          final documentos = snapshot.data!.docs;

          // Convertir documentos de Firestore a Libro
          final List<Libro> libros =
              documentos.map((documento) {
                final datos = documento.data() as Map<String, dynamic>;

                return Libro(
                  id: null,
                  portada: datos["portada"] ?? "",
                  titulo: datos["titulo"] ?? "",
                  autor: datos["autor"] ?? "",
                  genero: datos["genero"] ?? "",
                  resena: datos["resena"] ?? "",
                );
              }).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(10),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.65,
            ),

            itemCount: libros.length,

            itemBuilder: (context, index) {
              final libro = libros[index];

              return GestureDetector(
                onTap: () {
                  mostrarResena(libro);
                },

                child: Container(
                  margin: const EdgeInsets.all(10),

                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),

                        child: Image.network(
                          libro.portada,

                          width: 100,

                          height: 120,

                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.book, size: 80);
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        libro.titulo,

                        textAlign: TextAlign.center,

                        maxLines: 2,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
