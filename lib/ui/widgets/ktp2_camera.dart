import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gmore/main.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class Ktp2Camera extends StatefulWidget {
  const Ktp2Camera({super.key});

  @override
  State<Ktp2Camera> createState() => _Ktp2CameraState();
}

class _Ktp2CameraState extends State<Ktp2Camera> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  // double _previewWidth = 0;
  // double _previewHeight = 0;

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

      final croppedImage =
          await cropImageToFrame(image, MediaQuery.of(context).size);

      if (!mounted) return;
      Navigator.pop(context, croppedImage);
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  Future<void> _pickFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      final croppedImage = await cropImageToFrame(
        image,
        MediaQuery.of(context).size,
      );
      if (!mounted) return;
      Navigator.pop(context, croppedImage);
    }
  }

  Future<File?> _pickFromGalleryAndCrop() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 5, ratioY: 3), // misal 300x180
      // cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop KTP',
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop KTP',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    // return cropped != null ? File(cropped.path) : null;
    if (cropped == null) return null;

    // ✅ Resize hasil crop ke resolusi tinggi
    final raw = img.decodeImage(await File(cropped.path).readAsBytes());
    if (raw == null) return null;

    final resized = img.copyResize(
      raw,
      width: 1000, // bisa disesuaikan, 1000–1500 px cukup untuk OCR
      interpolation: img.Interpolation.average,
    );

    final tempDir = await getTemporaryDirectory();
    final highResFile = File(
        '${tempDir.path}/high_res_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await highResFile.writeAsBytes(img.encodeJpg(resized, quality: 95));

    return highResFile;
  }

  Future<File> cropImageToFrame(File imageFile, Size previewSize) async {
    final rawImage = img.decodeImage(await imageFile.readAsBytes())!;
    final imageWidth = rawImage.width;
    final imageHeight = rawImage.height;

    // debugPrint("📷 Camera Image: ${imageWidth}x$imageHeight");
    // debugPrint("📱 Preview Size: ${previewSize.width}x${previewSize.height}");

    // Ukuran dan posisi kotak hijau (harus sesuai UI!)
    const frameWidth = 300.0;
    const frameHeight = 200.0;
    const frameTop = 200.0; // ⬅️ Tambahkan posisi top sesuai margin

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

  // @override
  // Widget build(BuildContext context) {
  //   if (_controller == null) {
  //     return const Center(child: CircularProgressIndicator());
  //   }

  //   return Scaffold(
  //     body: FutureBuilder(
  //       future: _initializeControllerFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState != ConnectionState.done) {
  //           return const Center(child: CircularProgressIndicator());
  //         }

  //         return LayoutBuilder(
  //           builder: (context, constraints) {
  //             // Simpan ukuran Preview
  //             // _previewWidth = constraints.maxWidth;
  //             // _previewHeight = constraints.maxHeight;

  //             return Stack(
  //               children: [
  //                 CameraPreview(_controller!),

  //                 // Kotak hijau
  //                 // Align(
  //                 //   alignment: Alignment.center,
  //                 //   child: Container(
  //                 //     width: 300,
  //                 //     height: 180,
  //                 //     decoration: BoxDecoration(
  //                 //       border: Border.all(color: Colors.greenAccent, width: 2),
  //                 //     ),
  //                 //   ),
  //                 // ),
  //                 // Kotak hijau dengan margin top (misal 100)
  //                 Positioned(
  //                   top: 150, // ubah ini sesuai kebutuhan kamu
  //                   left: (MediaQuery.of(context).size.width - 300) /
  //                       2, // center secara horizontal
  //                   child: Container(
  //                     width: 300,
  //                     height: 180,
  //                     decoration: BoxDecoration(
  //                       border: Border.all(color: Colors.greenAccent, width: 2),
  //                     ),
  //                   ),
  //                 ),

  //                 // Tombol ambil gambar
  //                 Positioned(
  //                   bottom: 50,
  //                   left: 0,
  //                   right: 0,
  //                   child: Center(
  //                     child: ElevatedButton(
  //                       onPressed: _takePicture,
  //                       child: const Icon(Icons.camera_alt),
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned(
  //                   bottom: 50,
  //                   left: 0,
  //                   right: 0,
  //                   child: Column(
  //                     children: [
  //                       ElevatedButton(
  //                         onPressed: _takePicture,
  //                         child: const Icon(Icons.camera_alt),
  //                       ),
  //                       const SizedBox(height: 16),
  //                       ElevatedButton.icon(
  //                         onPressed: _pickFromGallery,
  //                         icon: const Icon(Icons.photo_library),
  //                         label: const Text("Pilih dari Galeri"),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

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

          final previewSize = _controller!.value.previewSize!;
          final cameraAspectRatio = previewSize.height / previewSize.width;

          return Stack(
            children: [
              // CameraPreview dengan AspectRatio dan FittedBox agar proporsional
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: previewSize.height,
                    height: previewSize.width,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),

              // Kotak hijau diposisikan secara presisi
              Positioned(
                top: 200,
                left: (MediaQuery.of(context).size.width - 300) / 2,
                child: Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.greenAccent, width: 2),
                  ),
                ),
              ),

              // Tombol ambil foto
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: _takePicture,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Ambil Foto"),
                  ),
                ),
              ),

              // Tombol ambil dari galeri (jika kamu sudah tambahkan fungsinya)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton.icon(
                    // onPressed: _pickFromGallery,
                    onPressed: () async {
                      final croppedFile = await _pickFromGalleryAndCrop();
                      if (croppedFile != null && mounted) {
                        Navigator.pop(context, croppedFile);
                      }
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("Pilih dari Galeri"),
                  ),
                ),
              )
            ],
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
}
