# Waiterbar, Carta al momento

WaiterBar – Carta al momento es una aplicación enfocada para bares y restaurantes, este “agilizará” el proceso de pedido de comandas de los clientes en todos los bares / restaurantes en el que esté el servicio contratado pidiendolo todo a traves de la app.
## Herramientas necesarias para la implementación del proyecto

- Visual Studio Code / Android Studio
- (Para VSC) La extensión "Dart" y "Flutter"
- [Flutter SDK](https://docs.flutter.dev/get-started/install/windows)
## Pasos para montar el proyecto
1. Instalar el SDK de Flutter [aquí](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.10.4-stable.zip)
2. Extraer el archivo zip y colocar el flutter en la localizacion deseada para la instalacion del SDK (por ejemplo, C:\src\flutter)
3. En esa misma dirección, ejecutar el comando `flutter doctor` para comprbar que todo esta correctamente instalado, en caso contrario seguir las instrucciones que se indican en la respuesta de este
4. Descargar el .zip del proyecto y extraer la carpeta
5. Si se ejecuta en Android Studio:
   1. Habilitar la aceleracion de MV en tu ordenador
   2. Iniciar Android Studio, click en el icono de "Device Manager" y seleccionar "Create Device" en la opcion "Virtual"
   3. Seleccionar una definición de dispositivo y presiona "next"
   4. Selecciona una imagen del sistema de la version de android que quieres emular (recomendado version 12) y selecciona "next"
   5. en "Emulated Performance", selecciona "Hardware - GLES 2.0" para habilitar la aceleración de hardware
   6. Abrir una consola de comandos con permisos de administrador e introducir el siguiente comando: `flutter doctor --android-licenses`
   7. Al abrir el proyecto en Android Studio, arrastrar la carpeta del proyecto al menu de "proyects" o darle a "open" y abrir la carpeta del proyecto
   8. En "Preferences -> Languages & Frameworks -> Flutter -> Flutter SDK path" añadir la carpeta donde esta guardado el SDK
   9. Ir al archivo "pubspec.yaml" y d
6. Si se ejecuta en Visual Studio Code:
   1. Ir al panel de "extensiones" y descargar las extensiones "Dart" y "Flutter"
   2. Pulsar F1 y escribir "Flutter: Run Flutter Doctor"
   3. Comprobar que todo esta correctamente, en caso contrario, realizar lo que el comando le pide para arreglar los errores
   4. Vamos a file -> open folder y abrimos la carpeta del proyecto
   5. Para abrir el emulador de android, nos vamos a la parte inferior derecha, clicamos donde pone "Windows (windows-x64)" y seleccionamos "Start (nombre del emulador)" EN MODO COLD BOOT
   6. nos vamos al archivo "main.dart" y le damos al boton de iniciar, justo en la parte superior derecha
