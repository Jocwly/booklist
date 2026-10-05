import 'package:flutter/material.dart';

import 'package:booklistt/modelo/libro.dart';
import 'package:booklistt/servicios/favorito_service.dart';

class lista extends StatefulWidget {
  const lista({super.key});

  @override
  State<lista> createState() => _listaState();
}

class _listaState extends State<lista> {
  final FavoritoService favoritoService = FavoritoService();

  void mostrarResena(BuildContext context, Libro libro) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(libro.titulo),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Image.network(
                  libro.portada,
                  height: 150,

                  errorBuilder: (context, error, stack) {
                    return const Icon(Icons.book, size: 100);
                  },
                ),

                const SizedBox(height: 15),

                Text(
                  "Autor: ${libro.autor}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text("Género: ${libro.genero}"),

                const SizedBox(height: 15),

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

  void confirmarEliminar(Libro libro) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar de favoritos"),

          content: Text(
            "¿Quieres quitar \"${libro.titulo}\" "
            "de tu lista de deseos?",
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
                  await favoritoService.eliminarFavorito(libro);

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Libro eliminado de favoritos"),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
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
      appBar: AppBar(
        title: const Text(
          "MI LISTA DE DESEOS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "Cheer",
          ),
        ),

        backgroundColor: const Color.fromARGB(255, 136, 42, 62),
      ),

      body: StreamBuilder<List<Libro>>(
        stream: favoritoService.obtenerFavoritos(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar favoritos:\n"
                "${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          final favoritos = snapshot.data ?? [];

          if (favoritos.isEmpty) {
            return const Center(child: Text("No tienes libros favoritos ❤️"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),

            itemCount: favoritos.length,

            itemBuilder: (context, index) {
              final libro = favoritos[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),

                child: ListTile(
                  // PORTADA
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),

                    child: Image.network(
                      libro.portada,

                      width: 70,
                      height: 80,

                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stack) {
                        return const SizedBox(
                          width: 70,
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

                  subtitle: Text(libro.autor),

                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),

                    onPressed: () {
                      confirmarEliminar(libro);
                    },
                  ),

                  onTap: () {
                    mostrarResena(context, libro);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
