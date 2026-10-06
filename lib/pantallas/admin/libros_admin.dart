import 'package:flutter/material.dart';
import 'package:booklistt/modelo/libro.dart';
import 'package:booklistt/pantallas/admin/agregar_libros.dart';
import 'package:booklistt/pantallas/admin/editar_libro.dart';
import 'package:booklistt/servicios/libro_service.dart';

class LibrosAdmin extends StatefulWidget {
  const LibrosAdmin({super.key});

  @override
  State<LibrosAdmin> createState() => _LibrosAdminState();
}

class _LibrosAdminState extends State<LibrosAdmin> {
  final LibroService libroService = LibroService();

  // ==========================================================
  // MOSTRAR DETALLES
  // ==========================================================

  void mostrarDetalles(Libro libro) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(libro.titulo),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Center(
                  child: Image.network(
                    libro.portada,
                    height: 150,

                    errorBuilder: (context, error, stack) {
                      return const Icon(Icons.book, size: 100);
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Text("Autor: ${libro.autor}"),

                const SizedBox(height: 10),

                Text("Género: ${libro.genero}"),

                const SizedBox(height: 10),

                const Text(
                  "Reseña:",
                  style: TextStyle(fontWeight: FontWeight.bold),
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

  Future<void> editarLibro(Libro libro) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditarLibro(libro: libro)),
    );
  }

  void confirmarEliminar(Libro libro) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar libro"),

          content: Text(
            "¿Estás seguro de que deseas eliminar "
            "\"${libro.titulo}\"?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

              onPressed: () async {
                Navigator.pop(context);

                try {
                  await libroService.eliminarLibro(libro);

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Libro eliminado correctamente"),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error al eliminar el libro: $e")),
                  );
                }
              },

              child: const Text(
                "Eliminar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Libro>>(
        stream: libroService.obtenerLibros(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar los libros:\n"
                "${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay libros agregados"));
          }

          final libros = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),

            itemCount: libros.length,

            itemBuilder: (context, index) {
              final libro = libros[index];

              return Card(
                elevation: 4,

                margin: const EdgeInsets.only(bottom: 10),

                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),

                    child: Image.network(
                      libro.portada,

                      width: 60,
                      height: 80,

                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stack) {
                        return const SizedBox(
                          width: 60,
                          height: 80,

                          child: Icon(Icons.book, size: 40),
                        );
                      },
                    ),
                  ),

                  title: Text(
                    libro.titulo,

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(libro.genero),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Color.fromARGB(255, 136, 42, 62),
                        ),

                        tooltip: "Editar libro",

                        onPressed: () {
                          editarLibro(libro);
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),

                        tooltip: "Eliminar libro",

                        onPressed: () {
                          confirmarEliminar(libro);
                        },
                      ),
                    ],
                  ),

                  onTap: () {
                    mostrarDetalles(libro);
                  },
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        child: const Icon(Icons.add, color: Colors.white),

        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AgregarLibro()),
          );
        },
      ),
    );
  }
}
