// modelo/modelo.dart
//creacion del modelo
class Modelo {
  final int? id;
  /*final String user;
  final String pass;*/
  String user;
  String pass;
  //String rol;

  //incializacion del modelo
  //const Modelo({this.id, required this.user, required this.pass});
  Modelo({
    this.id,
    required this.user,
    required this.pass /*required this.rol*/,
  });

  // Método para actualizar los valores
  void actualizarUsuYCont(String nuevoUser, String nuevaPass) {
    user = nuevoUser;
    pass = nuevaPass;
  }

  //crecion del mapa
  Map<String, dynamic> toMap() {
    return {'id': id, 'user': user, 'pass': pass /*'rol': rol*/};
  }
}
