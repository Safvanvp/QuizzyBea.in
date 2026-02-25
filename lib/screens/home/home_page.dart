import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quizzybea_in/assets/images.dart';
import 'package:quizzybea_in/core/app_routes.dart';
import 'package:quizzybea_in/models/user/user_level.dart';
import 'package:quizzybea_in/services/auth/auth_service.dart';
import 'package:quizzybea_in/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _userData;

  static const _categories = [
    {'title': 'General Knowledge', 'icon': Icons.lightbulb_rounded, 'bg': 0},
    {'title': 'Music & Poetry', 'icon': Icons.music_note_rounded, 'bg': 1},
    {'title': 'Astro science', 'icon': Icons.rocket_launch_rounded, 'bg': 2},
    {'title': 'Chemistry', 'icon': Icons.science_rounded, 'bg': 3},
    {'title': 'History', 'icon': Icons.history_edu_rounded, 'bg': 4},
    {'title': 'Geopolitics', 'icon': Icons.public_rounded, 'bg': 5},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await AuthService.instance.getUserData();
    if (mounted) setState(() => _userData = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildHeader(context),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final cat = _categories[index];
                    return _CategoryCard(
                      title: cat['title'] as String,
                      icon: cat['icon'] as IconData,
                      gradientIndex: cat['bg'] as int,
                      onTap: () => context.push(
                        AppRoutes.quiz,
                        extra: cat['title'] as String,
                      ),
                    );
                  },
                  childCount: _categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Logo
                Image.asset(AppImages.logo, height: 32),
                const Spacer(),
                // Avatar
                _buildAvatar(),
              ],
            ),
            const SizedBox(height: 24),
            // Greeting card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${_userData?['name']?.toString().split(' ').first ?? 'Champion'} 👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Ready for a new quiz challenge today?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Level XP row
                  _buildLevelChip(),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Pick a category',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelChip() {
    final xp = (_userData?['totalXP'] as num?)?.toInt() ?? 0;
    final level = UserLevel.forXP(xp);
    final progress = UserLevel.levelProgress(xp);
    final toNext = UserLevel.xpToNextLevel(xp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(level.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              'Lv.${level.level} ${level.name}',
              style: TextStyle(
                color: level.color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            Text(
              '$xp XP',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: Colors.white.withAlpha(40),
            valueColor: AlwaysStoppedAnimation(level.color),
          ),
        ),
        if (level.maxXP != -1) ...[
          const SizedBox(height: 4),
          Text(
            '$toNext XP to ${UserLevel.levels[level.level].name}',
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ],
    );
  }

  Widget _buildAvatar() {
    final photoUrl = _userData?['photoUrl']?.toString() ?? '';
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primary,
      backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
      child: photoUrl.isEmpty
          ? const Icon(Icons.person_rounded, color: Colors.white, size: 20)
          : null,
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int gradientIndex;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.gradientIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = AppColors
        .categoryGradients[gradientIndex % AppColors.categoryGradients.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    '10 Questions',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
