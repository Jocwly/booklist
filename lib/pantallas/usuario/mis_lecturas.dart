import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:booklistt/modelo/libro.dart';
import 'package:booklistt/pantallas/admin/detalle_libro.dart';

class MisLecturas extends StatefulWidget {
  const MisLecturas({super.key});

  @override
  State<MisLecturas> createState() => _MisLecturasState();
}

class _MisLecturasState extends State<MisLecturas> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  // ==========================================================
  // STREAM DE LECTURAS
  // ==========================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> obtenerLecturas() {
    final usuario = auth.currentUser;

    if (usuario == null) {
      return const Stream.empty();
    }

    return db
        .collection("usuarios")
        .doc(usuario.uid)
        .collection("lecturas")
        .snapshots();
  }

  // ==========================================================
  // CONVERTIR DOCUMENTO A LIBRO
  // ==========================================================

  Libro convertirLibro(QueryDocumentSnapshot<Map<String, dynamic>> documento) {
    final datos = documento.data();

    return Libro(
      id: documento.id,
      portada: datos["portada"] ?? "",
      titulo: datos["titulo"] ?? "",
      autor: datos["autor"] ?? "",
      genero: datos["genero"] ?? "",
      resena: datos["resena"] ?? "",
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
  // ELIMINAR DE MIS LECTURAS
  // ==========================================================

  Future<void> eliminarLectura(String libroId, String titulo) async {
    final usuario = auth.currentUser;

    if (usuario == null) {
      return;
    }

    try {
      await db
          .collection("usuarios")
          .doc(usuario.uid)
          .collection("lecturas")
          .doc(libroId)
          .delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("\"$titulo\" fue eliminado de tus lecturas")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al eliminar: $e")));
    }
  }

  // ==========================================================
  // CONFIRMAR ELIMINACIÓN
  // ==========================================================

  void confirmarEliminar(String libroId, String titulo) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Eliminar libro"),

          content: Text(
            "¿Quieres quitar \"$titulo\" "
            "de tus lecturas?",
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
                Navigator.pop(dialogContext);

                await eliminarLectura(libroId, titulo);
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
  // COLOR DEL ESTADO
  // ==========================================================

  Color colorEstado(String estado) {
    switch (estado) {
      case "Leyendo":
        return Colors.blue;

      case "Terminado":
        return Colors.green;

      case "Quiero leer":
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  // ==========================================================
  // ICONO DEL ESTADO
  // ==========================================================

  IconData iconoEstado(String estado) {
    switch (estado) {
      case "Leyendo":
        return Icons.menu_book;

      case "Terminado":
        return Icons.check_circle;

      case "Quiero leer":
        return Icons.bookmark;

      default:
        return Icons.book;
    }
  }

  // ==========================================================
  // SECCIÓN DE LIBROS
  // ==========================================================

  Widget construirSeccion(String titulo, String estado, List<Libro> libros) {
    final librosEstado =
        libros.where((libro) {
          return true;
        }).toList();

    // Esta función solamente recibe los libros
    // correspondientes al estado.
    if (librosEstado.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // ======================================================
        // TITULO DE SECCIÓN
        // ======================================================
        Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: colorEstado(estado).withOpacity(0.12),

                shape: BoxShape.circle,
              ),

              child: Icon(iconoEstado(estado), color: colorEstado(estado)),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    titulo,

                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,

                      color: Color.fromARGB(255, 136, 42, 62),
                    ),
                  ),

                  Text(
                    "${librosEstado.length} "
                    "${librosEstado.length == 1 ? "libro" : "libros"}",

                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // ======================================================
        // LIBROS
        // ======================================================
        ListView.builder(
          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          itemCount: librosEstado.length,

          itemBuilder: (context, index) {
            final libro = librosEstado[index];

            return Card(
              elevation: 3,

              margin: const EdgeInsets.only(bottom: 10),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                // ==============================================
                // PORTADA
                // ==============================================
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),

                  child: Image.network(
                    libro.portada,

                    width: 60,
                    height: 80,

                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 80,

                        color: Colors.grey.shade200,

                        child: const Icon(
                          Icons.book,
                          size: 35,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                // ==============================================
                // TITULO
                // ==============================================
                title: Text(
                  libro.titulo,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                // ==============================================
                // AUTOR + ESTADO
                // ==============================================
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 4),

                    Text(
                      libro.autor,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 5),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: colorEstado(estado).withOpacity(0.12),

                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Text(
                        estado,

                        style: TextStyle(
                          color: colorEstado(estado),

                          fontSize: 11,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // ==============================================
                // ELIMINAR
                // ==============================================
                trailing: IconButton(
                  tooltip: "Eliminar",

                  icon: const Icon(Icons.delete_outline, color: Colors.red),

                  onPressed: () {
                    confirmarEliminar(libro.id!, libro.titulo);
                  },
                ),

                // ==============================================
                // DETALLE
                // ==============================================
                onTap: () {
                  abrirDetalle(libro);
                },
              ),
            );
          },
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final usuario = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FA),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          "MIS LECTURAS",

          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      // ========================================================
      // USUARIO NO AUTENTICADO
      // ========================================================
      body:
          usuario == null
              ? const Center(
                child: Text("Debes iniciar sesión para ver tus lecturas."),
              )
              : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: obtenerLecturas(),

                builder: (context, snapshot) {
                  // ==============================================
                  // CARGANDO
                  // ==============================================

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // ==============================================
                  // ERROR
                  // ==============================================

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
                              "No se pudieron cargar tus lecturas.",

                              textAlign: TextAlign.center,

                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "${snapshot.error}",

                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // ==============================================
                  // DOCUMENTOS
                  // ==============================================

                  final documentos = snapshot.data?.docs ?? [];

                  if (documentos.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30),

                        child: Column(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Icon(
                              Icons.menu_book_outlined,

                              size: 80,

                              color: Colors.grey.shade400,
                            ),

                            const SizedBox(height: 15),

                            const Text(
                              "Todavía no tienes libros en lectura",

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Cuando marques un libro como "
                              "\"Leyendo\" o \"Terminado\", "
                              "aparecerá aquí.",

                              textAlign: TextAlign.center,

                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // ==============================================
                  // LIBROS
                  // ==============================================

                  final todosLosLibros =
                      documentos.map((documento) {
                        return convertirLibro(documento);
                      }).toList();

                  // ==============================================
                  // SEPARAR POR ESTADO
                  // ==============================================

                  final leyendo =
                      todosLosLibros.where((libro) {
                        final documento = documentos.firstWhere(
                          (doc) => doc.id == libro.id,
                        );

                        return documento.data()["estado"] == "Leyendo";
                      }).toList();

                  final terminados =
                      todosLosLibros.where((libro) {
                        final documento = documentos.firstWhere(
                          (doc) => doc.id == libro.id,
                        );

                        return documento.data()["estado"] == "Terminado";
                      }).toList();

                  final quieroLeer =
                      todosLosLibros.where((libro) {
                        final documento = documentos.firstWhere(
                          (doc) => doc.id == libro.id,
                        );

                        return documento.data()["estado"] == "Quiero leer";
                      }).toList();

                  // ==============================================
                  // CONTENIDO
                  // ==============================================

                  return ListView(
                    padding: const EdgeInsets.all(20),

                    children: [
                      // ==========================================
                      // ENCABEZADO
                      // ==========================================
                      const Text(
                        "Mi biblioteca",

                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,

                          color: Color.fromARGB(255, 136, 42, 62),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "Aquí puedes llevar el control "
                        "de tus lecturas.",

                        style: TextStyle(color: Colors.grey.shade700),
                      ),

                      const SizedBox(height: 25),

                      // ==========================================
                      // LEYENDO
                      // ==========================================
                      construirSeccion("Estoy leyendo", "Leyendo", leyendo),

                      // ==========================================
                      // TERMINADOS
                      // ==========================================
                      construirSeccion(
                        "Libros terminados",
                        "Terminado",
                        terminados,
                      ),

                      // ==========================================
                      // QUIERO LEER
                      // ==========================================
                      construirSeccion(
                        "Quiero leer",
                        "Quiero leer",
                        quieroLeer,
                      ),
                    ],
                  );
                },
              ),
    );
  }
}
