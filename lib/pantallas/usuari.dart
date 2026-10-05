import 'package:booklistt/pantallas/genero.dart';
import 'package:booklistt/pantallas/inicio.dart';
import 'package:booklistt/pantallas/lista.dart';
import 'package:booklistt/pantallas/login.dart';
import 'package:booklistt/pantallas/pagina.dart';
import 'package:flutter/material.dart';

class UsuariAp extends StatefulWidget {
  const UsuariAp({super.key});

  @override
  State<UsuariAp> createState() => _UsuariApState();
}

class _UsuariApState extends State<UsuariAp> {
  int valor_opciones = 0;
  List paginas = [inicio(), lista(), genero(), login(), pagina()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BookList",
          style: TextStyle(
            fontFamily: 'Cheer',
            //fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 136, 42, 62),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: paginas[valor_opciones],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 136, 42, 62),
        selectedLabelStyle: TextStyle(color: Colors.white),
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: "Lista de deseos",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Generos"),
        ],
        onTap: (value) {
          setState(() {
            //muestra la pantalla sobre la pantalla
            valor_opciones = value;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(height: 90),
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://cdn.pixabay.com/photo/2016/09/16/09/20/books-1673578_960_720.png",
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.black),
              title: Text("Salir", style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pagina()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
