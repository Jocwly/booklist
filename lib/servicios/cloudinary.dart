import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const cloudName = "dsjyywplr";

  static const uploadPreset = "booklist";

  static Future<String?> subirImagen(File imagen) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", url);

    request.fields["upload_preset"] = uploadPreset;

    request.files.add(await http.MultipartFile.fromPath("file", imagen.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final respuesta = await response.stream.bytesToString();

      final data = jsonDecode(respuesta);

      return data["secure_url"];
    }

    return null;
  }
}
