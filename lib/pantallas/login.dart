import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:booklistt/pantallas/admin/admin.dart';
import 'package:booklistt/pantallas/registrar.dart';
import 'package:booklistt/pantallas/usuario/usuari.dart';
import 'package:booklistt/estilos/registrar_estilos.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();

  final nombre = TextEditingController();
  final contra = TextEditingController();

  static const String adminUsuario = "admin@gmail.com";
  static const String adminContrasena = "123456";

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  static const String serverClientId =
      "269827222664-606dsajql4e0jsbkb0hfcrg8jgps9df4.apps.googleusercontent.com";

  bool googleInicializado = false;

  bool mostrarContrasena = false;

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

    if (usuarioLimpio == adminUsuario && contrasena == adminContrasena) {
      if (!mounted) return false;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Admin()),
      );

      return true;
    }

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

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      print("Cuenta Google seleccionada: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      print("ID TOKEN obtenido");

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

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
          padding: const EdgeInsets.symmetric(vertical: 20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const Text("INICIA SESIÓN", style: RegistrarEstilos.titulo),

              RegistrarEstilos.espacioTitulo,

              Form(
                key: _formKey,

                child: Column(
                  children: [
                    campoTexto(
                      controller: nombre,

                      icon: Icons.email,

                      texto: "E-mail:",

                      tipoTeclado: TextInputType.emailAddress,

                      validar: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Escribe correo";
                        }

                        return null;
                      },
                    ),

                    campoTexto(
                      controller: contra,

                      icon: Icons.lock,

                      texto: "Contraseña:",

                      ocultar: !mostrarContrasena,

                      mostrarBoton: true,

                      onMostrar: () {
                        setState(() {
                          mostrarContrasena = !mostrarContrasena;
                        });
                      },

                      validar: (value) {
                        if (value == null || value.isEmpty) {
                          return "Escribe contraseña";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: RegistrarEstilos.anchoCampo,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

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

                        style: RegistrarEstilos.botonRegistrar,

                        child: const Text(
                          "Iniciar Sesión",
                          style: RegistrarEstilos.textoBoton,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    SizedBox(
                      width: RegistrarEstilos.anchoCampo,

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

                        style: RegistrarEstilos.botonRegistrar,
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: RegistrarEstilos.anchoCampo,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const registrar(),
                            ),
                          );
                        },

                        style: RegistrarEstilos.botonRegistrar,

                        child: const Text(
                          "Registrarse",

                          style: RegistrarEstilos.textoBoton,
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

    bool mostrarBoton = false,

    VoidCallback? onMostrar,

    TextInputType? tipoTeclado,

    String? Function(String?)? validar,
  }) {
    return Padding(
      padding: RegistrarEstilos.margenCampo,

      child: SizedBox(
        width: RegistrarEstilos.anchoCampo,

        height: RegistrarEstilos.altoCampo,

        child: TextFormField(
          controller: controller,

          obscureText: ocultar,

          keyboardType: tipoTeclado,

          validator: validar,

          decoration: RegistrarEstilos.decoracionCampo(
            texto: texto,

            icono: icon,

            iconoFinal:
                mostrarBoton
                    ? IconButton(
                      onPressed: onMostrar,

                      icon: Icon(
                        ocultar ? Icons.visibility : Icons.visibility_off,
                      ),
                    )
                    : null,
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
              "Los datos ingresados son incorrectos. "
              "Por favor, verifique.",
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
