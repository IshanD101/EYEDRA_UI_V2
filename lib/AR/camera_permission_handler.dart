import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'eighth_wall_ar_view.dart';

class CameraPermissionHandler extends StatefulWidget {
  final String projectUrl;
  final String projectName;

  const CameraPermissionHandler({
    Key? key,
    required this.projectUrl,
    required this.projectName,
  }) : super(key: key);

  @override
  _CameraPermissionHandlerState createState() => _CameraPermissionHandlerState();
}

class _CameraPermissionHandlerState extends State<CameraPermissionHandler> {
  bool _isLoading = true;
  bool _permissionGranted = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Try to get cameras, which will trigger permission request
      final cameras = await availableCameras();

      // If we get here without exception, permission is granted
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No cameras found on device';
          _permissionGranted = false;
        });
      } else {
        // Select back camera
        final backCamera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        );

        // Initialize a controller to verify camera works
        final controller = CameraController(
          backCamera,
          ResolutionPreset.low,
          enableAudio: false,
        );

        try {
          await controller.initialize();
          // If camera initialized successfully, permission is granted
          setState(() {
            _permissionGranted = true;
          });
          // Dispose of controller since we only needed it to check permissions
          await controller.dispose();
        } catch (e) {
          setState(() {
            _errorMessage = 'Camera initialization failed: ${e.toString()}';
            _permissionGranted = false;
          });
        }
      }
    } on CameraException catch (e) {
      setState(() {
        if (e.code == 'CameraAccessDenied') {
          _errorMessage = 'Camera permission was denied';
        } else {
          _errorMessage = 'Camera error: ${e.description}';
        }
        _permissionGranted = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error checking camera: ${e.toString()}';
        _permissionGranted = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.projectName} - Camera Access'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.blue),
              SizedBox(height: 20),
              Text('Checking camera access...'),
            ],
          ),
        ),
      );
    }

    if (_permissionGranted) {
      // Permission granted, navigate to AR view
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EighthWallARView(
              projectUrl: widget.projectUrl,
              projectName: widget.projectName,
            ),
          ),
        );
      });
      return const SizedBox.shrink();
    }

    // Permission denied, show error and options
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Access Required'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt, size: 80, color: Colors.grey),
              const SizedBox(height: 24),
              Text(
                _errorMessage.isNotEmpty
                    ? _errorMessage
                    : 'Camera access is required for AR experiences',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Please allow camera access when prompted',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _checkCameraPermission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Try Again', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EighthWallARView(
                        projectUrl: widget.projectUrl,
                        projectName: widget.projectName,
                      ),
                    ),
                  );
                },
                child: const Text('Continue Anyway', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}