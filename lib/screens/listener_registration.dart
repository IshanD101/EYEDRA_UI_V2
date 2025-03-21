import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ListenerRegistrationPage extends StatefulWidget {
  @override
  _ListenerRegistrationPageState createState() => _ListenerRegistrationPageState();
}

class _ListenerRegistrationPageState extends State<ListenerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  File? _selectedImage;

  /// Function to Pick an Image from the Gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  /// Form Submission Logic
  void submitForm() {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      String name = nameController.text;
      String email = emailController.text;
      String bio = bioController.text;

      // Simulate sending data to backend
      print("Submitted: $name, $email, $_selectedImage, $bio");

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Application Submitted Successfully!")),
      );

      // Clear form after submission
      nameController.clear();
      emailController.clear();
      bioController.clear();
      setState(() {
        _selectedImage = null;
      });
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please upload an image!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard when tapping outside
        child: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[900]!.withOpacity(0.6),
                    Colors.grey[600]!.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Scrollable Form with Glassmorphism Effect
            SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              child: Column(
                children: [
                  // Back Button & Heading
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Listener Registration",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Form Card
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Name Field
                                _buildLabel("Full Name"),
                                _buildTextField(nameController, "Enter your full name"),
                                SizedBox(height: 15),

                                // Email Field
                                _buildLabel("Email Address"),
                                _buildTextField(emailController, "Enter your email", keyboardType: TextInputType.emailAddress),
                                SizedBox(height: 15),

                                // Image Upload Section
                                _buildLabel("Upload Your Qualification Image"),
                                _buildImagePicker(),
                                SizedBox(height: 15),

                                // Bio Field
                                _buildLabel("Short Bio"),
                                _buildTextField(bioController, "Tell us about yourself", maxLines: 3),
                                SizedBox(height: 20),

                                // Submit Button
                                Center(
                                  child: ElevatedButton(
                                    onPressed: submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[900]!.withOpacity(0.6),
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Label for input fields
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  /// Reusable TextField with consistent styling
  Widget _buildTextField(TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
        ),
      ),
      validator: (value) => value!.isEmpty ? "This field is required" : null,
    );
  }

  /// Image Picker UI
  Widget _buildImagePicker() {
    return Column(
      children: [
        if (_selectedImage != null)
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover),
            ),
          ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: pickImage,
          icon: Icon(Icons.image, color: Colors.white),
          label: Text("Select Image", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
        ),
      ],
    );
  }
}
