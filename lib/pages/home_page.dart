import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/header.dart';
import '../scanner.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final db = FirebaseFirestore.instance;

  //Cerrar sesión
  void sungUserOut() {
    FirebaseAuth.instance.signOut();
  }

  

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    var idUser = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        actions: [
          FutureBuilder(
            future: users.doc(idUser).get(),
            builder: (context, snapshot) {
              var usuario = snapshot.data!.data() as Map<String, dynamic>;
              return Center(
                child: Text("${usuario['nombre']}")
              );
            }
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                "https://gravatar.com/avatar/00630ebc6bc398bd100d7ca15827de3a?s=400&d=robohash&r=x",
              ),
            ),
          ),
          IconButton(
            onPressed: sungUserOut, 
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: FutureBuilder(
        future: users.doc(idUser).get(),
        builder: (context, snapshot) {
        var usuario = snapshot.data!.data() as Map<String, dynamic>;
        return Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),              
                child: Header(text:"Buenas ${usuario['nombre']}", subtitle: "¿Qué desea hacer?"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: 
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Scanner()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              child: const Icon(
                                Icons.qr_code_scanner_rounded,
                                color: Colors.white,
                                size: 100,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Scanner()),
                                );
                              }
                            ),
                            Text("Escanear codigo QR",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                  ),
                            )
                          ],
                        ),
                      ),
                )
              ),
            ],
          ),
        );
        },
      ),
    );
  }

}