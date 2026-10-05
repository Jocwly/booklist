import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:booklistt/pantallas/login.dart';
import 'package:booklistt/pantallas/lista.dart';

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

  // ==========================================================
  // CARGAR DATOS
  // ==========================================================

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
      // ========================================================
      // FAVORITOS
      // favoritos/{uid}/libros
      // ========================================================

      int favoritos = 0;

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

      // ========================================================
      // LECTURAS
      // usuarios/{uid}/lecturas
      // ========================================================

      int lecturas = 0;

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

      // ========================================================
      // OPINIONES
      // usuarios/{uid}/opiniones
      // ========================================================

      int opiniones = 0;

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

      // ========================================================
      // CALIFICACIONES
      //
      // Las calificaciones están guardadas dentro de cada libro:
      //
      // libros/{libroId}/calificaciones/{uid}
      //
      // Por eso obtenemos todos los libros y revisamos
      // si existe una calificación del usuario.
      // ========================================================

      int calificaciones = 0;

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

  // ==========================================================
  // NOMBRE DEL USUARIO
  // ==========================================================

  String obtenerNombre() {
    final usuario = auth.currentUser;

    if (usuario == null) {
      return "Usuario";
    }

    // Google u otro proveedor
    if (usuario.displayName != null && usuario.displayName!.trim().isNotEmpty) {
      return usuario.displayName!;
    }

    // Usuario registrado con correo
    if (usuario.email != null && usuario.email!.contains("@")) {
      return usuario.email!.split("@").first;
    }

    return "Usuario";
  }

  // ==========================================================
  // CERRAR SESIÓN
  // ==========================================================

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

    if (confirmar != true) {
      return;
    }

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

  // ==========================================================
  // TARJETA DE ESTADÍSTICA
  // ==========================================================

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

  // ==========================================================
  // TARJETA DE OPCIÓN
  // ==========================================================

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

  // ==========================================================
  // MENSAJE TEMPORAL
  // ==========================================================

  void mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
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
                      // ==================================================
                      // FOTO DEL USUARIO
                      // ==================================================
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

                      // ==================================================
                      // NOMBRE
                      // ==================================================
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

                      // ==================================================
                      // CORREO
                      // ==================================================
                      Text(
                        usuario?.email ?? "Sin correo",

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ==================================================
                      // MI ACTIVIDAD
                      // ==================================================
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

                      // ==================================================
                      // OPCIONES
                      // ==================================================
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

                      // ==================================================
                      // FAVORITOS
                      // ==================================================
                      tarjetaOpcion(
                        icono: Icons.favorite,
                        titulo: "Mi lista de deseos",
                        subtitulo: "$cantidadFavoritos libros guardados",
                        color: Colors.red,

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const lista(),
                            ),
                          );
                        },
                      ),

                      // ==================================================
                      // LECTURAS
                      // ==================================================
                      tarjetaOpcion(
                        icono: Icons.menu_book,
                        titulo: "Mis lecturas",
                        subtitulo: "$cantidadLecturas libros en seguimiento",
                        color: Colors.blue,

                        onTap: () {
                          mostrarMensaje(
                            "Aquí podrás consultar tus libros en lectura 📚",
                          );
                        },
                      ),

                      // ==================================================
                      // CALIFICACIONES
                      // ==================================================
                      tarjetaOpcion(
                        icono: Icons.star,
                        titulo: "Mis calificaciones",
                        subtitulo: "$cantidadCalificaciones libros calificados",
                        color: Colors.orange,

                        onTap: () {
                          mostrarMensaje(
                            "Aquí podrás consultar tus calificaciones ⭐",
                          );
                        },
                      ),

                      // ==================================================
                      // OPINIONES
                      // ==================================================
                      tarjetaOpcion(
                        icono: Icons.comment,
                        titulo: "Mis opiniones",
                        subtitulo: "$cantidadOpiniones opiniones publicadas",
                        color: Colors.green,

                        onTap: () {
                          mostrarMensaje(
                            "Aquí podrás consultar tus opiniones 💬",
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // CERRAR SESIÓN
                      // ==================================================
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
