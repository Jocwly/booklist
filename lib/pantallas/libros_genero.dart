import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:booklistt/modelo/libro.dart';
import 'package:booklistt/pantallas/admin/detalle_libro.dart';

class LibrosGenero extends StatefulWidget {
  final String genero;

  const LibrosGenero({super.key, required this.genero});

  @override
  State<LibrosGenero> createState() => _LibrosGeneroState();
}

class _LibrosGeneroState extends State<LibrosGenero> {
  void abrirDetalle(Libro libro) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalleLibro(libro: libro)),
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

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance
                .collection("libros")
                .where("genero", isEqualTo: widget.genero)
                .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Ocurrió un error al cargar los libros.",

                      textAlign: TextAlign.center,

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    Text("${snapshot.error}", textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Icon(
                    Icons.menu_book_outlined,

                    size: 70,

                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "No hay libros de\n"
                    "${widget.genero}",

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          final documentos = snapshot.data!.docs;

          final List<Libro> libros =
              documentos.map((documento) {
                final datos = documento.data();

                return Libro(
                  id: documento.id,

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

              crossAxisSpacing: 8,

              mainAxisSpacing: 8,
            ),

            itemCount: libros.length,

            itemBuilder: (context, index) {
              final libro = libros[index];

              return GestureDetector(
                onTap: () {
                  abrirDetalle(libro);
                },

                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),

                        child:
                            libro.portada.isNotEmpty
                                ? Image.network(
                                  libro.portada,

                                  width: double.infinity,

                                  fit: BoxFit.cover,

                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,

                                      child: const Icon(
                                        Icons.book,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                                : Container(
                                  color: Colors.grey.shade200,

                                  child: const Icon(
                                    Icons.book,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                ),
                      ),
                    ),

                    const SizedBox(height: 8),

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
              );
            },
          );
        },
      ),
    );
  }
}
