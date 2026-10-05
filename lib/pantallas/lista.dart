import 'package:flutter/material.dart';

import 'package:booklistt/modelo/libro.dart';
import 'package:booklistt/servicios/favorito_service.dart';
import 'package:booklistt/pantallas/detalle_libro.dart';

class lista extends StatefulWidget {
  const lista({super.key});

  @override
  State<lista> createState() => _listaState();
}

class _listaState extends State<lista> {
  final FavoritoService favoritoService = FavoritoService();

  // ==========================================================
  // CONFIRMAR ELIMINACIÓN
  // ==========================================================

  void confirmarEliminar(Libro libro) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Eliminar de favoritos",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: Text(
            "¿Quieres quitar "
            "\"${libro.titulo}\" "
            "de tu lista de deseos?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

              onPressed: () async {
                // Cerrar diálogo
                Navigator.pop(dialogContext);

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

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error al eliminar: $e")),
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

  // ==========================================================
  // ABRIR DETALLE
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

      // ========================================================
      // FAVORITOS
      // ========================================================
      body: StreamBuilder<List<Libro>>(
        stream: favoritoService.obtenerFavoritos(),

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
                      "Error al cargar favoritos",

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),

                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text("${snapshot.error}", textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }

          final favoritos = snapshot.data ?? [];

          // ====================================================
          // SIN FAVORITOS
          // ====================================================

          if (favoritos.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "No tienes libros favoritos",

                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Agrega libros a tu lista de deseos ❤️",

                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          // ====================================================
          // LISTA
          // ====================================================

          return ListView.builder(
            padding: const EdgeInsets.all(10),

            itemCount: favoritos.length,

            itemBuilder: (context, index) {
              final libro = favoritos[index];

              return Card(
                elevation: 3,

                margin: const EdgeInsets.only(bottom: 10),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  // ==================================================
                  // PORTADA
                  // ==================================================
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),

                    child: Image.network(
                      libro.portada,

                      width: 65,
                      height: 80,

                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 65,
                          height: 80,

                          color: Colors.grey.shade200,

                          child: const Icon(
                            Icons.book,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),

                  // ==================================================
                  // TITULO
                  // ==================================================
                  title: Text(
                    libro.titulo,

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  // ==================================================
                  // AUTOR + GENERO
                  // ==================================================
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          libro.autor,

                          maxLines: 1,

                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 3),

                        Text(
                          libro.genero,

                          style: TextStyle(
                            color: Colors.grey.shade600,

                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ==================================================
                  // ELIMINAR FAVORITO
                  // ==================================================
                  trailing: IconButton(
                    tooltip: "Eliminar de favoritos",

                    icon: const Icon(Icons.favorite, color: Colors.red),

                    onPressed: () {
                      confirmarEliminar(libro);
                    },
                  ),

                  // ==================================================
                  // ABRIR DETALLE
                  // ==================================================
                  onTap: () {
                    abrirDetalle(libro);
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
