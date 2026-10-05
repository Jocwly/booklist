import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:booklistt/modelo/libro.dart';
import 'package:booklistt/servicios/favorito_service.dart';

class DetalleLibro extends StatefulWidget {
  final Libro libro;

  const DetalleLibro({super.key, required this.libro});

  @override
  State<DetalleLibro> createState() => _DetalleLibroState();
}

class _DetalleLibroState extends State<DetalleLibro> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final FavoritoService favoritoService = FavoritoService();

  // ==========================================================
  // FAVORITOS
  // ==========================================================

  bool esFavorito = false;

  bool cargandoFavorito = true;

  bool guardandoFavorito = false;

  // ==========================================================
  // ESTADO DE LECTURA
  // ==========================================================

  String estadoLectura = "No iniciado";

  // ==========================================================
  // CALIFICACIONES
  // ==========================================================

  double promedio = 0;

  int cantidadCalificaciones = 0;

  bool yaCalifico = false;

  int miCalificacion = 0;

  // ==========================================================
  // OPINIONES
  // ==========================================================

  final TextEditingController opinionController = TextEditingController();

  bool publicandoOpinion = false;

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    cargarDatos();
  }

  @override
  void dispose() {
    opinionController.dispose();

    super.dispose();
  }

  // ==========================================================
  // USUARIO ACTUAL
  // ==========================================================

  User? get usuarioActual {
    return auth.currentUser;
  }

  // ==========================================================
  // CARGAR DATOS
  // ==========================================================

  Future<void> cargarDatos() async {
    await Future.wait([
      cargarFavorito(),
      cargarEstadoLectura(),
      cargarCalificacion(),
    ]);
  }

  // ==========================================================
  // FAVORITO
  // ==========================================================

  Future<void> cargarFavorito() async {
    final usuario = usuarioActual;

    if (usuario == null ||
        widget.libro.id == null ||
        widget.libro.id!.isEmpty) {
      if (!mounted) return;

      setState(() {
        cargandoFavorito = false;
      });

      return;
    }

    try {
      // AHORA UTILIZAMOS EL FAVORITOSERVICE
      final favorito = await favoritoService.esFavorito(widget.libro);

      if (!mounted) return;

      setState(() {
        esFavorito = favorito;
        cargandoFavorito = false;
      });
    } catch (e) {
      debugPrint("Error al cargar favorito: $e");

      if (!mounted) return;

      setState(() {
        cargandoFavorito = false;
      });
    }
  }

  // ==========================================================
  // AGREGAR / QUITAR FAVORITO
  // ==========================================================

  Future<void> cambiarFavorito() async {
    final usuario = usuarioActual;

    if (usuario == null) {
      mostrarMensaje("Debes iniciar sesión para guardar favoritos");

      return;
    }

    if (widget.libro.id == null || widget.libro.id!.isEmpty) {
      mostrarMensaje("Este libro no tiene un identificador válido");

      return;
    }

    if (guardandoFavorito) return;

    setState(() {
      guardandoFavorito = true;
    });

    try {
      if (esFavorito) {
        // ==============================================
        // ELIMINAR
        // ==============================================

        await favoritoService.eliminarFavorito(widget.libro);

        if (!mounted) return;

        setState(() {
          esFavorito = false;
        });

        mostrarMensaje("Libro eliminado de favoritos");
      } else {
        // ==============================================
        // AGREGAR
        // ==============================================

        await favoritoService.agregarFavorito(widget.libro);

        if (!mounted) return;

        setState(() {
          esFavorito = true;
        });

        mostrarMensaje("Libro agregado a favoritos ❤️");
      }
    } catch (e) {
      if (mounted) {
        mostrarMensaje("Error con favoritos: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          guardandoFavorito = false;
        });
      }
    }
  }

  // ==========================================================
  // ESTADO DE LECTURA
  // ==========================================================

  Future<void> cargarEstadoLectura() async {
    final usuario = usuarioActual;

    if (usuario == null ||
        widget.libro.id == null ||
        widget.libro.id!.isEmpty) {
      return;
    }

    try {
      final documento =
          await db
              .collection("usuarios")
              .doc(usuario.uid)
              .collection("lecturas")
              .doc(widget.libro.id)
              .get();

      if (!mounted) return;

      if (documento.exists) {
        setState(() {
          estadoLectura = documento.data()?["estado"] ?? "No iniciado";
        });
      }
    } catch (e) {
      debugPrint("Error al cargar estado de lectura: $e");
    }
  }

  // ==========================================================
  // CAMBIAR ESTADO DE LECTURA
  // ==========================================================

  Future<void> cambiarEstadoLectura(String nuevoEstado) async {
    final usuario = usuarioActual;

    if (usuario == null) {
      mostrarMensaje("Debes iniciar sesión para guardar tu progreso");

      return;
    }

    if (widget.libro.id == null || widget.libro.id!.isEmpty) {
      return;
    }

    try {
      final referencia = db
          .collection("usuarios")
          .doc(usuario.uid)
          .collection("lecturas")
          .doc(widget.libro.id);

      if (nuevoEstado == "No iniciado") {
        await referencia.delete();
      } else {
        await referencia.set({
          "libroId": widget.libro.id,
          "titulo": widget.libro.titulo,
          "portada": widget.libro.portada,
          "autor": widget.libro.autor,
          "genero": widget.libro.genero,
          "estado": nuevoEstado,
          "fechaActualizacion": FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;

      setState(() {
        estadoLectura = nuevoEstado;
      });

      mostrarMensaje(
        nuevoEstado == "No iniciado"
            ? "Estado eliminado"
            : "Estado actualizado 📚",
      );
    } catch (e) {
      mostrarMensaje("Error al guardar el estado: $e");
    }
  }

  // ==========================================================
  // CALIFICACIONES
  // ==========================================================

  Future<void> cargarCalificacion() async {
    if (widget.libro.id == null || widget.libro.id!.isEmpty) {
      return;
    }

    try {
      // ==============================================
      // TODAS LAS CALIFICACIONES
      // ==============================================

      final calificaciones =
          await db
              .collection("libros")
              .doc(widget.libro.id)
              .collection("calificaciones")
              .get();

      double suma = 0;

      for (final documento in calificaciones.docs) {
        final datos = documento.data();

        final estrellas = datos["estrellas"];

        if (estrellas is num) {
          suma += estrellas.toDouble();
        }
      }

      double nuevoPromedio = 0;

      if (calificaciones.docs.isNotEmpty) {
        nuevoPromedio = suma / calificaciones.docs.length;
      }

      // ==============================================
      // CALIFICACIÓN DEL USUARIO
      // ==============================================

      int calificacionUsuario = 0;

      final usuario = usuarioActual;

      if (usuario != null) {
        final miDocumento =
            await db
                .collection("libros")
                .doc(widget.libro.id)
                .collection("calificaciones")
                .doc(usuario.uid)
                .get();

        if (miDocumento.exists) {
          final datos = miDocumento.data();

          final estrellas = datos?["estrellas"];

          if (estrellas is num) {
            calificacionUsuario = estrellas.toInt();
          }
        }
      }

      if (!mounted) return;

      setState(() {
        promedio = nuevoPromedio;

        cantidadCalificaciones = calificaciones.docs.length;

        miCalificacion = calificacionUsuario;

        yaCalifico = calificacionUsuario > 0;
      });
    } catch (e) {
      debugPrint("Error al cargar calificaciones: $e");
    }
  }

  // ==========================================================
  // GUARDAR CALIFICACIÓN
  // ==========================================================

  Future<void> guardarCalificacion(int estrellas) async {
    final usuario = usuarioActual;

    if (usuario == null) {
      mostrarMensaje("Debes iniciar sesión para calificar");

      return;
    }

    if (widget.libro.id == null || widget.libro.id!.isEmpty) {
      return;
    }

    try {
      await db
          .collection("libros")
          .doc(widget.libro.id)
          .collection("calificaciones")
          .doc(usuario.uid)
          .set({
            "usuarioId": usuario.uid,
            "estrellas": estrellas,
            "fecha": FieldValue.serverTimestamp(),
          });

      if (!mounted) return;

      setState(() {
        miCalificacion = estrellas;
        yaCalifico = true;
      });

      await cargarCalificacion();

      mostrarMensaje("Tu calificación fue guardada ⭐");
    } catch (e) {
      mostrarMensaje("Error al guardar calificación: $e");
    }
  }

  // ==========================================================
  // MOSTRAR CALIFICACIÓN
  // ==========================================================

  void mostrarCalificar() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        int seleccion = miCalificacion;

        return StatefulBuilder(
          builder: (context, actualizarDialogo) {
            return AlertDialog(
              title: Text(
                yaCalifico ? "Cambiar mi calificación" : "Calificar libro",
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const Text("¿Qué te pareció este libro?"),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: List.generate(5, (index) {
                      final numero = index + 1;

                      return IconButton(
                        onPressed: () {
                          actualizarDialogo(() {
                            seleccion = numero;
                          });
                        },

                        icon: Icon(
                          numero <= seleccion ? Icons.star : Icons.star_border,

                          color: Colors.orange,

                          size: 35,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    seleccion == 0
                        ? "Selecciona una calificación"
                        : "$seleccion de 5 estrellas",
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },

                  child: const Text("Cancelar"),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 136, 42, 62),
                  ),

                  onPressed:
                      seleccion == 0
                          ? null
                          : () async {
                            Navigator.pop(dialogContext);

                            await guardarCalificacion(seleccion);
                          },

                  child: const Text(
                    "Guardar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // PUBLICAR OPINIÓN
  // ==========================================================

  Future<void> publicarOpinion() async {
    final usuario = usuarioActual;

    final texto = opinionController.text.trim();

    if (usuario == null) {
      mostrarMensaje("Debes iniciar sesión para publicar una opinión");

      return;
    }

    if (widget.libro.id == null || widget.libro.id!.isEmpty) {
      return;
    }

    if (texto.isEmpty) {
      mostrarMensaje("Escribe una opinión antes de publicar");

      return;
    }

    if (texto.length < 5) {
      mostrarMensaje("La opinión es demasiado corta");

      return;
    }

    setState(() {
      publicandoOpinion = true;
    });

    try {
      // ==============================================
      // OPINIÓN DEL LIBRO
      // ==============================================

      await db
          .collection("libros")
          .doc(widget.libro.id)
          .collection("opiniones")
          .add({
            "usuarioId": usuario.uid,
            "nombreUsuario": usuario.displayName ?? usuario.email ?? "Usuario",
            "opinion": texto,
            "fecha": FieldValue.serverTimestamp(),
          });

      // ==============================================
      // COPIA EN EL PERFIL DEL USUARIO
      // ==============================================

      await db
          .collection("usuarios")
          .doc(usuario.uid)
          .collection("opiniones")
          .add({
            "libroId": widget.libro.id,
            "tituloLibro": widget.libro.titulo,
            "opinion": texto,
            "fecha": FieldValue.serverTimestamp(),
          });

      opinionController.clear();

      if (!mounted) return;

      FocusScope.of(context).unfocus();

      mostrarMensaje("Opinión publicada 💬");
    } catch (e) {
      mostrarMensaje("Error al publicar opinión: $e");
    } finally {
      if (mounted) {
        setState(() {
          publicandoOpinion = false;
        });
      }
    }
  }

  // ==========================================================
  // MENSAJE
  // ==========================================================

  void mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  // ==========================================================
  // COLOR ESTADO
  // ==========================================================

  Color colorEstado(String estado) {
    switch (estado) {
      case "Quiero leer":
        return Colors.orange;

      case "Leyendo":
        return Colors.blue;

      case "Terminado":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  // ==========================================================
  // ICONO ESTADO
  // ==========================================================

  IconData iconoEstado(String estado) {
    switch (estado) {
      case "Quiero leer":
        return Icons.bookmark_border;

      case "Leyendo":
        return Icons.menu_book;

      case "Terminado":
        return Icons.check_circle_outline;

      default:
        return Icons.book_outlined;
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final libro = widget.libro;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FA),

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          "Detalle del libro",

          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            tooltip: esFavorito ? "Quitar de favoritos" : "Agregar a favoritos",

            onPressed: guardandoFavorito ? null : cambiarFavorito,

            icon:
                cargandoFavorito
                    ? const SizedBox(
                      width: 20,
                      height: 20,

                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Icon(
                      esFavorito ? Icons.favorite : Icons.favorite_border,

                      color: esFavorito ? Colors.red : Colors.white,
                    ),
          ),
        ],
      ),

      // ========================================================
      // CONTENIDO
      // ========================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // PORTADA
            // ==================================================
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),

                child: Image.network(
                  libro.portada,

                  width: 180,
                  height: 260,

                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 180,
                      height: 260,

                      color: Colors.grey.shade200,

                      child: const Icon(
                        Icons.book,
                        size: 100,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // TITULO
            // ==================================================
            Center(
              child: Text(
                libro.titulo,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 136, 42, 62),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ==================================================
            // AUTOR
            // ==================================================
            Center(
              child: Text(
                libro.autor,

                textAlign: TextAlign.center,

                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            ),

            const SizedBox(height: 8),

            // ==================================================
            // GENERO
            // ==================================================
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 7,
                ),

                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    136,
                    42,
                    62,
                  ).withOpacity(0.10),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  libro.genero,

                  style: const TextStyle(
                    color: Color.fromARGB(255, 136, 42, 62),

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // CALIFICACION GENERAL
            // ==================================================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(15),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),

                    blurRadius: 7,

                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                children: [
                  const Text(
                    "Calificación de lectores",

                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 32),

                      const SizedBox(width: 8),

                      Text(
                        promedio == 0
                            ? "Sin calificaciones"
                            : promedio.toStringAsFixed(1),

                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "$cantidadCalificaciones calificaciones",

                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 12),

                  ElevatedButton.icon(
                    onPressed: mostrarCalificar,

                    icon: const Icon(Icons.star, color: Colors.white),

                    label: Text(
                      yaCalifico
                          ? "Cambiar mi calificación"
                          : "Calificar libro",

                      style: const TextStyle(color: Colors.white),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // ESTADO DE LECTURA
            // ==================================================
            const Text(
              "Mi estado de lectura",

              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 136, 42, 62),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.symmetric(horizontal: 15),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(15),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),

                    blurRadius: 7,

                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: estadoLectura,

                  isExpanded: true,

                  icon: const Icon(Icons.keyboard_arrow_down),

                  items: const [
                    DropdownMenuItem(
                      value: "No iniciado",

                      child: Text("No iniciado"),
                    ),

                    DropdownMenuItem(
                      value: "Quiero leer",

                      child: Text("🟡 Quiero leer"),
                    ),

                    DropdownMenuItem(
                      value: "Leyendo",

                      child: Text("🔵 Leyendo"),
                    ),

                    DropdownMenuItem(
                      value: "Terminado",

                      child: Text("🟢 Terminado"),
                    ),
                  ],

                  onChanged: (valor) {
                    if (valor != null) {
                      cambiarEstadoLectura(valor);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // RESEÑA
            // ==================================================
            const Text(
              "Reseña",

              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 136, 42, 62),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(17),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(15),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),

                    blurRadius: 6,

                    offset: const Offset(0, 2),
                  ),
                ],
              ),

              child: Text(
                libro.resena.isEmpty
                    ? "Este libro todavía no tiene una reseña."
                    : libro.resena,

                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // OPINIONES
            // ==================================================
            const Text(
              "Opiniones de lectores",

              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 136, 42, 62),
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // ESCRIBIR OPINION
            // ==================================================
            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(15),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),

                    blurRadius: 6,

                    offset: const Offset(0, 2),
                  ),
                ],
              ),

              child: Column(
                children: [
                  TextField(
                    controller: opinionController,

                    maxLines: 4,

                    maxLength: 500,

                    decoration: const InputDecoration(
                      hintText: "¿Qué te pareció este libro?",

                      border: OutlineInputBorder(),

                      alignLabelWithHint: true,
                    ),
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: publicandoOpinion ? null : publicarOpinion,

                      icon:
                          publicandoOpinion
                              ? const SizedBox(
                                width: 18,
                                height: 18,

                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.send, color: Colors.white),

                      label: Text(
                        publicandoOpinion
                            ? "Publicando..."
                            : "Publicar opinión",

                        style: const TextStyle(color: Colors.white),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

                        padding: const EdgeInsets.symmetric(vertical: 13),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // LISTA DE OPINIONES
            // ==================================================
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  widget.libro.id == null
                      ? null
                      : db
                          .collection("libros")
                          .doc(widget.libro.id)
                          .collection("opiniones")
                          .orderBy("fecha", descending: true)
                          .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(10),

                    child: Text("No se pudieron cargar las opiniones."),
                  );
                }

                final opiniones = snapshot.data?.docs ?? [];

                if (opiniones.isEmpty) {
                  return Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: Column(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,

                          size: 45,

                          color: Colors.grey.shade400,
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Todavía no hay opiniones.",

                          style: TextStyle(color: Colors.grey.shade600),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "¡Sé el primero en opinar!",

                          style: TextStyle(
                            color: Colors.grey.shade500,

                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: opiniones.length,

                  itemBuilder: (context, index) {
                    final datos = opiniones[index].data();

                    final nombre = datos["nombreUsuario"] ?? "Usuario";

                    final opinion = datos["opinion"] ?? "";

                    final fecha = datos["fecha"];

                    String fechaTexto = "";

                    if (fecha is Timestamp) {
                      final fechaDate = fecha.toDate();

                      fechaTexto =
                          "${fechaDate.day}/"
                          "${fechaDate.month}/"
                          "${fechaDate.year}";
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),

                      padding: const EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(15),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),

                            blurRadius: 6,

                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  136,
                                  42,
                                  62,
                                ),

                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      nombre,

                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    if (fechaTexto.isNotEmpty)
                                      Text(
                                        fechaTexto,

                                        style: TextStyle(
                                          color: Colors.grey.shade500,

                                          fontSize: 11,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Text(opinion, style: const TextStyle(height: 1.4)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
