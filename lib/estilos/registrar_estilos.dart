import 'package:flutter/material.dart';

class RegistrarEstilos {
  static const Color colorPrincipal = Color.fromARGB(255, 136, 42, 62);

  static const Color colorCampo = Color.fromARGB(255, 217, 217, 217);

  static const Color colorRequisitos = Color(0xFFF5F5F5);

  static const Color colorTexto = Colors.black;

  static const Color colorTextoBlanco = Colors.white;

  static const Color colorCorrecto = Colors.green;

  static const Color colorPendiente = Colors.grey;

  static const TextStyle titulo = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: colorPrincipal,
  );

  static const double anchoCampo = 300;

  static const double altoCampo = 60;

  static const double radioCampo = 30;

  static const EdgeInsets margenCampo = EdgeInsets.all(8);

  static InputDecoration decoracionCampo({
    required String texto,
    required IconData icono,
    Widget? iconoFinal,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icono),

      suffixIcon: iconoFinal,

      labelText: texto,

      filled: true,

      fillColor: colorCampo,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radioCampo),

        borderSide: BorderSide.none,
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    );
  }

  static BoxDecoration requisitos = BoxDecoration(
    color: colorRequisitos,

    borderRadius: BorderRadius.circular(15),
  );

  static const EdgeInsets paddingRequisitos = EdgeInsets.all(12);

  static const TextStyle tituloRequisitos = TextStyle(
    fontWeight: FontWeight.bold,
    color: colorTexto,
  );

  static TextStyle requisito({required bool cumplido}) {
    return TextStyle(color: cumplido ? colorCorrecto : colorPendiente);
  }

  static ButtonStyle botonRegistrar = ElevatedButton.styleFrom(
    backgroundColor: colorPrincipal,

    padding: const EdgeInsets.symmetric(horizontal: 113, vertical: 15),

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  );

  static const TextStyle textoBoton = TextStyle(
    color: colorTextoBlanco,
    fontWeight: FontWeight.bold,
  );

  // ESPACIADOS

  static const SizedBox espacioTitulo = SizedBox(height: 20);

  static const SizedBox espacioBoton = SizedBox(height: 20);
}
