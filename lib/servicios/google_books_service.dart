import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBooksService {
  static const String baseUrl = "https://www.googleapis.com/books/v1/volumes";

  //
  static const String apiKey = "AIzaSyAge3ZzmEk8vw9S_4SIevvmHnfLnaqd6Eo";

  static Future<List<Map<String, dynamic>>> buscarLibros(
    String consulta,
  ) async {
    if (consulta.trim().isEmpty) {
      return [];
    }

    final url = Uri.parse(
      "$baseUrl"
      "?q=${Uri.encodeQueryComponent(consulta.trim())}"
      "&maxResults=10"
      "&printType=books"
      "&langRestrict=es"
      "&key=$apiKey",
    );

    print("URL GOOGLE BOOKS:");
    print(url);

    try {
      final response = await http.get(url);

      print("STATUS GOOGLE BOOKS: ${response.statusCode}");

      print("RESPUESTA GOOGLE BOOKS: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["items"] == null) {
          return [];
        }

        final List<dynamic> items = data["items"];

        return items
            .map<Map<String, dynamic>>(
              (item) => Map<String, dynamic>.from(item),
            )
            .toList();
      }

      if (response.statusCode == 400) {
        throw Exception("Solicitud incorrecta a Google Books.");
      }

      if (response.statusCode == 403) {
        throw Exception(
          "Google Books rechazó la solicitud. "
          "Revisa la API Key y que Books API esté habilitada.",
        );
      }

      if (response.statusCode == 429) {
        throw Exception(
          "Se alcanzó el límite de solicitudes de Google Books. "
          "Espera unos segundos e inténtalo nuevamente.",
        );
      }

      throw Exception(
        "Error al consultar Google Books: "
        "${response.statusCode}",
      );
    } catch (e) {
      print("Error Google Books: $e");

      rethrow;
    }
  }
}
