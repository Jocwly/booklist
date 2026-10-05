/*
import 'package:booklistt/basedatos/operaciones.dart';
import 'package:booklistt/modelo/modelo.dart';
import 'package:booklistt/pantallas/listausuarios.dart';
import 'package:flutter/material.dart';

class Actualizar extends StatefulWidget {
  final Modelo modelo;

  const Actualizar({super.key, required this.modelo});

  @override
  State<Actualizar> createState() => _ActualizarState();
}

class _ActualizarState extends State<Actualizar> {
  final _formKey = GlobalKey<FormState>();

  //Recuperar datos
  late final TextEditingController nombre;
  late final TextEditingController contra;
  late final TextEditingController confcontra;

  @override
  void initState() {
    super.initState();
    nombre = TextEditingController(text: widget.modelo.user);
    contra = TextEditingController(text: widget.modelo.pass);
    confcontra = TextEditingController(text: widget.modelo.pass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("REGISTRAR")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center, // Centra todo el contenido verticalmente
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centra horizontalmente
            children: [
              Text(
                "ACTUALIZAR",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 136, 42, 62),
                ),
              ),
              SizedBox(height: 20),
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
                            if (value!.isEmpty) {
                              return "Escribe usuario o correo";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: "Ingresa Usuario o email",
                            filled: true, // Habilita el color de fondo
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
                      height: 67,
                      child: TextFormField(
                        controller: contra,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Escribe contraseña";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: "Contraseña",
                          filled: true, // Habilita el color de fondo
                          fillColor: const Color.fromARGB(255, 217, 217, 217),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 60,
                      child: TextFormField(
                        controller: confcontra,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Confirma tu contraseña";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: "Confirmar contraseña",
                          filled: true, // Habilita el color de fondo
                          fillColor: const Color.fromARGB(255, 217, 217, 217),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("Registrado");
                          print(
                            "Nombre: " +
                                nombre.text +
                                "Contraseña:" +
                                contra.text +
                                "Confirmacion de la contraseña:" +
                                confcontra.text,
                          );
                          /*widget.modelo.user=nombre.text;
                              widget.modelo.pass=contra.text;*/
                          widget.modelo.actualizarUsuYCont(
                            nombre.text,
                            contra.text,
                          );
                          Operaciones.actualizar(widget.modelo);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => listausuarios(),
                            ),
                          );
                        } else {
                          print("Verifica si hay campos vacios");
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 136, 42, 62),
                        padding: EdgeInsets.symmetric(
                          horizontal: 113,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Actualizar",
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
*/
