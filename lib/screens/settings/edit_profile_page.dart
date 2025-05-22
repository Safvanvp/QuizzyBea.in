import 'dart:io';
import 'dart:typed_data'; // For Uint8List on web

import 'package:flutter/foundation.dart' show kIsWeb; // To detect web platform
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizzybea_in/services/auth/auth_services.dart';
import 'package:quizzybea_in/services/image/image_services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();

  File? _pickedImageFile; // For mobile/desktop
  Uint8List? _pickedImageBytes; // For web
  String? _currentProfileImageUrl;
  final imgbbService = ImgbbService();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // LOAD USER DATA ON PAGE INIT
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = AuthServices().getCurrentUser();
    if (user != null) {
      final doc = await AuthServices()
          .firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _nameController.text = data['name'] ?? '';
        setState(() {
          _currentProfileImageUrl = data['profileImageUrl'];
        });
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // Web: read bytes directly from pickedFile
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _pickedImageBytes = bytes;
        });

        try {
          // Make sure your ImgbbService has this method to upload bytes on web
          String imageUrl =
              await imgbbService.uploadImageWeb(bytes, pickedFile.name);
          final user = AuthServices().getCurrentUser();
          if (user != null) {
            await AuthServices()
                .firestore
                .collection('users')
                .doc(user.uid)
                .update({'profileImageUrl': imageUrl});
            setState(() {
              _currentProfileImageUrl = imageUrl;
              _pickedImageBytes = null; // clear after upload
            });
          }
        } catch (e) {
          print('Image upload failed (web): $e');
        }
      } else {
        // Mobile/Desktop: use File
        setState(() {
          _pickedImageFile = File(pickedFile.path);
        });

        try {
          String imageUrl = await imgbbService.uploadImage(_pickedImageFile!);
          final user = AuthServices().getCurrentUser();
          if (user != null) {
            await AuthServices()
                .firestore
                .collection('users')
                .doc(user.uid)
                .update({'profileImageUrl': imageUrl});
            setState(() {
              _currentProfileImageUrl = imageUrl;
              _pickedImageFile = null; // clear after upload
            });
          }
        } catch (e) {
          print('Image upload failed: $e');
        }
      }
    }
  }

  Future<void> _saveProfile() async {
    final user = AuthServices().getCurrentUser();
    if (user != null) {
      await AuthServices()
          .firestore
          .collection('users')
          .doc(user.uid)
          .update({'name': _nameController.text});
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _pickAndUploadImage,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.deepPurple,
                      backgroundImage: _pickedImageBytes != null
                          ? MemoryImage(_pickedImageBytes!)
                          : _pickedImageFile != null
                              ? FileImage(_pickedImageFile!)
                              : (_currentProfileImageUrl != null &&
                                      _currentProfileImageUrl!.isNotEmpty)
                                  ? NetworkImage(_currentProfileImageUrl!)
                                  : null,
                      child: (_pickedImageBytes == null &&
                              _pickedImageFile == null &&
                              (_currentProfileImageUrl == null ||
                                  _currentProfileImageUrl!.isEmpty))
                          ? const Icon(Icons.person,
                              size: 50, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tap image to change',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
