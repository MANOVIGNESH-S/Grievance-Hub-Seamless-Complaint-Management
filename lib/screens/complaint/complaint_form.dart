import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../models/complaint_model.dart';
import '../../models/user_model.dart';
import '../../services/complaint_service.dart';

class ComplaintFormScreen extends StatefulWidget {
  final User user;

  const ComplaintFormScreen({super.key, required this.user});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  
  // Change all references from _imageBase64List to base64 strings
  List<String> _images = []; // Now stores base64 strings
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _images.add(base64Encode(bytes))); // Updated variable name
    }
  }

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      final complaint = Complaint(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.user.email,
        title: _titleController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        location: _locationController.text,
        mobile: _mobileController.text,
        imageBase64: _images, // Updated variable name
        timestamp: DateTime.now(),
      );

      await ComplaintService().submitComplaint(complaint);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Complaint Submitted'),
          content: const Text(
              'Thank you for bringing this to our notice. '
              'We will take appropriate action soon. '
              'You will receive SMS updates on your registered mobile number.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File a Complaint')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Complaint Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Detailed Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (e.g., Sanitation, Roads)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter category' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Exact Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter location' : null,
              ),
              const SizedBox(height: 16),
              IntlPhoneField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                initialCountryCode: 'IN',
                validator: (value) => value == null ? 'Please enter mobile number' : null,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Attach Photos (optional but recommended):'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                        onPressed: () => _getImage(ImageSource.camera),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                        onPressed: () => _getImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children:
                      _images.map((image) => Chip( // Updated variable name
                        label: const Text('Image selected'),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted:
                          () => setState(() => _images.remove(image)), // Updated variable name
                      )).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitComplaint,
                style:
                  ElevatedButton.styleFrom(padding:
                    const EdgeInsets.symmetric(horizontal:
                      40, vertical:
                      15)),
                child:
                  const Text('Submit Complaint', style:
                    TextStyle(fontSize:
                      16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
