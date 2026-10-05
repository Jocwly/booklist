import 'package:flutter/material.dart';

import 'package:booklistt/modelo/libro.dart';
import 'package:booklistt/servicios/libro_service.dart';
import 'package:booklistt/pantallas/detalle_libro.dart';

class inicio extends StatefulWidget {
  const inicio({super.key});

  @override
  State<inicio> createState() => _inicioState();
}

class _inicioState extends State<inicio> {
  final LibroService libroService = LibroService();

  List<Libro> libros = [];

  List<Libro> librosFiltrados = [];

  final TextEditingController buscarController = TextEditingController();

  @override
  void dispose() {
    buscarController.dispose();

    super.dispose();
  }

  // ==========================================================
  // BUSCAR LIBROS
  // ==========================================================

  void buscarLibro(String texto) {
    final busqueda = texto.toLowerCase().trim();

    setState(() {
      if (busqueda.isEmpty) {
        librosFiltrados = libros;
        return;
      }

      librosFiltrados =
          libros.where((libro) {
            return libro.titulo.toLowerCase().contains(busqueda) ||
                libro.autor.toLowerCase().contains(busqueda) ||
                libro.genero.toLowerCase().contains(busqueda);
          }).toList();
    });
  }

  // ==========================================================
  // ABRIR DETALLE DEL LIBRO
  // ==========================================================

  void abrirDetalle(Libro libro) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalleLibro(libro: libro)),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        title: Row(
          children: [
            const Text(
              "INICIO",

              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 15),

            // ==================================================
            // BUSCADOR
            // ==================================================
            Expanded(
              child: Container(
                height: 45,

                padding: const EdgeInsets.symmetric(horizontal: 12),

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

                          hintStyle: TextStyle(color: Colors.white70),

                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const Icon(Icons.search, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // LIBROS
      // ========================================================
      body: StreamBuilder<List<Libro>>(
        stream: libroService.obtenerLibros(),

        builder: (context, snapshot) {
          // ====================================================
          // CARGANDO
          // ====================================================

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ====================================================
          // ERROR
          // ====================================================

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
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

          // ====================================================
          // SIN LIBROS
          // ====================================================

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Icon(Icons.menu_book_outlined, size: 70, color: Colors.grey),

                  SizedBox(height: 10),

                  Text(
                    "No hay libros disponibles",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          // ====================================================
          // ACTUALIZAR LISTA
          // ====================================================

          libros = snapshot.data!;

          if (buscarController.text.trim().isEmpty) {
            librosFiltrados = libros;
          }

          // ====================================================
          // SIN RESULTADOS
          // ====================================================

          if (librosFiltrados.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey),

                  SizedBox(height: 10),

                  Text(
                    "No se encontraron libros",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 5),

                  Text("Intenta buscar otro título, autor o género."),
                ],
              ),
            );
          }

          // ====================================================
          // GRID DE LIBROS
          // ====================================================

          return GridView.builder(
            padding: const EdgeInsets.all(10),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,

              childAspectRatio: 0.65,

              crossAxisSpacing: 8,

              mainAxisSpacing: 8,
            ),

            itemCount: librosFiltrados.length,

            itemBuilder: (context, index) {
              final libro = librosFiltrados[index];

              return GestureDetector(
                onTap: () {
                  abrirDetalle(libro);
                },

                child: Column(
                  children: [
                    // ==========================================
                    // PORTADA
                    // ==========================================
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),

                        child: Image.network(
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
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ==========================================
                    // TITULO
                    // ==========================================
                    Text(
                      libro.titulo,

                      textAlign: TextAlign.center,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(fontWeight: FontWeight.bold),
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
