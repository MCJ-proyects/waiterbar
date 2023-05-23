import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:waiterbar/pages/barMenu.dart';

class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}
 
class _ScannerState extends State<Scanner> {
  
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  
 
  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.pauseCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
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
                  onPressed: () async {
                    await controller?.pauseCamera();
                  },
                  child: const Text('Pausar camara',
                      style: TextStyle(fontSize: 15)),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    await controller?.resumeCamera();
                  },
                  child: const Text('Iniciar camara',
                      style: TextStyle(fontSize: 15)),
                ),
              )
            ],
          )
        ]
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        final docSnapshot = await FirebaseFirestore.instance.collection('bares').doc(result!.code).get();
        if (result != null && docSnapshot.exists) {
          controller.pauseCamera();
          var idBar = result!.code;
          Navigator.push(context, MaterialPageRoute(builder: (context) => BarMenu(idBar)));
          
        }else{

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
                    child: const Text('Aceptar')
                  )
                ],
              );
            },
          );

        }

      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}