import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizzybea_in/screens/settings/edit_profile_page.dart';
import 'package:quizzybea_in/services/auth/auth_services.dart';
import 'package:quizzybea_in/services/image/image_services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  String _username = 'Loading...';
  String _email = '';
  String? _profileImageUrl;

  final imgbbService = ImgbbService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
        final data = doc.data() as Map<String, dynamic>?;
        setState(() {
          _username = data?['name'] ?? 'No Name';
          _email = data?['email'] ?? user.email ?? '';
          _profileImageUrl = data?['profileImageUrl'];
        });
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();

    if (kIsWeb) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        try {
          String imageUrl =
              await imgbbService.uploadImageWeb(bytes, pickedFile.name);
          // update UI with imageUrl ...
        } catch (e) {
          print('Image upload failed: $e');
        }
      }
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        try {
          String imageUrl = await imgbbService.uploadImage(file);
          // update UI with imageUrl ...
        } catch (e) {
          print('Image upload failed: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: _pickAndUploadImage,
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.deepPurple,
                          backgroundImage: _profileImageUrl != null &&
                                  _profileImageUrl!.isNotEmpty
                              ? NetworkImage(_profileImageUrl!)
                              : null,
                          child: _profileImageUrl == null ||
                                  _profileImageUrl!.isEmpty
                              ? const Icon(Icons.person,
                                  size: 30, color: Colors.white)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfilePage()),
                            ).then((_) => _loadUserData());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_username,
                            style: textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(_email,
                            style: textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfilePage()),
                      ).then((_) => _loadUserData());
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Preferences
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Dark Mode"),
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() => isDarkMode = value);
                    // TODO: integrate dark mode logic
                  },
                  secondary: const Icon(Icons.dark_mode),
                ),
                const Divider(height: 0),
                SwitchListTile(
                  title: const Text("Enable Notifications"),
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() => notificationsEnabled = value);
                    // TODO: integrate notification logic
                  },
                  secondary: const Icon(Icons.notifications),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Account Actions
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  onTap: () {
                    // TODO: Navigate to Change Password screen
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title:
                      const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    await AuthServices().signOut();
                    // TODO: Navigate to login screen
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
