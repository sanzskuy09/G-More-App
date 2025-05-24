import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gmore/main.dart';
// import 'package:path_provider/path_provider.dart';

class KtpCamera extends StatefulWidget {
  const KtpCamera({super.key});

  @override
  State<KtpCamera> createState() => _KtpCameraState();
}

class _KtpCameraState extends State<KtpCamera> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final camera = cameras.first; // pakai variabel global dari main.dart
    _controller = CameraController(camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final XFile file = await _controller!.takePicture();

      // Langsung kirim file ke OCR tanpa simpan permanen
      final image = File(file.path);
      Navigator.pop(context, image); // atau langsung panggil fungsi OCR
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return Center(child: CircularProgressIndicator());

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller!);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          // Overlay Focus Frame
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 300,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 2),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _takePicture,
                child: Icon(Icons.camera_alt),
              ),
            ),
          )
        ],
      ),
    );
  }
}
