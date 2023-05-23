//create basic bar menu
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BarMenu extends StatefulWidget {
  
  String? result;

  BarMenu(this.result); 
   
  @override
  _BarMenuState createState() => _BarMenuState();

}

class _BarMenuState extends State<BarMenu> {

  CollectionReference bares = FirebaseFirestore.instance.collection('bares');

  int cuenta = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bar Menu"),
      ),
       body: FutureBuilder(
        future: bares.doc(widget.result).get(),
        builder: (context, snapshot) {
          
          var dataBares = snapshot.data!.data() as Map<String, dynamic>;
          print(dataBares);
          var tapas = dataBares['tapas'];
          var bebidas = dataBares['bebidas'];
          var postres = dataBares['postres'];

          return Column(
            children: [
              Text(dataBares['nombre'],
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 45,
                    ),
              ),
              Text('Tapas:',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 25,
                    ),
              ),
              ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: tapas.length ?? 0,
              itemBuilder: (context, index) {
                if(tapas.length != 0){
                  return Card(
                    child:
                      ListTile(
                        title: Text(tapas[index]['nombre'] + " | " + tapas[index]['precio'].toString() + "€",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )
                        ),
                        subtitle: Text(tapas[index]['descripcion']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              cuenta = (cuenta + tapas[index]['precio']).toInt();
                            });
                          },
                          child: Text('Añadir'),
                        ),
                      ),
                  );
                } else {
                  return Card(
                    child:
                      ListTile(
                        title: Text("No hay tapas")
                      ),
                  );
                }
              }),
              Text('Bebidas:',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 25,
                    ),
              ),
              ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: bebidas.length ?? 0,
              itemBuilder: (context, index) {
                if (bebidas.length != 0) {
                  return Card(
                    child:
                      ListTile(
                        title: Text(bebidas[index]['nombre'] + " | " + bebidas[index]['precio'].toString() + "€",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )
                        ),
                        subtitle: Text(bebidas[index]['descripcion']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              cuenta = (cuenta + bebidas[index]['precio']).toInt();
                            });
                          },
                          child: Text('Añadir'),
                        ),
                      ),
                  );
                } else {
                  return Card(
                    child:
                      ListTile(
                        title: Text("No hay bebidas")
                      ),
                  );
                }
              }),
              Text('Postres:',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 25,
                    ),
              ),
              ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: postres.length,
              itemBuilder: (context, index) {
                if (postres.length != 0) {
                  return Card(
                    child:
                      ListTile(
                        title: Text(postres[index]['nombre'] + " | " + postres[index]['precio'].toString() + "€",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )
                        ),
                        subtitle: Text(postres[index]['descripcion']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              cuenta = (cuenta + postres[index]['precio']).toInt();
                            });
                          },
                          child: Text('Añadir'),
                        ),
                      ),
                  );
                } else {
                  return Card(
                    child:
                      ListTile(
                        title: Text("No hay postres")
                      ),
                  );
                }
              }),
              Text('Cuenta: $cuenta€',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 25,
                    ),
              ),
            ],
          );
        }
      ),
    );
  }
}