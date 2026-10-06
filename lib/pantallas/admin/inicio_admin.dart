import 'package:flutter/material.dart';

import 'package:booklistt/modelo/libro.dart';
import 'package:booklistt/servicios/libro_service.dart';

class InicioAdmin extends StatefulWidget {
  const InicioAdmin({super.key});

  @override
  State<InicioAdmin> createState() => _InicioAdminState();
}

class _InicioAdminState extends State<InicioAdmin> {
  List<Libro> libros = [];

  List<Libro> librosFiltrados = [];

  final TextEditingController buscarController = TextEditingController();

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  // =========================================================
  // BUSCADOR
  // =========================================================

  void buscarLibro(String texto) {
    final textoBusqueda = texto.toLowerCase().trim();

    setState(() {
      librosFiltrados =
          libros.where((libro) {
            return libro.titulo.toLowerCase().contains(textoBusqueda) ||
                libro.autor.toLowerCase().contains(textoBusqueda) ||
                libro.genero.toLowerCase().contains(textoBusqueda);
          }).toList();
    });
  }

  // =========================================================
  // MOSTRAR INFORMACIÓN DEL LIBRO
  // =========================================================

  void mostrarResena(BuildContext context, Libro libro) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            libro.titulo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // PORTADA
                if (libro.portada.isNotEmpty)
                  Image.network(
                    libro.portada,
                    height: 180,
                    width: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.book, size: 100);
                    },
                  )
                else
                  const Icon(Icons.book, size: 100),

                const SizedBox(height: 15),

                // AUTOR
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Autor: ${libro.autor}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 10),

                // GENERO
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Género: ${libro.genero}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 15),

                // RESEÑA
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Reseña:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 5),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(libro.resena),
                ),
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

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "INICIO",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // BUSCADOR
            Container(
              height: 50,
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 10),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(255, 147, 60, 78),
              ),

              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: buscarController,

                      onChanged: buscarLibro,

                      style: const TextStyle(color: Colors.white),

                      decoration: const InputDecoration(
                        hintText: "Buscar libro...",

                        hintStyle: TextStyle(color: Colors.grey),

                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const Icon(Icons.search, color: Colors.white),
                ],
              ),
            ),
          ],
        ),

        backgroundColor: const Color.fromARGB(255, 136, 42, 62),
      ),

      // =======================================================
      // LIBROS DESDE FIRESTORE
      // =======================================================
      body: StreamBuilder<List<Libro>>(
        stream: LibroService().obtenerLibros(),

        builder: (context, snapshot) {
          // CARGANDO
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Ocurrió un error:\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          // NO HAY DATOS
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay libros disponibles"));
          }

          // LIBROS DE FIRESTORE
          libros = snapshot.data!;

          // ACTUALIZAR RESULTADOS DEL BUSCADOR
          if (buscarController.text.isEmpty) {
            librosFiltrados = libros;
          } else {
            final texto = buscarController.text.toLowerCase().trim();

            librosFiltrados =
                libros.where((libro) {
                  return libro.titulo.toLowerCase().contains(texto) ||
                      libro.autor.toLowerCase().contains(texto) ||
                      libro.genero.toLowerCase().contains(texto);
                }).toList();
          }

          // NO ENCONTRADOS
          if (librosFiltrados.isEmpty) {
            return const Center(child: Text("No se encontraron libros"));
          }

          // GRID DE LIBROS
          return GridView.builder(
            padding: const EdgeInsets.all(10),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.65,
            ),

            itemCount: librosFiltrados.length,

            itemBuilder: (context, index) {
              final libro = librosFiltrados[index];

              return GestureDetector(
                onTap: () {
                  mostrarResena(context, libro);
                },

                child: Container(
                  margin: const EdgeInsets.all(10),

                  child: Column(
                    children: [
                      // PORTADA
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),

                        child:
                            libro.portada.isNotEmpty
                                ? Image.network(
                                  libro.portada,

                                  width: 100,
                                  height: 120,

                                  fit: BoxFit.cover,

                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.book, size: 80);
                                  },
                                )
                                : const Icon(Icons.book, size: 80),
                      ),

                      const SizedBox(height: 10),

                      // TITULO
                      Text(
                        libro.titulo,

                        textAlign: TextAlign.center,

                        maxLines: 2,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(fontWeight: FontWeight.bold),
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
