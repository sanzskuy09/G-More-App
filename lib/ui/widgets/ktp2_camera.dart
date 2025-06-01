import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gmore/main.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class Ktp2Camera extends StatefulWidget {
  const Ktp2Camera({super.key});

  @override
  State<Ktp2Camera> createState() => _Ktp2CameraState();
}

class _Ktp2CameraState extends State<Ktp2Camera> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  double _previewWidth = 0;
  double _previewHeight = 0;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final camera = cameras.first;
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
      final image = File(file.path);

      // final croppedImage = await cropImageAccurateToGreenBox(
      //   image,
      //   _previewWidth,
      //   _previewHeight,
      // );
      final croppedImage =
          await cropImageToFrame(image, MediaQuery.of(context).size);

      if (!mounted) return;
      Navigator.pop(context, croppedImage);

      // final cropped = await cropToGreenBox(image);
      // if (!mounted) return;
      // Navigator.pop(context, cropped); // Kirim hasil crop ke OCR
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Simpan ukuran Preview
              _previewWidth = constraints.maxWidth;
              _previewHeight = constraints.maxHeight;

              return Stack(
                children: [
                  CameraPreview(_controller!),

                  // Kotak hijau
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Container(
                  //     width: 300,
                  //     height: 180,
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.greenAccent, width: 2),
                  //     ),
                  //   ),
                  // ),
                  // Kotak hijau dengan margin top (misal 100)
                  Positioned(
                    top: 150, // ubah ini sesuai kebutuhan kamu
                    left: (MediaQuery.of(context).size.width - 300) /
                        2, // center secara horizontal
                    child: Container(
                      width: 300,
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.greenAccent, width: 2),
                      ),
                    ),
                  ),

                  // Tombol ambil gambar
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _takePicture,
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<File> cropImageAccurateToGreenBox(
    File imageFile,
    double previewW,
    double previewH,
  ) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? original = img.decodeImage(bytes);
    if (original == null) throw Exception("Failed to decode image");

    // Rotate jika perlu (biasanya portrait camera hasilnya landscape)
    if (original.width > original.height) {
      original = img.copyRotate(original, angle: 90); // rotate ke portrait
    }

    final imageW = original.width.toDouble();
    final imageH = original.height.toDouble();

    final scaleX = imageW / previewW;
    final scaleY = imageH / previewH;

    const boxW = 300.0;
    const boxH = 180.0;

    final cropX = ((previewW - boxW) / 2) * scaleX;
    final cropY = ((previewH - boxH) / 2) * scaleY;
    final cropW = boxW * scaleX;
    final cropH = boxH * scaleY;

    final cropped = img.copyCrop(
      original,
      x: cropX.round(),
      y: cropY.round(),
      width: cropW.round(),
      height: cropH.round(),
    );

    final output = File(
      '${imageFile.parent.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await output.writeAsBytes(img.encodeJpg(cropped));
    return output;
  }

  Future<File> cropImageToFrame(File imageFile, Size previewSize) async {
    final rawImage = img.decodeImage(await imageFile.readAsBytes())!;
    final imageWidth = rawImage.width;
    final imageHeight = rawImage.height;

    // debugPrint("📷 Camera Image: ${imageWidth}x$imageHeight");
    // debugPrint("📱 Preview Size: ${previewSize.width}x${previewSize.height}");

    // Ukuran dan posisi kotak hijau (harus sesuai UI!)
    const frameWidth = 300.0;
    const frameHeight = 220.0;
    const frameTop = 180.0; // ⬅️ Tambahkan posisi top sesuai margin

    final previewW = previewSize.width;
    final previewH = previewSize.height;

    // Rasio antara ukuran gambar kamera dan UI preview
    final scaleX = imageWidth / previewW;
    final scaleY = imageHeight / previewH;

    // Hitung posisi crop relatif ke gambar kamera
    final left = ((previewW - frameWidth) / 2) * scaleX;
    final top =
        frameTop * scaleY; // 🆕 Gunakan posisi `frameTop` dari atas layar

    final cropWidth = frameWidth * scaleX;
    final cropHeight = frameHeight * scaleY;

    // debugPrint("📷 left: $left");
    // debugPrint("📷 top: $top");
    // debugPrint("📷 cropWidth: $cropWidth");
    // debugPrint("📷 cropHeight: $cropHeight");

    final cropRect = img.copyCrop(
      rawImage,
      x: left.round().clamp(0, imageWidth - 1),
      y: top.round().clamp(0, imageHeight - 1),
      width: cropWidth.round().clamp(0, imageWidth - left.round()),
      height: cropHeight.round().clamp(0, imageHeight - top.round()),
    );

    // final tempPath = '${(await getTemporaryDirectory()).path}/cropped_ktp.jpg';
    final tempPath =
        '${(await getTemporaryDirectory()).path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final croppedFile = File(tempPath)
      ..writeAsBytesSync(img.encodeJpg(cropRect));

    return croppedFile;
  }
}
