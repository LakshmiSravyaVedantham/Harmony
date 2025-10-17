import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';  // Uncomment for full AR; requires setup

class NatureScreen extends StatefulWidget {
  const NatureScreen({super.key});

  @override
  State<NatureScreen> createState() => _NatureScreenState();
}

class _NatureScreenState extends State<NatureScreen> {
  List<CameraDescription>? cameras;
  CameraController? controller;
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        controller = CameraController(cameras![0], ResolutionPreset.high);
        await controller!.initialize();
        if (mounted) {
          setState(() => _isInitialized = true);
        }
      } else {
        setState(() => _error = 'No cameras available');
      }
    } catch (e) {
      setState(() => _error = 'Failed to initialize camera: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nature Scan')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(_error!, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
    
    if (!_isInitialized || controller == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nature Scan')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text('Nature Scan')),
      body: Stack(
        children: [
          CameraPreview(controller!),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Scan nature for wisdom',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          // For AR: Add ARView here (see package docs for onARViewCreated to add overlays)
        ],
      ),
    );
  }
}