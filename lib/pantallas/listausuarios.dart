import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class listausuarios extends StatefulWidget {
  const listausuarios({super.key});

  @override
  State<listausuarios> createState() => _listausuariosState();
}

class _listausuariosState extends State<listausuarios> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> eliminarUsuario(String id) async {
    await db.collection("usuarios").doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Usuarios"),

        backgroundColor: const Color.fromARGB(255, 136, 42, 62),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection("usuarios").snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay usuarios registrados"));
          }

          final usuarios = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15),

            itemCount: usuarios.length,

            itemBuilder: (context, index) {
              final usuario = usuarios[index];

              final datos = usuario.data() as Map<String, dynamic>;

              return Card(
                elevation: 5,

                margin: const EdgeInsets.only(bottom: 10),

                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),

                  title: Text(
                    datos["correo"] ?? "Sin correo",

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  //subtitle: Text("Rol: ${datos["rol"] ?? "usuario"}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),

                    onPressed: () async {
                      await eliminarUsuario(usuario.id);

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Usuario eliminado")),
                      );
                    },
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
