import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quizzybea_in/core/app_routes.dart';
import 'package:quizzybea_in/services/auth/auth_service.dart';
import 'package:quizzybea_in/theme/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final data = await AuthService.instance.getUserData();
    if (mounted)
      setState(() {
        _userData = data;
        _isLoading = false;
      });
  }

  Future<void> _logout() async {
    await AuthService.instance.signOut();
    if (mounted) context.go(AppRoutes.introduction);
  }

  @override
  Widget build(BuildContext context) {
    final name = _userData?['name'] ?? 'Champion';
    final email = _userData?['email'] ?? '';
    final photoUrl = _userData?['photoUrl']?.toString() ?? '';

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Profile header card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        backgroundImage:
                            photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                        child: photoUrl.isEmpty
                            ? const Icon(Icons.person_rounded,
                                size: 40, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name is String ? name : name.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email is String ? email : email.toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () => context
                            .push(AppRoutes.editProfile)
                            .then((_) => _loadUserData()),
                        icon: const Icon(Icons.edit_rounded,
                            color: Colors.white, size: 16),
                        label: const Text('Edit Profile',
                            style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Settings list
                _SectionTitle('Account'),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.lock_rounded,
                      label: 'Change Password',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Coming soon…'),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _SectionTitle('Support'),
                const SizedBox(height: 8),
                _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      label: 'About QuizzyBea',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.policy_rounded,
                      label: 'Privacy Policy',
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Logout
                OutlinedButton.icon(
                  onPressed: _logout,
                  icon:
                      const Icon(Icons.logout_rounded, color: AppColors.error),
                  label: const Text('Log Out',
                      style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'QuizzyBea v2.0.0',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textHint,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        children: children.expand((w) => [w, const Divider(height: 1)]).toList()
          ..removeLast(),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.textHint, size: 20),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
