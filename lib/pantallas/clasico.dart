import 'package:flutter/material.dart';

class clasico extends StatefulWidget {
  const clasico({super.key});

  @override
  State<clasico> createState() => _clasicoState();
}

class _clasicoState extends State<clasico> {
  void _mostrarResena(BuildContext context, String descripcion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reseña del libro"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(descripcion),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    () => Navigator.of(context).pop(), // Cierra la ventana
                child: Text("Cerrar"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "CLÁSICOS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "Buscar un libro...",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    child: Icon(Icons.search, color: Colors.white),
                    backgroundColor: Color.fromARGB(255, 147, 60, 78),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 147, 60, 78),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 136, 42, 62),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              // Primera fila
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'En esta historia, Alicia entra en un espejo mágico y se encuentra en un mundo alternativo donde todo funciona al revés. A lo largo de su aventura, Alicia interactúa con personajes como el Rey y la Reina Roja, el Caballo Blanco, y el Gato de Cheshire, mientras se enfrenta a situaciones absurdas y desafiantes que la hacen cuestionar la lógica y el sentido común. El libro explora temas de identidad, crecimiento y la percepción de la realidad, todo dentro del estilo único y surrealista de Carroll.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://th.bing.com/th/id/OIP.p2Qht0iMCaSgQb3wbzHukAHaKN?rs=1&pid=ImgDetMain",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Don Quijote de la...",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'La historia comienza cuando un hombre respetable, Terry Maitland, es arrestado por el brutal asesinato de un niño en su ciudad. Sin embargo, a medida que la investigación avanza, surgen pruebas que demuestran que Terry no solo podría ser inocente, sino que también fue víctima de un extraño y macabro suceso. El caso se complica cuando la policía descubre que el crimen tiene un vínculo con algo más siniestro y sobrenatural, desatando una serie de eventos aterradores. La obra explora temas como la justicia, la culpa y lo inexplicable, mientras King teje una atmósfera tensa y envolvente.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1669512309i/63849929.jpg",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Moby Dick",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'Un implacable asesino en serie.Una pareja de investigadores fuera de lo común. Un caso extremo: códigos, símbolos y trampas numéricas en una desafiante cuenta atrás. En un parque de atracciones a las afueras de Estocolmo aparece el cuerpo de una joven asesinada de forma macabra: atravesada por múltiples espadas dentro de una caja.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://th.bing.com/th/id/R.093e2fd491368a0cc442011a748df95e?rik=sa4naKSVEpsC5Q&pid=ImgRaw&r=0",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Frankenstein",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            ' La historia sigue a Christopher, un niño de 7 años que se muda con su madre a un vecindario suburbano. Pronto, Christopher empieza a interactuar con un amigo imaginario llamado "El Hombre del Saco", quien tiene el poder de realizar milagros y también de ser una presencia aterradora. Cuando una serie de eventos extraños comienza a ocurrir en el vecindario, el niño se ve atrapado entre el deseo de proteger a su madre y la creciente oscuridad que rodea a su amigo imaginario.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://th.bing.com/th/id/R.3024817bfee5a6fe57c4807448102b26?rik=b73haAKloi2cWA&riu=http%3a%2f%2fdata.ecasals.net%2fimg%2f04%2fg%2f9788498253351_04_g.jpg&ehk=c9ZWZpuULIaPAcxaRD8CGuRi%2falHFI5ztZU28kTEKe8%3d&risl=&pid=ImgRaw&r=0",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "La Odisea",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'La historia sigue a un pequeño príncipe que viaja desde su lejano asteroide a la Tierra y se encuentra con un aviador perdido en el desierto. A través de sus conversaciones, el Principito comparte sus experiencias con diversos personajes que conoce en su viaje, como el rey, el hombre vanidoso, el farero y la rosa que dejó atrás en su planeta.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://proassetspdlcom.cdnstatics2.com/usuaris/libros/thumbs/2cc903f2-c591-4598-b9b2-9b05c6d5b484/d_360_620/portada_romeo-y-julieta_william-shakespeare_201412151345.webp",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Romeo y Julieta",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'La azarosa historia de una esclava en el Santo Domingo del siglo XVIII que logrará librarse de los estigmas que la sociedad le ha impuesto para conseguir la libertad.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://proassetspdlcom.cdnstatics2.com/usuaris/libros/thumbs/5606486d-e80c-4c48-bd53-b328d079e843/d_360_620/portada_las-mil-y-una-noches_anonimo_201706291301.webp",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Las mil y una noches",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'Narra la vida de cuatro hermanas en tiempos de la Guerra Civil Americana. "Mujercitas" explora temas como el crecimiento personal, los ideales familiares, la lucha por la autonomía femenina y la importancia de los lazos familiares, todo mientras refleja las tensiones sociales y económicas de la época',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://lh4.googleusercontent.com/proxy/ITJ_D5OYvko3HIFuFPPv2_MfouwEfyu5fYBLVYIY-EOXOKRwCy6yt3QkuFvrDGVtwTnmR-LSLw50E4NZADAt498hr-nPNg=w1200-h630-p-k-no-nu",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Mujercitas",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'Lily Bloom, es una joven que, tras una difícil infancia marcada por la violencia, se muda a Boston para comenzar una nueva vida. Allí, se enamora de Ryle Kincaid, un neurocirujano exitoso, pero a medida que su relación avanza, Lily descubre que Ryle guarda oscuros secretos y tiene un lado más oscuro que amenaza su bienestar emocional y físico.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://th.bing.com/th/id/OIP.rVCEEI0KvromX4U9hDdnVwHaLJ?rs=1&pid=ImgDetMain",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Orgullo y Prejuicio",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'Alice nunca ha visto el mundo. Su vida está resumida entre las cuatro paredes y veinte personas que ve a diario. Su cena es a las nueve en punto, su sueño dura exactamente ocho horas, jamás tiene una sola arruga en la ropa, parpadea 86400 veces al día, respira 30000 veces al día, solo habla cuando le preguntan, jamás ha ido al exterior, jamás ha levantado la voz y, lo más importante, jamás se ha preguntado qué pasaría si todo cambiara. Pero, ¿y si eso ocurriera? En un mundo donde la libertad está controlada, ¿hasta dónde serías capaz de llegar para recuperarla? ¿Hasta dónde serías capaz de llegar para sobrevivir?',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://assets-global.website-files.com/6034d7d1f3e0f52c50b2adee/625454187128ea32cdb140e8_6034d7d1f3e0f5072bb2b1ca_Cumbres-borrascosas-emily-bronte-editorial-alma.jpeg",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Cumbres borrascosas",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'En una antigua iglesia ha aparecido una joven con el cuello cercenado y el cuerpo rodeado de hermosas flores. Un retorcido ritual de violencia, belleza y castidad que el asesino cumple cada invierno con escalofriante puntualidad.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://assets-global.website-files.com/6034d7d1f3e0f52c50b2adee/6254541d8ae4df16d4e69bc8_6034d7d1f3e0f54529b2b1a1_Crimen-y-castigo-fiodor-dostoyevski-editorial-alma.jpeg",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Crimen y Castigo",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'Entras en la habitación de tu hijo. El caos habitual. Recoges restos de comida, ropa desperdigada, abres el armario para ponerlo todo en su sitio... y lo ves. Y entonces te das cuenta de una horrible verdad: tu propio hijo puede ser un peligro. Stephanie Maddox dirige el departamento de Asuntos Internos del FBI, donde supervisa que todos sus compañeros cumplan las reglas. Llegar hasta aquí le ha costado casi dos décadas de trabajo duro y sacrificios personales, como la relación con su hijo adolescente, Zachary, que espera con nervios su admisión a la universidad. Como madre soltera, Steph se perdió muchos eventos escolares, cumpleaños y vacaciones, pero la verdad es que movería cielo y la tierra por él, incluso lo protegería de un terrible secreto de su propio pasado. Nunca se pudo imaginar que Zachary guardaría sus propios secretos.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://th.bing.com/th/id/OIP.WvYTSR7DmuHf7m-KsI7nygHaMD?rs=1&pid=ImgDetMain",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "La gran mentira",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'Cuando la policía encuentra dos esqueletos abrazados en un río de Manhattan, Margo Green, experta en antropología, se une a la investigación debido a su experiencia previa enfrentando una bestia en el museo. Los esqueletos presentan señales de violencia y anormalidades que apuntan al despertar de una pesadilla olvidada. A medida que surgen más crímenes, Margo, junto con un teniente de policía, un agente del FBI y un científico, investiga el origen de los asesinatos. Su búsqueda los lleva a un laberinto subterráneo en Manhattan, donde descubrirán el oscuro secreto de la Bestia del Museo.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://i1.wp.com/3.bp.blogspot.com/-JxPG5NSNbkw/WHlBZ6aQgCI/AAAAAAAAUDQ/OR8mql15cHYCJREAsiLTdDrqbGSnYACBgCLcB/s1600/El%2Brelicario%2B-%2BDouglas%2BPreston-FREELIBROS.jpg?ssl=1",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "El relicario",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'novela de suspenso psicológico que cuenta la historia de un niño que vive con su familia en una casa aislada, sometido a un ambiente oscuro y opresivo. Su padre, una figura aterradora, y su madre, distante, crean un hogar marcado por el miedo y el misterio. La historia gira en torno a secretos familiares, tragedias pasadas y la lucha del niño por entender su realidad. Con un estilo inquietante y lleno de giros, la novela explora temas como la manipulación, el abuso y la búsqueda de la verdad, mientras el protagonista se enfrenta a un entorno cada vez más surrealista y peligroso.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://th.bing.com/th/id/OIP.S5IXTzB9KB4istOEHACCmAHaLI?rs=1&pid=ImgDetMain",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "El brillo de las...",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'El principito es una obra filosófica que explora la naturaleza humana a través de los ojos de un niño.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://tse4.mm.bing.net/th/id/OIP.TilTko5LHX5kYODGuYDinQAAAA?r=0&rs=1&pid=ImgDetMain&o=7&rm=3",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "El oro del cazador",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'El principito es una obra filosófica que explora la naturaleza humana a través de los ojos de un niño.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://th.bing.com/th/id/R.108251392bb0462d488b96051470d6b1?rik=tz7U4m1Dp9q%2bkA&riu=http%3a%2f%2f4.bp.blogspot.com%2f-Eyy45gFZml8%2fTWb_nhmSzzI%2fAAAAAAAAEnw%2fgiWmloRbds4%2fs1600%2fhornos%2bhitler.jpg&ehk=YJMN%2fNvb%2bc%2fVYsbY%2bsyzPn2D4UyQRwgo6mh2kBgOlQ4%3d&risl=&pid=ImgRaw&r=0",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Los hornos de Hitler",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => _mostrarResena(
                            context,
                            'El principito es una obra filosófica que explora la naturaleza humana a través de los ojos de un niño.',
                          ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Image.network(
                              "https://lh6.googleusercontent.com/4RqbR0GowRRCQuSAQ4g68htEB0op4QnrFFJSKpspTfgkslEXtGO4WmB9wEmMt-zcniejBaXRUzDHzoOqiGDKnf2s4LQig6cA9YI0yRX8CRbpTwEhUROq6rqJe882JmFFclRSt_C-",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "El bosque negro",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
