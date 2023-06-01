// Importamos las librerias necesarias
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:waiterbar/pages/barMenu.dart';

// Creamos la clase Scanner que extiende de StatefulWidget
class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

// Creamos la clase ScannerState que extiende de State y maneja el estado del widget Scanner
class _ScannerState extends State<Scanner> {
  // Creamos una variable global para la llave del QR
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // Método para pausar la cámara en caso de reensamblado
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
  }

  // Método para construir la interfaz del widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Center(
              child: Text("Escanea un codigo QR"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    controller?.pauseCamera();
                  },
                  child: const Text('Pausar camara', style: TextStyle(fontSize: 15)),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    controller?.resumeCamera();
                  },
                  child: const Text('Iniciar camara', style: TextStyle(fontSize: 15)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // Método para manejar el evento de creación del QR
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    // Escuchamos los eventos de escaneo
    controller.scannedDataStream.listen((scanData) async {
      final scannedResult = scanData;
      // Buscamos en la base de datos si existe un bar con el código escaneado
      final docSnapshot = await FirebaseFirestore.instance.collection('bares').doc(scannedResult.code).get();
      if (docSnapshot.exists) {
        // Si existe, pausamos la cámara y navegamos a la página de menú del bar
        controller.pauseCamera();
        final idBar = scannedResult.code;
        if (idBar != null) {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => BarMenu(result: idBar)));
        }
      } else {
        // Si no existe, pausamos la cámara y mostramos un diálogo de error
        controller.pauseCamera();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('El bar no existe'),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.resumeCamera();
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
      setState(() {
        result = scannedResult;
      });
    });
  }

  // Método para liberar los recursos del widget
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
