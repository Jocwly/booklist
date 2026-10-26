import 'package:flutter/material.dart';

import 'package:booklistt/pantallas/usuario/libros_genero.dart';

class genero extends StatefulWidget {
  const genero({super.key});

  @override
  State<genero> createState() => _generoState();
}

class _generoState extends State<genero> {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Text(
          "GÉNEROS",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        backgroundColor: const Color.fromARGB(255, 136, 42, 62),
      ),

      body: ListView(
        children: [
          Column(
            children: [
              Row(
                children: [
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

              Row(
                children: [
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
                                "https://static.vecteezy.com/system/resources/thumbnails/046/595/707/small_2x/magic-hat-logo-or-modern-line-icon-line-art-and-icon-design-with-bold-outline-black-and-white-pixel-perfect-minimalistic-symbol-isolate-white-background-creative-logotype-vector.jpg",
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

              Row(
                children: [
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
                                "https://tse3.mm.bing.net/th/id/OIP.hRgK8uRzS8j_seyAH84kowHaHa?r=0&w=2000&h=2000&rs=1&pid=ImgDetMain&o=7&rm=3",
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
