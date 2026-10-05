import 'package:flutter/material.dart';
import 'package:booklistt/modelo/libro.dart';
import 'package:booklistt/servicios/libro_service.dart';
import 'package:booklistt/servicios/favorito_service.dart';

class inicio extends StatefulWidget {
  const inicio({super.key});

  @override
  State<inicio> createState() => _inicioState();
}

class _inicioState extends State<inicio> {
  List<Libro> libros = [];

  List<Libro> librosFiltrados = [];

  final TextEditingController buscarController = TextEditingController();

  @override
  void dispose() {
    buscarController.dispose();

    super.dispose();
  }

  void buscarLibro(String texto) {
    texto = texto.toLowerCase();

    setState(() {
      librosFiltrados =
          libros.where((libro) {
            return libro.titulo.toLowerCase().contains(texto) ||
                libro.autor.toLowerCase().contains(texto) ||
                libro.genero.toLowerCase().contains(texto);
          }).toList();
    });
  }

  void _mostrarResena(BuildContext context, Libro libro) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(libro.titulo),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Image.network(
                libro.portada,

                height: 150,

                errorBuilder: (context, error, stack) {
                  return const Icon(Icons.book, size: 100);
                },
              ),

              const SizedBox(height: 10),

              Text(libro.resena),
            ],
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),

              onPressed: () async {
                try {
                  await FavoritoService().agregarFavorito(libro);

                  if (!context.mounted) return;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Agregado a lista de deseos ❤️"),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error al agregar favorito: $e")),
                  );
                }
              },
            ),

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

      body: StreamBuilder<List<Libro>>(
        stream: LibroService().obtenerLibros(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay libros disponibles"));
          }

          libros = snapshot.data!;

          if (librosFiltrados.isEmpty && buscarController.text.isEmpty) {
            librosFiltrados = libros;
          }

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
                  _mostrarResena(context, libro);
                },

                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),

                      child: Image.network(
                        libro.portada,

                        width: 100,

                        height: 120,

                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 10),

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
