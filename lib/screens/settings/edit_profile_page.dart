import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizzybea_in/services/auth/auth_service.dart';
import 'package:quizzybea_in/services/image/image_service.dart';
import 'package:quizzybea_in/theme/app_colors.dart';
import 'package:quizzybea_in/widgets/app_button.dart';
import 'package:quizzybea_in/widgets/app_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _currentPhotoUrl;
  File? _pickedFile;
  Uint8List? _pickedBytes;
  bool _isUploading = false;
  bool _isSaving = false;

  final _imageService = ImageService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final data = await AuthService.instance.getUserData();
    if (mounted && data != null) {
      setState(() {
        _nameController.text = data['name'] ?? '';
        _currentPhotoUrl = data['photoUrl'];
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _isUploading = true);
    try {
      String url;
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() => _pickedBytes = bytes);
        url = await _imageService.uploadBytes(bytes, picked.name);
      } else {
        setState(() => _pickedFile = File(picked.path));
        url = await _imageService.uploadFile(File(picked.path));
      }
      await AuthService.instance.updateUserData({'photoUrl': url});
      setState(() {
        _currentPhotoUrl = url;
        _pickedFile = null;
        _pickedBytes = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await AuthService.instance
          .updateUserData({'name': _nameController.text.trim()});
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Profile saved!')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to save: $e'),
              backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  ImageProvider? get _currentImage {
    if (_pickedBytes != null) return MemoryImage(_pickedBytes!);
    if (_pickedFile != null) return FileImage(_pickedFile!);
    if (_currentPhotoUrl != null && _currentPhotoUrl!.isNotEmpty) {
      return NetworkImage(_currentPhotoUrl!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Avatar picker
                GestureDetector(
                  onTap: _isUploading ? null : _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        backgroundImage: _currentImage,
                        child: _currentImage == null
                            ? const Icon(Icons.person_rounded,
                                size: 56, color: AppColors.primary)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: _isUploading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.camera_alt_rounded,
                                  size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to change photo',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textHint),
                ),
                const SizedBox(height: 36),
                AppTextField(
                  controller: _nameController,
                  hint: 'Full name',
                  icon: Icons.person_rounded,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Save Changes',
                  isLoading: _isSaving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
