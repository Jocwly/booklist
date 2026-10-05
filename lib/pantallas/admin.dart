import 'package:booklistt/pantallas/inicio_admin.dart';
import 'package:booklistt/pantallas/libros_admin.dart';
import 'package:booklistt/pantallas/listausuarios.dart';
import 'package:booklistt/pantallas/pagina.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int valor_opciones = 0;

  List paginas = [InicioAdmin(), listausuarios(), LibrosAdmin(), pagina()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BookList ADMIN",
          style: TextStyle(fontFamily: 'Cheer', color: Colors.white),
        ),

        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: paginas[valor_opciones],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

        selectedLabelStyle: const TextStyle(color: Colors.white),

        unselectedItemColor: Colors.white,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Usuarios"),

          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Libros"),
        ],

        currentIndex: valor_opciones,

        onTap: (value) {
          setState(() {
            valor_opciones = value;
          });
        },
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 90),

            const Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://cdn.pixabay.com/photo/2016/09/16/09/20/books-1673578_960_720.png",
                ),
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.black),

              title: const Text("Salir", style: TextStyle(color: Colors.black)),

              onTap: () {
                Navigator.pushReplacement(
                  context,

                  MaterialPageRoute(builder: (context) => const pagina()),
                );
              },
            ),

            const Divider(),

            /*ListTile(
              leading: const Icon(
                Icons.admin_panel_settings,

                color: Colors.black,
              ),

              title: const Text(
                "Administrador de Usuarios",

                style: TextStyle(color: Colors.black),
              ),

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => const listausuarios(),
                  ),
                );
              },
            ),*/
          ],
        ),
      ),
    );
  }
}
