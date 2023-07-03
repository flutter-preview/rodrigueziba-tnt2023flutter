import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key});
   @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImagePage> {
  late CameraController _controller;
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    await _controller.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(242, 248, 255, 1),
                  borderRadius: BorderRadius.circular(50)),
              child: const Icon(Icons.android,
                  size: 24, color: Color.fromRGBO(0, 112, 240, 1)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Canal de imagen",
                    style: TextStyle(
                        color: Color.fromRGBO(32, 35, 37, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                Row(
                  children: [
                    Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(125, 222, 134, 1),
                            borderRadius: BorderRadius.circular(50))),
                    const Text(
                      "Siempre activo",
                      style: TextStyle(
                          color: Color.fromRGBO(114, 119, 122, 1),
                          fontSize: 14),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: const Color.fromRGBO(254, 254, 254, 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  // Aquí puedes agregar cualquier contenido adicional dentro del ListView
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos horizontalmente
                  children: [
                    Container(
  margin: const EdgeInsets.only(top: 16),
  alignment: Alignment.center,
  child: _selectedImage != null
      ? Image.file(File(_selectedImage!))
      : Text('No se ha seleccionado ninguna imagen.'),
),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _openCamera(context); // Llama a la función para abrir la cámara
                        },
                        icon: Icon(Icons.camera),
                        label: Text(""),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _openGallery(context); // Llama a la función para abrir la galería de imágenes
                        },
                        icon: Icon(Icons.image),
                        label: Text(""),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Future<void> _openCamera(BuildContext context) async {
  final cameras = await availableCameras();
  final camera = cameras.first;

  final imagePath = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CameraScreen(camera: camera),
    ),
  );

  if (imagePath != null) {
    setState(() {
      _selectedImage = imagePath;
    });
  }
}

 Future<void> _openGallery(BuildContext context) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      _selectedImage = pickedFile.path;
    });
  }
}
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({required this.camera});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: CameraPreview(_controller),
    );
  }
}
