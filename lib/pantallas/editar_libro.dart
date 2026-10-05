import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:booklistt/modelo/libro.dart';
import 'package:booklistt/servicios/cloudinary.dart';
import 'package:booklistt/servicios/libro_service.dart';

class EditarLibro extends StatefulWidget {
  final Libro libro;

  const EditarLibro({super.key, required this.libro});

  @override
  State<EditarLibro> createState() => _EditarLibroState();
}

class _EditarLibroState extends State<EditarLibro> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titulo;
  late TextEditingController autor;
  late TextEditingController resena;

  String? generoSeleccionado;

  File? imagenSeleccionada;

  late String urlPortada;

  bool guardando = false;

  final LibroService libroService = LibroService();

  // ==========================================================
  // GENEROS
  // ==========================================================

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
  ];

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    titulo = TextEditingController(text: widget.libro.titulo);

    autor = TextEditingController(text: widget.libro.autor);

    resena = TextEditingController(text: widget.libro.resena);

    generoSeleccionado = widget.libro.genero;

    urlPortada = widget.libro.portada;
  }

  // ==========================================================
  // SELECCIONAR NUEVA PORTADA
  // ==========================================================

  Future<void> seleccionarImagen() async {
    final picker = ImagePicker();

    final imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen == null) {
      return;
    }

    setState(() {
      imagenSeleccionada = File(imagen.path);
    });

    try {
      setState(() {
        guardando = true;
      });

      final nuevaUrl = await CloudinaryService.subirImagen(imagenSeleccionada!);

      if (nuevaUrl == null || nuevaUrl.isEmpty) {
        throw Exception("No se pudo subir la imagen.");
      }

      setState(() {
        urlPortada = nuevaUrl;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nueva portada cargada correctamente")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al subir la portada: $e")));
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  // ==========================================================
  // GUARDAR CAMBIOS
  // ==========================================================

  Future<void> guardarCambios() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (generoSeleccionado == null || generoSeleccionado!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Selecciona un género")));

      return;
    }

    try {
      setState(() {
        guardando = true;
      });

      final libroActualizado = Libro(
        id: widget.libro.id,

        portada: urlPortada,

        titulo: titulo.text.trim(),

        autor: autor.text.trim(),

        genero: generoSeleccionado!,

        resena: resena.text.trim(),
      );

      await libroService.actualizarLibro(libroActualizado);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Libro actualizado correctamente")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar el libro: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    titulo.dispose();
    autor.dispose();
    resena.dispose();

    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar libro"),

        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              children: [
                // ==================================================
                // PORTADA
                // ==================================================
                if (imagenSeleccionada != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),

                    child: Image.file(
                      imagenSeleccionada!,
                      height: 180,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),

                    child: Image.network(
                      urlPortada,

                      height: 180,
                      width: 130,

                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stack) {
                        return const Icon(Icons.book, size: 100);
                      },
                    ),
                  ),

                const SizedBox(height: 15),

                // ==================================================
                // CAMBIAR PORTADA
                // ==================================================
                ElevatedButton.icon(
                  onPressed: guardando ? null : seleccionarImagen,

                  icon: const Icon(Icons.image),

                  label: const Text("Cambiar portada"),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // TITULO
                // ==================================================
                TextFormField(
                  controller: titulo,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Escribe el título";
                    }

                    return null;
                  },

                  decoration: const InputDecoration(
                    labelText: "Título del libro",

                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                // ==================================================
                // AUTOR
                // ==================================================
                TextFormField(
                  controller: autor,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Escribe el autor";
                    }

                    return null;
                  },

                  decoration: const InputDecoration(
                    labelText: "Autor",

                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                // ==================================================
                // GENERO
                // ==================================================
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

                  onChanged:
                      guardando
                          ? null
                          : (valor) {
                            setState(() {
                              generoSeleccionado = valor;
                            });
                          },
                ),

                const SizedBox(height: 15),

                // ==================================================
                // RESEÑA
                // ==================================================
                TextFormField(
                  controller: resena,

                  maxLines: 5,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Escribe una reseña";
                    }

                    return null;
                  },

                  decoration: const InputDecoration(
                    labelText: "Breve reseña",

                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                // ==================================================
                // GUARDAR
                // ==================================================
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: guardando ? null : guardarCambios,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 136, 42, 62),

                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),

                    child:
                        guardando
                            ? const SizedBox(
                              height: 22,
                              width: 22,

                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              "Guardar cambios",

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
      ),
    );
  }
}
