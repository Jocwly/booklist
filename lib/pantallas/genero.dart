import 'package:flutter/material.dart';

import 'package:booklistt/pantallas/libros_genero.dart';

class genero extends StatefulWidget {
  const genero({super.key});

  @override
  State<genero> createState() => _generoState();
}

class _generoState extends State<genero> {
  // ---------------------------------------------------------
  // ABRIR GENERO
  // ---------------------------------------------------------

  void abrirGenero(String generoSeleccionado) {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) => LibrosGenero(genero: generoSeleccionado),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // -----------------------------------------------------
      // APP BAR
      // -----------------------------------------------------
      appBar: AppBar(
        title: Container(
          height: 50,

          padding: const EdgeInsets.all(10),

          child: Row(
            children: [
              const Expanded(
                child: Text(
                  "Buscar un libro...",

                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(width: 10),

              const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 147, 60, 78),

                child: Icon(Icons.search, color: Colors.white),
              ),
            ],
          ),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),

            color: const Color.fromARGB(255, 147, 60, 78),
          ),
        ),

        backgroundColor: const Color.fromARGB(255, 136, 42, 62),
      ),

      // -----------------------------------------------------
      // BODY
      // -----------------------------------------------------
      body: ListView(
        children: [
          Column(
            children: [
              // =================================================
              // PRIMERA FILA
              // =================================================
              Row(
                children: [
                  // ------------------------------------------------
                  // CLASICOS
                  // ------------------------------------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        abrirGenero("Clásicos");
                      },

                      child: Container(
                        margin: const EdgeInsets.all(10),

                        padding: const EdgeInsets.all(20),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            CircleAvatar(
                              backgroundImage: const NetworkImage(
                                "https://static.vecteezy.com/system/resources/previews/002/219/582/original/illustration-of-book-icon-free-vector.jpg",
                              ),

                              radius: 50,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Clásicos",

                              style: TextStyle(color: Colors.black),

                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------------------
                  // FICCION
                  // ------------------------------------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        abrirGenero("Ciencia ficción");
                      },

                      child: Container(
                        margin: const EdgeInsets.all(10),

                        padding: const EdgeInsets.all(20),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            CircleAvatar(
                              backgroundImage: const NetworkImage(
                                "https://static.vecteezy.com/system/resources/previews/010/324/111/non_2x/science-fiction-genre-line-icon-illustration-vector.jpg",
                              ),

                              radius: 50,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Ficción",

                              style: TextStyle(color: Colors.black),

                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------------------
                  // AVENTURA
                  // ------------------------------------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        abrirGenero("Aventura");
                      },

                      child: Container(
                        margin: const EdgeInsets.all(10),

                        padding: const EdgeInsets.all(20),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            CircleAvatar(
                              backgroundImage: const NetworkImage(
                                "https://cdn3.iconfinder.com/data/icons/literary-genres-6/500/yul749_31_book_crossed_swords_blade_cavalry_claymore_dagger-512.png",
                              ),

                              radius: 50,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Aventura y acción",

                              style: TextStyle(color: Colors.black),

                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // =================================================
              // SEGUNDA FILA
              // =================================================
              Row(
                children: [
                  // ------------------------------------------------
                  // FANTASIA
                  // ------------------------------------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        abrirGenero("Fantasía");
                      },

                      child: Container(
                        margin: const EdgeInsets.all(10),

                        padding: const EdgeInsets.all(20),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            CircleAvatar(
                              backgroundImage: const NetworkImage(
                                "https://th.bing.com/th/id/OIP.RyjtBrmxPWhzSSjHOXh9HQHaHa?rs=1&pid=ImgDetMain",
                              ),

                              radius: 50,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Fantasía",

                              style: TextStyle(color: Colors.black),

                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------------------
                  // SUSPENSO
                  // ------------------------------------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        abrirGenero("Suspenso");
                      },

                      child: Container(
                        margin: const EdgeInsets.all(10),

                        padding: const EdgeInsets.all(20),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            CircleAvatar(
                              backgroundImage: const AssetImage(
                                "asset/images/suspenso.jpg",
                              ),

                              radius: 50,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Suspenso",

                              style: TextStyle(color: Colors.black),

                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------------------
                  // MISTERIO
                  // ------------------------------------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        abrirGenero("Misterio");
                      },

                      child: Container(
                        margin: const EdgeInsets.all(10),

                        padding: const EdgeInsets.all(20),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            CircleAvatar(
                              backgroundImage: const AssetImage(
                                "asset/images/misterio.png",
                              ),

                              radius: 50,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Misterio",

                              style: TextStyle(color: Colors.black),

                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // =================================================
              // TERCERA FILA
              // =================================================
              Row(
                children: [
                  // ------------------------------------------------
                  // ROMANCE
                  // ------------------------------------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        abrirGenero("Romance");
                      },

                      child: Container(
                        margin: const EdgeInsets.all(10),

                        padding: const EdgeInsets.all(20),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            CircleAvatar(
                              backgroundImage: const AssetImage(
                                "asset/images/romance.jpg",
                              ),

                              radius: 50,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Romance",

                              style: TextStyle(color: Colors.black),

                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------------------
                  // DRAMA
                  // ------------------------------------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        abrirGenero("Drama");
                      },

                      child: Container(
                        margin: const EdgeInsets.all(10),

                        padding: const EdgeInsets.all(20),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            CircleAvatar(
                              backgroundImage: const NetworkImage(
                                "https://media.istockphoto.com/vectors/masks-symbol-vector-id1175496220?k=20&m=1175496220&s=612x612&w=0&h=6YHLFqoSHrpFWu67MycpmAg0ZLBPlP1VzrVYtewS5iQ=",
                              ),

                              radius: 50,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Drama",

                              style: TextStyle(color: Colors.black),

                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------------------
                  // MITOLOGIA
                  // ------------------------------------------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        abrirGenero("Mitología");
                      },

                      child: Container(
                        margin: const EdgeInsets.all(10),

                        padding: const EdgeInsets.all(20),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            CircleAvatar(
                              backgroundImage: const NetworkImage(
                                "https://thumbs.dreamstime.com/b/zeus-greek-god-mythology-line-icon-vector-illustration-zeus-greek-god-mythology-line-icon-vector-zeus-greek-god-mythology-sign-300337039.jpg",
                              ),

                              radius: 50,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Mitología",

                              style: TextStyle(color: Colors.black),

                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
