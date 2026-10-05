// pantallas/registrar.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:booklistt/pantallas/login.dart';

class registrar extends StatefulWidget {
  const registrar({super.key});

  @override
  State<registrar> createState() => _registrarState();
}

class _registrarState extends State<registrar> {
  final _formKey = GlobalKey<FormState>();

  final nombre = TextEditingController();

  final contra = TextEditingController();

  final confcontra = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void dispose() {
    nombre.dispose();

    contra.dispose();

    confcontra.dispose();

    super.dispose();
  }

  Future<void> registrarUsuario() async {
    try {
      print("Iniciando registro...");

      // CREAR USUARIO EN FIREBASE AUTH

      UserCredential usuarioCreado = await auth.createUserWithEmailAndPassword(
        email: nombre.text.trim(),

        password: contra.text.trim(),
      );

      print("Usuario creado: ${usuarioCreado.user!.uid}");

      // GUARDAR DATOS EN FIRESTORE
      print("ANTES DE GUARDAR EN FIRESTORE");

      try {
        await db.collection("usuarios").doc(usuarioCreado.user!.uid).set({
          "uid": usuarioCreado.user!.uid,

          "correo": nombre.text.trim(),

          "rol": "usuario",

          "fechaRegistro": Timestamp.now(),
        });

        print("DESPUÉS DE GUARDAR EN FIRESTORE");
      } catch (e) {
        print("ERROR FIRESTORE:");
        print(e);
      }

      print("Usuario guardado en Firestore correctamente");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario registrado correctamente")),
      );

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (context) => const login()),
      );
    } on FirebaseAuthException catch (e) {
      print("ERROR FIREBASE AUTH:");

      print(e.code);

      print(e.message);

      String mensaje = "Error al registrar";

      if (e.code == "email-already-in-use") {
        mensaje = "Este correo ya está registrado";
      } else if (e.code == "weak-password") {
        mensaje = "La contraseña debe tener mínimo 6 caracteres";
      } else if (e.code == "invalid-email") {
        mensaje = "El correo no es válido";
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mensaje)));
      }
    } catch (e) {
      print("ERROR GENERAL:");

      print(e);

      // Si Auth creó el usuario pero Firestore falló,
      // cerramos sesión para evitar inconsistencias.

      await auth.signOut();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error guardando datos del usuario")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("REGISTRAR")),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const Text(
                "REGISTRATE",

                style: TextStyle(
                  fontSize: 24,

                  fontWeight: FontWeight.bold,

                  color: Color.fromARGB(255, 136, 42, 62),
                ),
              ),

              const SizedBox(height: 20),

              Form(
                key: _formKey,

                child: Column(
                  children: [
                    campoTexto(
                      controller: nombre,

                      icon: Icons.person,

                      texto: "Ingresa correo",

                      validar: (value) {
                        if (value == null || value.isEmpty) {
                          return "Escribe correo";
                        }

                        return null;
                      },
                    ),

                    campoTexto(
                      controller: contra,

                      icon: Icons.lock,

                      texto: "Contraseña",

                      ocultar: true,

                      validar: (value) {
                        if (value == null || value.isEmpty) {
                          return "Escribe contraseña";
                        }

                        if (value.length < 6) {
                          return "Mínimo 6 caracteres";
                        }

                        return null;
                      },
                    ),

                    campoTexto(
                      controller: confcontra,

                      icon: Icons.lock,

                      texto: "Confirmar contraseña",

                      ocultar: true,

                      validar: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirma contraseña";
                        }

                        if (value != contra.text) {
                          return "Las contraseñas no coinciden";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await registrarUsuario();
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 136, 42, 62),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 113,

                          vertical: 15,
                        ),
                      ),

                      child: const Text(
                        "Registrate",

                        style: TextStyle(
                          color: Colors.white,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget campoTexto({
    required TextEditingController controller,

    required IconData icon,

    required String texto,

    bool ocultar = false,

    String? Function(String?)? validar,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),

      child: SizedBox(
        width: 300,

        height: 60,

        child: TextFormField(
          controller: controller,

          obscureText: ocultar,

          validator: validar,

          decoration: InputDecoration(
            prefixIcon: Icon(icon),

            labelText: texto,

            filled: true,

            fillColor: const Color.fromARGB(255, 217, 217, 217),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),

              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
