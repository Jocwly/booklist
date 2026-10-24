import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:booklistt/pantallas/login.dart';
import 'package:booklistt/estilos/registrar_estilos.dart';

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

  bool mostrarContrasena = false;

  bool mostrarConfirmacion = false;

  @override
  void dispose() {
    nombre.dispose();
    contra.dispose();
    confcontra.dispose();

    super.dispose();
  }

  bool contrasenaSegura(String password) {
    final tieneMayuscula = RegExp(r'[A-Z]').hasMatch(password);

    final tieneMinuscula = RegExp(r'[a-z]').hasMatch(password);

    final tieneNumero = RegExp(r'[0-9]').hasMatch(password);

    final tieneEspecial = RegExp(
      r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/;]',
    ).hasMatch(password);

    return password.length >= 8 &&
        tieneMayuscula &&
        tieneMinuscula &&
        tieneNumero &&
        tieneEspecial;
  }

  Future<void> registrarUsuario() async {
    try {
      print("Iniciando registro...");

      // Crear usuario en Firebase Authentication

      UserCredential usuarioCreado = await auth.createUserWithEmailAndPassword(
        email: nombre.text.trim(),
        password: contra.text,
      );

      print("Usuario creado: ${usuarioCreado.user!.uid}");

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

        await auth.signOut();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "El usuario se creó, pero ocurrió un error al guardar sus datos.",
            ),
          ),
        );

        return;
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
        mensaje = "Este correo ya está registrado.";
      } else if (e.code == "weak-password") {
        mensaje = "La contraseña no es lo suficientemente segura.";
      } else if (e.code == "invalid-email") {
        mensaje = "El correo no es válido.";
      } else if (e.code == "network-request-failed") {
        mensaje = "No hay conexión a Internet. Inténtalo nuevamente.";
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mensaje)));
      }
    } catch (e) {
      print("ERROR GENERAL:");
      print(e);

      await auth.signOut();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ocurrió un error al registrar el usuario."),
          ),
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
          padding: const EdgeInsets.symmetric(vertical: 20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const Text("REGÍSTRATE", style: RegistrarEstilos.titulo),

              RegistrarEstilos.espacioTitulo,

              Form(
                key: _formKey,

                child: Column(
                  children: [
                    campoTexto(
                      controller: nombre,
                      icon: Icons.email,
                      texto: "Ingresa correo",

                      tipoTeclado: TextInputType.emailAddress,

                      validar: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Escribe un correo";
                        }

                        final correo = value.trim();

                        final expresionCorreo = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );

                        if (!expresionCorreo.hasMatch(correo)) {
                          return "Ingresa un correo válido";
                        }

                        return null;
                      },
                    ),

                    campoTexto(
                      controller: contra,

                      icon: Icons.lock,

                      texto: "Contraseña",

                      ocultar: !mostrarContrasena,

                      mostrarBoton: true,

                      onMostrar: () {
                        setState(() {
                          mostrarContrasena = !mostrarContrasena;
                        });
                      },

                      validar: (value) {
                        if (value == null || value.isEmpty) {
                          return "Escribe una contraseña";
                        }

                        if (value.length < 8) {
                          return "Mínimo 8 caracteres";
                        }

                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return "Debe contener una mayúscula";
                        }

                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return "Debe contener una minúscula";
                        }

                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return "Debe contener un número";
                        }

                        if (!RegExp(
                          r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/;]',
                        ).hasMatch(value)) {
                          return "Debe contener un carácter especial";
                        }

                        return null;
                      },
                    ),

                    /* Container(
                      width: RegistrarEstilos.anchoCampo,

                      margin: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 8,
                      ),

                      padding: RegistrarEstilos.paddingRequisitos,

                      decoration: RegistrarEstilos.requisitos,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "La contraseña debe tener:",

                            style: RegistrarEstilos.tituloRequisitos,
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "• Mínimo 8 caracteres",

                            style: RegistrarEstilos.requisito(
                              cumplido: contra.text.length >= 8,
                            ),
                          ),

                          Text(
                            "• Una letra mayúscula",

                            style: RegistrarEstilos.requisito(
                              cumplido: RegExp(r'[A-Z]').hasMatch(contra.text),
                            ),
                          ),

                          Text(
                            "• Una letra minúscula",

                            style: RegistrarEstilos.requisito(
                              cumplido: RegExp(r'[a-z]').hasMatch(contra.text),
                            ),
                          ),

                          Text(
                            "• Un número",

                            style: RegistrarEstilos.requisito(
                              cumplido: RegExp(r'[0-9]').hasMatch(contra.text),
                            ),
                          ),

                          Text(
                            "• Un carácter especial (!, @, #, \$, etc.)",

                            style: RegistrarEstilos.requisito(
                              cumplido: RegExp(
                                r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/;]',
                              ).hasMatch(contra.text),
                            ),
                          ),
                        ],
                      ),
                    ),*/
                    campoTexto(
                      controller: confcontra,

                      icon: Icons.lock_outline,

                      texto: "Confirmar contraseña",

                      ocultar: !mostrarConfirmacion,

                      mostrarBoton: true,

                      onMostrar: () {
                        setState(() {
                          mostrarConfirmacion = !mostrarConfirmacion;
                        });
                      },

                      validar: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirma la contraseña";
                        }

                        if (value != contra.text) {
                          return "Las contraseñas no coinciden";
                        }

                        return null;
                      },
                    ),

                    RegistrarEstilos.espacioBoton,

                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        if (_formKey.currentState!.validate()) {
                          await registrarUsuario();
                        }
                      },

                      style: RegistrarEstilos.botonRegistrar,

                      child: const Text(
                        "Regístrate",

                        style: RegistrarEstilos.textoBoton,
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

          onChanged: (value) {
            if (controller == contra) {
              setState(() {});
            }
          },

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
