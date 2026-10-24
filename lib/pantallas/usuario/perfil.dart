import 'package:booklistt/pantallas/usuario/mis_lecturas.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:booklistt/pantallas/login.dart';
import 'package:booklistt/pantallas/usuario/lista.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  int cantidadFavoritos = 0;
  int cantidadLecturas = 0;
  int cantidadCalificaciones = 0;
  int cantidadOpiniones = 0;

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final usuario = auth.currentUser;

    if (usuario == null) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      return;
    }

    try {
      int favoritos = 0;
      int lecturas = 0;
      int opiniones = 0;
      int calificaciones = 0;

      try {
        final datosFavoritos =
            await db
                .collection("favoritos")
                .doc(usuario.uid)
                .collection("libros")
                .get();

        favoritos = datosFavoritos.docs.length;
      } catch (e) {
        debugPrint("Error al cargar favoritos: $e");
      }

      try {
        final datosLecturas =
            await db
                .collection("usuarios")
                .doc(usuario.uid)
                .collection("lecturas")
                .get();

        lecturas = datosLecturas.docs.length;
      } catch (e) {
        debugPrint("Error al cargar lecturas: $e");
      }

      try {
        final datosOpiniones =
            await db
                .collection("usuarios")
                .doc(usuario.uid)
                .collection("opiniones")
                .get();

        opiniones = datosOpiniones.docs.length;
      } catch (e) {
        debugPrint("Error al cargar opiniones: $e");
      }

      try {
        final libros = await db.collection("libros").get();

        for (final libro in libros.docs) {
          final calificacion =
              await db
                  .collection("libros")
                  .doc(libro.id)
                  .collection("calificaciones")
                  .doc(usuario.uid)
                  .get();

          if (calificacion.exists) {
            calificaciones++;
          }
        }
      } catch (e) {
        debugPrint("Error al cargar calificaciones: $e");
      }

      if (!mounted) return;

      setState(() {
        cantidadFavoritos = favoritos;
        cantidadLecturas = lecturas;
        cantidadCalificaciones = calificaciones;
        cantidadOpiniones = opiniones;
        cargando = false;
      });
    } catch (e) {
      debugPrint("Error al cargar datos del perfil: $e");

      if (!mounted) return;

      setState(() {
        cargando = false;
      });
    }
  }

  String obtenerNombre() {
    final usuario = auth.currentUser;

    if (usuario == null) {
      return "Usuario";
    }

    if (usuario.displayName != null && usuario.displayName!.trim().isNotEmpty) {
      return usuario.displayName!;
    }

    if (usuario.email != null && usuario.email!.contains("@")) {
      return usuario.email!.split("@").first;
    }

    return "Usuario";
  }

  Future<void> cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Cerrar sesión",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 136, 42, 62),
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                "Cerrar sesión",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    try {
      await auth.signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const login()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al cerrar sesión: $e")));
    }
  }

  Widget tarjetaEstadistica({
    required IconData icono,
    required String titulo,
    required int cantidad,
    required Color color,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: color, size: 25),
          ),
          const SizedBox(height: 10),
          Text(
            cantidad.toString(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 136, 42, 62),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget tarjetaOpcion({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icono, color: color),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }

  Future<void> abrirMisLecturas() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MisLecturas()),
    );

    cargarDatos();
  }

  Future<void> abrirMisCalificaciones() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MisCalificaciones()),
    );

    cargarDatos();
  }

  Future<void> abrirMisOpiniones() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MisOpiniones()),
    );

    cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FA),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          "Mi perfil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body:
          cargando
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: cargarDatos,

                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 55,

                        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

                        backgroundImage:
                            usuario?.photoURL != null
                                ? NetworkImage(usuario!.photoURL!)
                                : null,

                        child:
                            usuario?.photoURL == null
                                ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                )
                                : null,
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "¡Hola, ${obtenerNombre()}!",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 136, 42, 62),
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        usuario?.email ?? "Sin correo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Mi actividad",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 136, 42, 62),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          tarjetaEstadistica(
                            icono: Icons.favorite,
                            titulo: "Favoritos",
                            cantidad: cantidadFavoritos,
                            color: Colors.red,
                          ),

                          tarjetaEstadistica(
                            icono: Icons.menu_book,
                            titulo: "Mis lecturas",
                            cantidad: cantidadLecturas,
                            color: Colors.blue,
                          ),

                          tarjetaEstadistica(
                            icono: Icons.star,
                            titulo: "Calificaciones",
                            cantidad: cantidadCalificaciones,
                            color: Colors.orange,
                          ),

                          tarjetaEstadistica(
                            icono: Icons.comment,
                            titulo: "Opiniones",
                            cantidad: cantidadOpiniones,
                            color: Colors.green,
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Mi biblioteca",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 136, 42, 62),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      tarjetaOpcion(
                        icono: Icons.favorite,
                        titulo: "Mi lista de deseos",
                        subtitulo: "$cantidadFavoritos libros guardados",
                        color: Colors.red,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const lista(),
                            ),
                          );

                          cargarDatos();
                        },
                      ),

                      tarjetaOpcion(
                        icono: Icons.menu_book,
                        titulo: "Mis lecturas",
                        subtitulo: "$cantidadLecturas libros en seguimiento",
                        color: Colors.blue,
                        onTap: abrirMisLecturas,
                      ),

                      tarjetaOpcion(
                        icono: Icons.star,
                        titulo: "Mis calificaciones",
                        subtitulo: "$cantidadCalificaciones libros calificados",
                        color: Colors.orange,
                        onTap: abrirMisCalificaciones,
                      ),

                      tarjetaOpcion(
                        icono: Icons.comment,
                        titulo: "Mis opiniones",
                        subtitulo: "$cantidadOpiniones opiniones publicadas",
                        color: Colors.green,
                        onTap: abrirMisOpiniones,
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton.icon(
                          onPressed: cerrarSesion,

                          icon: const Icon(Icons.logout, color: Colors.white),

                          label: const Text(
                            "Cerrar sesión",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              136,
                              42,
                              62,
                            ),

                            padding: const EdgeInsets.symmetric(vertical: 15),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
    );
  }
}

class MisCalificaciones extends StatefulWidget {
  const MisCalificaciones({super.key});

  @override
  State<MisCalificaciones> createState() => _MisCalificacionesState();
}

class _MisCalificacionesState extends State<MisCalificaciones> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> obtenerCalificaciones() async {
    final usuario = auth.currentUser;

    if (usuario == null) {
      return [];
    }

    final resultado = <Map<String, dynamic>>[];

    final libros = await db.collection("libros").get();

    for (final libro in libros.docs) {
      final calificacion =
          await db
              .collection("libros")
              .doc(libro.id)
              .collection("calificaciones")
              .doc(usuario.uid)
              .get();

      if (!calificacion.exists) {
        continue;
      }

      final datosLibro = libro.data();

      final datosCalificacion = calificacion.data() ?? {};

      resultado.add({
        "libroId": libro.id,
        "titulo": datosLibro["titulo"] ?? "Sin título",
        "autor": datosLibro["autor"] ?? "Autor desconocido",
        "portada": datosLibro["portada"] ?? "",
        "estrellas": datosCalificacion["estrellas"] ?? 0,
      });
    }

    return resultado;
  }

  Future<void> editarCalificacion(Map<String, dynamic> datos) async {
    int estrellasActuales = datos["estrellas"] ?? 0;

    int nuevasEstrellas = estrellasActuales;

    final resultado = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Editar calificación"),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    datos["titulo"] ?? "Libro",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text("Selecciona tu nueva calificación:"),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final numero = index + 1;

                      return IconButton(
                        onPressed: () {
                          setDialogState(() {
                            nuevasEstrellas = numero;
                          });
                        },
                        icon: Icon(
                          numero <= nuevasEstrellas
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.orange,
                          size: 35,
                        ),
                      );
                    }),
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
                      nuevasEstrellas == 0
                          ? null
                          : () {
                            Navigator.pop(dialogContext, nuevasEstrellas);
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

    if (resultado == null) {
      return;
    }

    try {
      final usuario = auth.currentUser;

      if (usuario == null) {
        return;
      }

      await db
          .collection("libros")
          .doc(datos["libroId"])
          .collection("calificaciones")
          .doc(usuario.uid)
          .update({"estrellas": resultado});

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Calificación actualizada correctamente")),
      );

      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al actualizar: $e")));
    }
  }

  Future<void> eliminarCalificacion(Map<String, dynamic> datos) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Eliminar calificación"),

          content: Text(
            "¿Quieres eliminar tu calificación de "
            "\"${datos["titulo"]}\"?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

              onPressed: () {
                Navigator.pop(dialogContext, true);
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

    if (confirmar != true) {
      return;
    }

    try {
      final usuario = auth.currentUser;

      if (usuario == null) {
        return;
      }

      await db
          .collection("libros")
          .doc(datos["libroId"])
          .collection("calificaciones")
          .doc(usuario.uid)
          .delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Calificación eliminada correctamente")),
      );

      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al eliminar: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FA),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          "Mis calificaciones",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: obtenerCalificaciones(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar tus calificaciones:\n"
                "${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          final calificaciones = snapshot.data ?? [];

          if (calificaciones.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_border, size: 70, color: Colors.grey),
                  SizedBox(height: 15),
                  Text(
                    "Todavía no has calificado\n"
                    "ningún libro.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),

            itemCount: calificaciones.length,

            itemBuilder: (context, index) {
              final datos = calificaciones[index];

              final titulo = datos["titulo"] ?? "Sin título";

              final autor = datos["autor"] ?? "Autor desconocido";

              final portada = datos["portada"] ?? "";

              final estrellas = datos["estrellas"] ?? 0;

              return Card(
                elevation: 3,

                margin: const EdgeInsets.only(bottom: 12),

                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),

                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(7),

                    child: Image.network(
                      portada,

                      width: 65,
                      height: 85,

                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 65,
                          height: 85,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.book),
                        );
                      },
                    ),
                  ),

                  title: Text(
                    titulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const SizedBox(height: 5),

                      Text(autor),

                      const SizedBox(height: 8),

                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < estrellas ? Icons.star : Icons.star_border,
                            color: Colors.orange,
                            size: 20,
                          );
                        }),
                      ),
                    ],
                  ),

                  trailing: PopupMenuButton<String>(
                    onSelected: (opcion) {
                      if (opcion == "editar") {
                        editarCalificacion(datos);
                      }

                      if (opcion == "eliminar") {
                        eliminarCalificacion(datos);
                      }
                    },

                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: "editar",
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 10),
                                Text("Editar"),
                              ],
                            ),
                          ),

                          const PopupMenuItem(
                            value: "eliminar",
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 10),
                                Text("Eliminar"),
                              ],
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

class MisOpiniones extends StatefulWidget {
  const MisOpiniones({super.key});

  @override
  State<MisOpiniones> createState() => _MisOpinionesState();
}

class _MisOpinionesState extends State<MisOpiniones> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> editarOpinion(DocumentSnapshot documento) async {
    final datos = documento.data() as Map<String, dynamic>;

    final controlador = TextEditingController(text: datos["opinion"] ?? "");

    final nuevaOpinion = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Editar opinión"),

          content: TextField(
            controller: controlador,

            maxLines: 6,

            maxLength: 500,

            decoration: const InputDecoration(
              labelText: "Tu opinión",
              hintText: "Escribe tu opinión...",
              border: OutlineInputBorder(),
            ),
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

              onPressed: () {
                final texto = controlador.text.trim();

                if (texto.isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext, texto);
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

    controlador.dispose();

    if (nuevaOpinion == null || nuevaOpinion.trim().isEmpty) {
      return;
    }

    try {
      await db
          .collection("usuarios")
          .doc(auth.currentUser!.uid)
          .collection("opiniones")
          .doc(documento.id)
          .update({"opinion": nuevaOpinion.trim(), "fecha": Timestamp.now()});

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Opinión actualizada correctamente")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar la opinión: $e")),
      );
    }
  }

  Future<void> eliminarOpinion(DocumentSnapshot documento) async {
    final datos = documento.data() as Map<String, dynamic>;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Eliminar opinión"),

          content: Text(
            "¿Quieres eliminar tu opinión "
            "sobre \"${datos["tituloLibro"] ?? "este libro"}\"?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

              onPressed: () {
                Navigator.pop(dialogContext, true);
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

    if (confirmar != true) {
      return;
    }

    try {
      await db
          .collection("usuarios")
          .doc(auth.currentUser!.uid)
          .collection("opiniones")
          .doc(documento.id)
          .delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Opinión eliminada correctamente")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar la opinión: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = auth.currentUser;

    if (usuario == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Mis opiniones")),

        body: const Center(child: Text("Debes iniciar sesión.")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FA),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          "Mis opiniones",

          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            db
                .collection("usuarios")
                .doc(usuario.uid)
                .collection("opiniones")
                .orderBy("fecha", descending: true)
                .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar tus opiniones:\n"
                "${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          final opiniones = snapshot.data?.docs ?? [];

          if (opiniones.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 70, color: Colors.grey),

                  SizedBox(height: 15),

                  Text(
                    "Todavía no has publicado\n"
                    "ninguna opinión.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),

            itemCount: opiniones.length,

            itemBuilder: (context, index) {
              final documento = opiniones[index];

              final datos = documento.data();

              final titulo = datos["tituloLibro"] ?? "Libro";

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

              return Card(
                elevation: 3,

                margin: const EdgeInsets.only(bottom: 12),

                child: Padding(
                  padding: const EdgeInsets.all(15),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,

                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.comment,
                              color: Colors.green,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  titulo,

                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                if (fechaTexto.isNotEmpty)
                                  Text(
                                    fechaTexto,

                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          PopupMenuButton<String>(
                            onSelected: (opcion) {
                              if (opcion == "editar") {
                                editarOpinion(documento);
                              }

                              if (opcion == "eliminar") {
                                eliminarOpinion(documento);
                              }
                            },

                            itemBuilder:
                                (context) => [
                                  const PopupMenuItem(
                                    value: "editar",
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, color: Colors.blue),
                                        SizedBox(width: 10),
                                        Text("Editar"),
                                      ],
                                    ),
                                  ),

                                  const PopupMenuItem(
                                    value: "eliminar",
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 10),
                                        Text("Eliminar"),
                                      ],
                                    ),
                                  ),
                                ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Text(
                        opinion,

                        style: const TextStyle(fontSize: 15, height: 1.4),
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
