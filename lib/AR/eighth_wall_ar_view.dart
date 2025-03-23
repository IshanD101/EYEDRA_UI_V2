import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'external_ar_view.dart';

class EighthWallARView extends StatefulWidget {
  final String projectUrl;
  final String projectName;

  const EighthWallARView({
    Key? key,
    required this.projectUrl,
    required this.projectName,
  }) : super(key: key);

  @override
  _EighthWallARViewState createState() => _EighthWallARViewState();
}

class _EighthWallARViewState extends State<EighthWallARView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _cameraIssueDetected = false;
  String _errorMessage = '';
  int _loadRetries = 0;
  final int _maxRetries = 2;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    // Initialize the WebViewController with all settings
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
            setState(() {
              _isLoading = true;
              _cameraIssueDetected = false;
            });
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');

            // Advanced JavaScript injection to help with camera access
            _controller.runJavaScript('''
              // Helper to communicate with Flutter
              function sendToFlutter(message) {
                if (window.FlutterApp) {
                  window.FlutterApp.postMessage(message);
                }
                console.log("TO FLUTTER: " + message);
              }

              sendToFlutter("Page loaded: " + window.location.href);
              
              // Helper function to check camera
              function checkCameraAccess() {
                navigator.mediaDevices.getUserMedia({
                  audio: false,
                  video: {
                    facingMode: 'environment'
                  }
                }).then(function(stream) {
                  sendToFlutter("Camera accessed successfully!");
                  // Don't stop the stream as 8th Wall needs it
                }).catch(function(err) {
                  sendToFlutter("Camera access error: " + err.name + " - " + err.message);
                  // Tell Flutter about the error
                  window.FlutterApp.postMessage("CAMERA_ERROR:" + err.name);
                });
              }
              
              // Add a small delay before checking camera access
              setTimeout(function() {
                sendToFlutter("Checking camera access...");
                checkCameraAccess();
                
                // Check if 8th Wall is loaded
                if (window.XR8) {
                  sendToFlutter("8th Wall detected");
                } else {
                  sendToFlutter("8th Wall not detected");
                }
              }, 1000);
            ''');

            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web resource error: ${error.description}');
            if (_loadRetries < _maxRetries) {
              _loadRetries++;
              debugPrint('Retrying page load (${_loadRetries}/${_maxRetries})');
              _controller.reload();
            } else {
              setState(() {
                _errorMessage = 'Error loading AR experience: ${error.description}';
              });
            }
          },
        ),
      )
      ..enableZoom(false)
      ..addJavaScriptChannel(
        'FlutterApp',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('Message from 8th Wall: ${message.message}');

          // Handle camera error messages from JavaScript
          if (message.message.startsWith('CAMERA_ERROR:')) {
            setState(() {
              _cameraIssueDetected = true;
              _errorMessage = 'Camera access issue detected. Try external browser option.';
            });
          }
        },
      );

    // For Android in webview_flutter 4.2.2, we need to cast to AndroidWebViewController
    if (_controller.platform is AndroidWebViewController) {
      final AndroidWebViewController androidController =
      _controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    // Load the published 8th Wall experience directly
    _controller.loadRequest(Uri.parse(widget.projectUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.projectName} AR Experience'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _cameraIssueDetected = false;
                _errorMessage = '';
                _loadRetries = 0;
              });
              _controller.reload();
            },
          ),
          // Add button to open in external browser
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExternalARView(
                    projectUrl: widget.projectUrl,
                    projectName: widget.projectName,
                  ),
                ),
              );
            },
            tooltip: 'Open in external browser',
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),

          // Show camera issue banner if detected
          if (_cameraIssueDetected && !_isLoading)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.red.withOpacity(0.8),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Camera access issue detected',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ExternalARView(
                              projectUrl: widget.projectUrl,
                              projectName: widget.projectName,
                            ),
                          ),
                        );
                      },
                      child: const Text('Try External Browser'),
                    ),
                  ],
                ),
              ),
            ),

          // Show error message if any
          if (_errorMessage.isNotEmpty && !_isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.red.withOpacity(0.8),
                padding: const EdgeInsets.all(16),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}