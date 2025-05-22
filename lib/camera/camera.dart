import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantapp/constants.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  int _selectedCameraIdx = 0;
  FlashMode _flashMode = FlashMode.off;
  double _zoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  bool _isZoomSupported = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    await _setupCamera(_selectedCameraIdx);
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    final controller = CameraController(
      _cameras[cameraIndex],
      ResolutionPreset.max,
      enableAudio: false,
    );

    await controller.initialize();
    _minZoom = await controller.getMinZoomLevel();
    _maxZoom = await controller.getMaxZoomLevel();
    _isZoomSupported = _maxZoom > _minZoom;
    _zoom = _minZoom;
    await controller.setZoomLevel(_zoom);
    await controller.setFlashMode(_flashMode);

    if (mounted) {
      setState(() {
        _controller = controller;
        _selectedCameraIdx = cameraIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
