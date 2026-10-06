import 'package:flutter/material.dart';
import 'package:booklistt/pantallas/login.dart';
import 'package:booklistt/pantallas/registrar.dart';
import 'package:booklistt/modelo/libro.dart';
import 'package:booklistt/servicios/libro_service.dart';

class pagina extends StatefulWidget {
  const pagina({super.key});

  @override
  State<pagina> createState() => _paginaState();
}

class _paginaState extends State<pagina> {
  List<Libro> libros = [];
  List<Libro> librosFiltrados = [];

  final TextEditingController buscarController = TextEditingController();

  @override
  void initState() {
    super.initState();

    buscarController.addListener(() {
      buscarLibro(buscarController.text);
    });
  }

  void buscarLibro(String texto) {
    final busqueda = texto.toLowerCase().trim();

    setState(() {
      if (busqueda.isEmpty) {
        librosFiltrados = libros;
      } else {
        librosFiltrados =
            libros.where((libro) {
              return libro.titulo.toLowerCase().contains(busqueda) ||
                  libro.autor.toLowerCase().contains(busqueda) ||
                  libro.genero.toLowerCase().contains(busqueda);
            }).toList();
      }
    });
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PORTADA
                if (libro.portada.isNotEmpty)
                  Center(
                    child: Image.network(
                      libro.portada,
                      width: 130,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.book, size: 100);
                      },
                    ),
                  ),

                const SizedBox(height: 15),

                // RESEÑA
                const Text(
                  "Reseña:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                const SizedBox(height: 8),

                Text(
                  libro.resena.isEmpty
                      ? "Este libro no tiene una reseña."
                      : libro.resena,
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

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 90),

            Center(
              child: CircleAvatar(
                backgroundImage: const NetworkImage(
                  "https://cdn.pixabay.com/photo/2016/09/16/09/20/books-1673578_960_720.png",
                ),
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.login, color: Colors.black),

              title: const Text(
                "Iniciar sesión",
                style: TextStyle(color: Colors.black),
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const login()),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.create, color: Colors.black),

              title: const Text(
                "Crea una cuenta",
                style: TextStyle(color: Colors.black),
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const registrar()),
                );
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              "BOOKLIST",
              style: TextStyle(fontFamily: "Cheer", color: Colors.white),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Container(
                height: 50,

                padding: const EdgeInsets.symmetric(horizontal: 8),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),

                  color: const Color.fromARGB(255, 147, 60, 78),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: buscarController,

                        style: const TextStyle(color: Colors.white),

                        decoration: const InputDecoration(
                          hintText: "Buscar un libro...",

                          hintStyle: TextStyle(color: Colors.grey),

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

        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: StreamBuilder<List<Libro>>(
        stream: LibroService().obtenerLibros(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Text(
                  "Ocurrió un error al cargar los libros:\n\n"
                  "${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No hay libros registrados",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          libros = snapshot.data!;

          final texto = buscarController.text.toLowerCase().trim();

          if (texto.isEmpty) {
            librosFiltrados = libros;
          } else {
            librosFiltrados =
                libros.where((libro) {
                  return libro.titulo.toLowerCase().contains(texto) ||
                      libro.autor.toLowerCase().contains(texto) ||
                      libro.genero.toLowerCase().contains(texto);
                }).toList();
          }

          if (librosFiltrados.isEmpty) {
            return const Center(
              child: Text(
                "No se encontraron libros",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,

              childAspectRatio: 0.75,

              crossAxisSpacing: 5,

              mainAxisSpacing: 10,
            ),

            itemCount: librosFiltrados.length,

            itemBuilder: (context, index) {
              final libro = librosFiltrados[index];

              return GestureDetector(
                onTap: () {
                  mostrarResena(context, libro);
                },

                child: Container(
                  margin: const EdgeInsets.all(5),

                  child: Column(
                    children: [
                      // ---------------------------------------
                      // PORTADA
                      // ---------------------------------------
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
                                    return Container(
                                      width: 100,
                                      height: 120,

                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],

                                        borderRadius: BorderRadius.circular(8),
                                      ),

                                      child: const Icon(
                                        Icons.book,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                                : Container(
                                  width: 100,
                                  height: 120,

                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],

                                    borderRadius: BorderRadius.circular(8),
                                  ),

                                  child: const Icon(
                                    Icons.book,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
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
