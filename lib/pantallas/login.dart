import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:booklistt/pantallas/admin/admin.dart';
import 'package:booklistt/pantallas/registrar.dart';
import 'package:booklistt/pantallas/usuario/usuari.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();

  final nombre = TextEditingController();
  final contra = TextEditingController();

  // CREDENCIALES ADMIN
  static const String adminUsuario = "admin@gmail.com";
  static const String adminContrasena = "123456";

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  static const String serverClientId =
      "269827222664-606dsajql4e0jsbkb0hfcrg8jgps9df4.apps.googleusercontent.com";

  bool googleInicializado = false;

  @override
  void initState() {
    super.initState();

    inicializarGoogle();
  }

  Future<void> inicializarGoogle() async {
    try {
      await googleSignIn.initialize(serverClientId: serverClientId);

      googleInicializado = true;

      print("Google Sign-In inicializado correctamente");
    } catch (e) {
      print("Error al inicializar Google Sign-In: $e");
    }
  }

  @override
  void dispose() {
    nombre.dispose();
    contra.dispose();

    super.dispose();
  }

  Future<bool> verificarLogin(String usuario, String contrasena) async {
    final usuarioLimpio = usuario.trim();

    // LOGIN ADMINISTRADOR

    if (usuarioLimpio == adminUsuario && contrasena == adminContrasena) {
      if (!mounted) return false;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Admin()),
      );

      return true;
    }

    // LOGIN USUARIO FIREBASE

    try {
      await auth.signInWithEmailAndPassword(
        email: usuarioLimpio,
        password: contrasena,
      );

      if (!mounted) return false;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UsuariAp()),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      print("Error Firebase Auth: ${e.code}");

      return false;
    }
  }

  Future<void> iniciarSesionGoogle() async {
    try {
      if (!googleInicializado) {
        await inicializarGoogle();
      }

      if (!googleInicializado) {
        throw Exception("Google Sign-In no pudo inicializarse.");
      }

      print("Abriendo selector de cuentas Google...");

      // Mostrar selector de cuentas

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      print("Cuenta Google seleccionada: ${googleUser.email}");

      // Obtener autenticación

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      print("ID TOKEN obtenido");

      // Crear credencial de Firebase

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión en Firebase

      final UserCredential usuarioCredencial = await auth.signInWithCredential(
        credential,
      );

      final User? usuario = usuarioCredencial.user;

      if (usuario == null) {
        throw Exception("No se pudo obtener el usuario de Firebase.");
      }

      print("Usuario Firebase: ${usuario.email}");

      await db.collection("usuarios").doc(usuario.uid).set({
        "correo": usuario.email ?? "",
        "nombre": usuario.displayName ?? "",
        "rol": "usuario",
      }, SetOptions(merge: true));

      print("Usuario guardado correctamente en Firestore");

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UsuariAp()),
      );
    } on GoogleSignInException catch (e) {
      print("Error Google Sign-In: ${e.code}");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error de Google: ${e.code}")));
    } on FirebaseAuthException catch (e) {
      print("Error Firebase Google: ${e.code}");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de Firebase: ${e.message ?? e.code}")),
      );
    } catch (e) {
      print("Error inesperado Google: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ocurrió un error al iniciar sesión con Google."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LOGIN")),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "INICIA SESIÓN",
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        height: 60,
                        child: TextFormField(
                          controller: nombre,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Escribe correo";
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "E-mail:",
                            filled: true,
                            fillColor: const Color.fromARGB(255, 217, 217, 217),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 300,
                      height: 60,
                      child: TextFormField(
                        controller: contra,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Escribe contraseña";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Contraseña:",
                          filled: true,
                          fillColor: const Color.fromARGB(255, 217, 217, 217),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    OutlinedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final correcto = await verificarLogin(
                            nombre.text,
                            contra.text,
                          );

                          if (!correcto && mounted) {
                            _ShowDatosIncorrectos(context);
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 136, 42, 62),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 110,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Iniciar Sesion",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: 300,
                      child: OutlinedButton.icon(
                        onPressed: iniciarSesionGoogle,
                        icon: const Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Continuar con Google",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
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
                          side: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const registrar(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 136, 42, 62),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 113,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Registrarse",
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
}

void _ShowDatosIncorrectos(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Text("Alerta"),
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Los datos ingresados son incorrectos. Por favor, verifique.",
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
