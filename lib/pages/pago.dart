// Importamos las librerias necesarias
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  // El método createState() crea un nuevo estado asociado a esta página.
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

// La clase PaymentPage también tiene un estado asociado llamado _PaymentPageState.
class _PaymentPageState extends State<PaymentPage> {
  // Se crea una clave global (_formKey) para identificar el formulario. Esto se utiliza para validar y guardar los datos del formulario.
  final _formKey = GlobalKey<FormState>();

  // Se define un widget de mensaje (SnackBar) que se muestra cuando se realiza el pago correctamente.
  final snackBar = const SnackBar(
    content: Text('¡Pago realizado correctamente!'),
  );

  // El método build devuelve un Scaffold que define la estructura básica de la página, incluyendo una barra de navegación (AppBar) y un cuerpo (body).
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago del pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Se define un campo de texto para el número de tarjeta.
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Numero de tarjeta',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduzca su numero de tarjeta.';
                  }
                  return null;
                },
                onSaved: (value) {
                  // TODO: Guardar el valor del campo de texto.
                },
              ),
              const SizedBox.shrink(),
              // Se define un campo de texto para el número de serie.
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Numero de serie (3 numeros)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduzca su numero de serie.';
                  }
                  if (value.length != 3) {
                    return 'El numero de serie tiene que ser 3 numeros';
                  }
                  return null;
                },
                onSaved: (value) {
                  // TODO: Guardar el valor del campo de texto.
                },
              ),
              const SizedBox.shrink(),
              // Se define un botón que envía los datos del formulario a través de un proceso de pago.
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // TODO: Crear proceso de pago
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Center(child: Text('Enviar')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
