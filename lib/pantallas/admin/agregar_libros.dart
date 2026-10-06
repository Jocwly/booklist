import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:booklistt/modelo/libro.dart';
import 'package:booklistt/servicios/cloudinary.dart';
import 'package:booklistt/servicios/libro_service.dart';
import 'package:booklistt/servicios/google_books_service.dart';

class AgregarLibro extends StatefulWidget {
  const AgregarLibro({super.key});

  @override
  State<AgregarLibro> createState() => _AgregarLibroState();
}

class _AgregarLibroState extends State<AgregarLibro> {
  final titulo = TextEditingController();

  final autor = TextEditingController();

  final resena = TextEditingController();

  final buscarGoogleController = TextEditingController();

  String? generoSeleccionado;

  File? imagenSeleccionada;

  String? urlPortada;

  bool buscandoGoogle = false;

  List<Map<String, dynamic>> resultadosGoogle = [];

  final List<String> generosLiterarios = [
    "Novela",
    "Fantasía",
    "Ciencia ficción",
    "Romance",
    "Misterio",
    "Terror",
    "Suspenso",
    "Aventura",
    "Drama",
    "Comedia",
    "Poesía",
    "Biografía",
    "Autobiografía",
    "Historia",
    "Ensayo",
    "Filosofía",
    "Literatura infantil",
    "Cuento",
    "Distopía",
    "Realismo mágico",
    "Clásicos",
    "Mitología",
  ];

  Future<void> buscarEnGoogleBooks() async {
    final consulta = buscarGoogleController.text.trim();

    if (consulta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Escribe el nombre de un libro.")),
      );

      return;
    }

    setState(() {
      buscandoGoogle = true;
      resultadosGoogle = [];
    });

    try {
      final resultados = await GoogleBooksService.buscarLibros(consulta);

      if (!mounted) return;

      setState(() {
        resultadosGoogle = resultados;
      });

      if (resultados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se encontraron libros.")),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al buscar el libro: $e")));
    } finally {
      if (mounted) {
        setState(() {
          buscandoGoogle = false;
        });
      }
    }
  }

  void seleccionarLibroGoogle(Map<String, dynamic> libroGoogle) {
    final Map<String, dynamic> volumeInfo = Map<String, dynamic>.from(
      libroGoogle["volumeInfo"] ?? {},
    );

    titulo.text = volumeInfo["title"] ?? "";

    final autores = volumeInfo["authors"];

    if (autores != null && autores is List && autores.isNotEmpty) {
      autor.text = autores.join(", ");
    } else {
      autor.text = "";
    }
    resena.text = limpiarDescripcion(volumeInfo["description"] ?? "");

    final imageLinks = volumeInfo["imageLinks"];

    String portadaGoogle = "";

    if (imageLinks != null && imageLinks is Map) {
      portadaGoogle =
          imageLinks["thumbnail"] ?? imageLinks["smallThumbnail"] ?? "";
    }

    portadaGoogle = portadaGoogle.replaceFirst("http://", "https://");

    setState(() {
      urlPortada = portadaGoogle;

      resultadosGoogle = [];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Información del libro cargada.")),
    );
  }

  String limpiarDescripcion(String descripcion) {
    return descripcion
        .replaceAll("<p>", "")
        .replaceAll("</p>", "")
        .replaceAll("<br>", "")
        .replaceAll("<br/>", "")
        .replaceAll("<br />", "")
        .trim();
  }

  Future<void> seleccionarImagen() async {
    final picker = ImagePicker();

    final imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen == null) {
      return;
    }

    setState(() {
      imagenSeleccionada = File(imagen.path);

      // Quitamos la portada de Google
      // porque el usuario eligió otra.
      urlPortada = null;
    });

    try {
      final url = await CloudinaryService.subirImagen(imagenSeleccionada!);

      if (!mounted) return;

      setState(() {
        urlPortada = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Portada subida correctamente.")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al subir portada: $e")));
    }
  }

  Future<void> guardar() async {
    if (titulo.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Escribe el título del libro.")),
      );

      return;
    }

    if (autor.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Escribe el autor.")));

      return;
    }

    if (generoSeleccionado == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Selecciona un género.")));

      return;
    }

    if (urlPortada == null || urlPortada!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Selecciona una portada.")));

      return;
    }

    try {
      final libro = Libro(
        portada: urlPortada!,
        titulo: titulo.text.trim(),
        autor: autor.text.trim(),
        genero: generoSeleccionado!,
        resena: resena.text.trim(),
      );

      await LibroService().agregarLibro(libro);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Libro agregado correctamente.")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al guardar el libro: $e")));
    }
  }

  @override
  void dispose() {
    titulo.dispose();

    autor.dispose();

    resena.dispose();

    buscarGoogleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar libro"),

        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            children: [
              // =================================================
              // BUSCAR EN GOOGLE BOOKS
              // =================================================
              const Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Buscar libro en Google Books",

                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: buscarGoogleController,

                      decoration: const InputDecoration(
                        labelText: "Nombre del libro",

                        hintText: "Ej. Harry Potter",

                        border: OutlineInputBorder(),
                      ),

                      onSubmitted: (_) {
                        buscarEnGoogleBooks();
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  SizedBox(
                    height: 56,

                    child: ElevatedButton(
                      onPressed: buscandoGoogle ? null : buscarEnGoogleBooks,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 136, 42, 62),
                      ),

                      child:
                          buscandoGoogle
                              ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),

              if (resultadosGoogle.isNotEmpty) ...[
                const SizedBox(height: 15),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),

                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Column(
                    children:
                        resultadosGoogle.map((libroGoogle) {
                          return construirResultadoGoogle(libroGoogle);
                        }).toList(),
                  ),
                ),
              ],

              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Portada",

                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: seleccionarImagen,

                icon: const Icon(Icons.image),

                label: const Text("Seleccionar portada"),
              ),

              const SizedBox(height: 10),

              if (imagenSeleccionada != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),

                  child: Image.file(
                    imagenSeleccionada!,

                    height: 150,

                    fit: BoxFit.cover,
                  ),
                )
              else if (urlPortada != null && urlPortada!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),

                  child: Image.network(
                    urlPortada!,

                    height: 150,

                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.book, size: 100);
                    },
                  ),
                ),

              const SizedBox(height: 15),

              TextField(
                controller: titulo,

                decoration: const InputDecoration(
                  labelText: "Título del libro",

                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // =================================================
              // AUTOR
              // =================================================
              TextField(
                controller: autor,

                decoration: const InputDecoration(
                  labelText: "Autor",

                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: generoSeleccionado,

                decoration: const InputDecoration(
                  labelText: "Género",

                  border: OutlineInputBorder(),
                ),

                items:
                    generosLiterarios.map((genero) {
                      return DropdownMenuItem<String>(
                        value: genero,

                        child: Text(genero),
                      );
                    }).toList(),

                onChanged: (valor) {
                  setState(() {
                    generoSeleccionado = valor;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextField(
                controller: resena,

                maxLines: 5,

                decoration: const InputDecoration(
                  labelText: "Breve reseña",

                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 136, 42, 62),

                    padding: const EdgeInsets.symmetric(vertical: 15),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  onPressed: guardar,

                  child: const Text(
                    "Agregar libro",

                    style: TextStyle(
                      color: Colors.white,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // CONSTRUIR RESULTADO DE GOOGLE
  // =========================================================

  Widget construirResultadoGoogle(Map<String, dynamic> libroGoogle) {
    final Map<String, dynamic> volumeInfo = Map<String, dynamic>.from(
      libroGoogle["volumeInfo"] ?? {},
    );

    final String tituloGoogle = volumeInfo["title"] ?? "Sin título";

    final autores = volumeInfo["authors"];

    String autorGoogle = "Autor desconocido";

    if (autores != null && autores is List && autores.isNotEmpty) {
      autorGoogle = autores.join(", ");
    }

    final imageLinks = volumeInfo["imageLinks"];

    String portadaGoogle = "";

    if (imageLinks != null && imageLinks is Map) {
      portadaGoogle =
          imageLinks["thumbnail"] ?? imageLinks["smallThumbnail"] ?? "";

      portadaGoogle = portadaGoogle.replaceFirst("http://", "https://");
    }

    return InkWell(
      onTap: () {
        seleccionarLibroGoogle(libroGoogle);
      },

      child: Padding(
        padding: const EdgeInsets.all(10),

        child: Row(
          children: [
            if (portadaGoogle.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(5),

                child: Image.network(
                  portadaGoogle,

                  width: 55,
                  height: 75,

                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      width: 55,
                      height: 75,

                      child: Icon(Icons.book, size: 40),
                    );
                  },
                ),
              )
            else
              const SizedBox(
                width: 55,
                height: 75,

                child: Icon(Icons.book, size: 40),
              ),

            const SizedBox(width: 12),

            // -------------------------------------------------
            // INFORMACION
            // -------------------------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    tituloGoogle,

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,

                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    autorGoogle,

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
