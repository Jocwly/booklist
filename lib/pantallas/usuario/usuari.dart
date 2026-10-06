import 'package:booklistt/pantallas/genero.dart';
import 'package:booklistt/pantallas/usuario/inicio.dart';
import 'package:booklistt/pantallas/lista.dart';
import 'package:booklistt/pantallas/login.dart';
import 'package:booklistt/pantallas/usuario/mis_lecturas.dart';
import 'package:booklistt/pantallas/pagina.dart';
import 'package:booklistt/pantallas/usuario/perfil.dart';
import 'package:flutter/material.dart';

class UsuariAp extends StatefulWidget {
  const UsuariAp({super.key});

  @override
  State<UsuariAp> createState() => _UsuariApState();
}

class _UsuariApState extends State<UsuariAp> {
  int valorOpciones = 0;

  // ==========================================================
  // OBTENER LA PANTALLA ACTUAL
  // ==========================================================

  Widget obtenerPagina() {
    switch (valorOpciones) {
      case 0:
        return const inicio();

      case 1:
        return const lista();

      case 2:
        return const genero();

      default:
        return const inicio();
    }
  }

  // ==========================================================
  // CERRAR SESIÓN
  // ==========================================================

  void cerrarSesion() {
    showDialog(
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
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 136, 42, 62),
              ),

              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const login()),
                  (route) => false,
                );
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
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        title: const Text(
          "BookList",
          style: TextStyle(fontFamily: 'Cheer', color: Colors.white),
        ),

        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ========================================================
      // PANTALLA ACTUAL
      // ========================================================
      body: obtenerPagina(),

      // ========================================================
      // BARRA DE NAVEGACIÓN
      // ========================================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: valorOpciones,

        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        selectedItemColor: Colors.white,

        unselectedItemColor: Colors.white70,

        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Géneros",
          ),
        ],

        onTap: (value) {
          setState(() {
            valorOpciones = value;
          });
        },
      ),

      // ========================================================
      // MENÚ LATERAL
      // ========================================================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,

          children: [
            // ==================================================
            // ENCABEZADO
            // ==================================================
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 136, 42, 62),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const CircleAvatar(
                    radius: 35,

                    backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2016/09/16/09/20/books-1673578_960_720.png",
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "BookList",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // INICIO
            // ==================================================
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Color.fromARGB(255, 136, 42, 62),
              ),

              title: const Text("Inicio"),

              onTap: () {
                Navigator.pop(context);

                setState(() {
                  valorOpciones = 0;
                });
              },
            ),

            // ==================================================
            // FAVORITOS
            // ==================================================
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Color.fromARGB(255, 136, 42, 62),
              ),

              title: const Text("Mi perfil"),

              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Perfil()),
                );
              },
            ),

            // ==================================================
            // GENEROS
            // ==================================================
            ListTile(
              leading: const Icon(
                Icons.menu_book,
                color: Color.fromARGB(255, 136, 42, 62),
              ),

              title: const Text("Mis Lecturas"),

              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MisLecturas()),
                );
              },
            ),
            const Divider(),

            // ==================================================
            // PERFIL
            // ==================================================

            // ==================================================
            // CERRAR SESIÓN
            // ==================================================
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),

              title: const Text("Cerrar sesión"),

              onTap: cerrarSesion,
            ),
          ],
        ),
      ),
    );
  }
}
