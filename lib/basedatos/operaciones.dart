/*
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modelo/modelo.dart';
import '../modelo/libro.dart';

class Operaciones {
  static Future<void> eliminarBaseDatos() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dbbooklist.db');
    await deleteDatabase(path);
    print('Base de datos eliminada.');
  }

  //metodo o funcion para abrir la BD
  static Future<Database> abrirBD() async {
    return openDatabase(
      join(await getDatabasesPath(), 'dbbooklist.db'),

      //creat tabla USUARIOS
      /*onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS usuarios(id INTEGER PRIMARY KEY, user TEXT, pass TEXT)',
        );
      },*/
      onCreate: (db, version) async {
        await db.execute('''
    CREATE TABLE usuarios(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user TEXT,
      pass TEXT
    )
    ''');

        await db.execute('''
    CREATE TABLE libros(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      portada TEXT,
      titulo TEXT,
      autor TEXT,
      genero TEXT,
      resena TEXT
    )
    ''');
        await db.execute('''
CREATE TABLE favoritos(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  portada TEXT,
  titulo TEXT,
  autor TEXT,
  genero TEXT,
  resena TEXT
)
''');
      },
      version: 1,
    );
  }

  //crear metodo insertar
  static Future<void> insertar(Modelo modelo) async {
    //abrir  la bd
    Database database = await abrirBD();
    database.insert('usuarios', modelo.toMap());
  }

  //crear metodo eliminar
  static Future<void> eliminar(Modelo modelo) async {
    //abrir BD
    Database database = await abrirBD();

    database.delete('usuarios', where: 'id=?', whereArgs: [modelo.id]);
  }

  //ACTUALIZAR
  static Future<void> actualizar(Modelo modelo) async {
    //abrir BD
    Database database = await abrirBD();

    database.update(
      'usuarios',
      modelo.toMap(),
      where: 'id=?',
      whereArgs: [modelo.id],
    );
  }

  //LISTAR USUARIOS
  static Future<List<Modelo>> listar() async {
    //abrir  la bd
    Database database = await abrirBD();

    //listar por medio del mapa
    final List<Map<String, dynamic>> listarMapa = await database.query(
      'usuarios',
    );
    for (var n in listarMapa) {
      print("__" + n['user']);
      print("__" + n['pass']);
      //print("__" + n['rol']);
    }
    return List.generate(
      listarMapa.length,
      (index) => Modelo(
        id: listarMapa[index]['id'],
        user: listarMapa[index]['user'],
        pass: listarMapa[index]['pass'],
        //rol: listarMapa[index]['rol'],
      ),
    );
  }

  // INSERTAR LIBRO
  static Future<void> insertarLibro(Libro libro) async {
    Database database = await abrirBD();

    await database.insert('libros', libro.toMap());
  }

  // LISTAR LIBROS
  static Future<List<Libro>> listarLibros() async {
    Database database = await abrirBD();

    final List<Map<String, dynamic>> libros = await database.query('libros');

    return List.generate(libros.length, (index) {
      return Libro.fromMap(libros[index]);
    });
  }

  // INSERTAR FAVORITO

  static Future<void> insertarFavorito(Libro libro) async {
    Database database = await abrirBD();

    await database.insert('favoritos', libro.toMap());
  }

  // LISTAR FAVORITOS

  static Future<List<Libro>> listarFavoritos() async {
    Database database = await abrirBD();

    final List<Map<String, dynamic>> favoritos = await database.query(
      'favoritos',
    );

    return List.generate(favoritos.length, (index) {
      return Libro.fromMap(favoritos[index]);
    });
  }
}
*/
