import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:quizzybea_in/models/user/user_level.dart';
import 'package:quizzybea_in/services/leaderboard/leaderboard_service.dart';
import 'package:quizzybea_in/theme/app_colors.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  List<LeaderboardEntry> _entries = [];
  bool _isLoading = true;
  String? _errorMsg;
  int? _myRank;

  late final AnimationController _podiumController;

  @override
  void initState() {
    super.initState();
    _podiumController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _load();
  }

  @override
  void dispose() {
    _podiumController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final entries = await LeaderboardService.instance.getLeaderboard();
      debugPrint('[LeaderboardPage] Got ${entries.length} entries');

      // Derive rank from the fetched list
      int? myRank;
      for (final e in entries) {
        if (e.isCurrentUser) {
          myRank = e.rank;
          break;
        }
      }

      if (mounted) {
        setState(() {
          _entries = entries;
          _myRank = myRank;
          _isLoading = false;
        });
        if (_entries.isNotEmpty) {
          _podiumController.forward(from: 0);
        }
      }
    } catch (e) {
      debugPrint('[LeaderboardPage] Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMsg = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.bgCard,
        onRefresh: _load,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            _buildHeader(),
            if (_isLoading)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _buildShimmerRow(),
                  childCount: 10,
                ),
              )
            else if (_errorMsg != null)
              SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: AppColors.error, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'Failed to load leaderboard',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMsg!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textHint),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _load,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (_entries.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events_outlined,
                          color: AppColors.textHint, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'No quiz results yet!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete a quiz to appear on the leaderboard.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              if (_entries.length >= 3)
                SliverToBoxAdapter(child: _buildPodium()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final start = _entries.length >= 3 ? 3 : 0;
                      return _buildRow(_entries[start + i]);
                    },
                    childCount: _entries.length >= 3
                        ? _entries.length - 3
                        : _entries.length,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomSheet: (!_isLoading && _myRank != null) ? _buildMyRankBar() : null,
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────

  SliverToBoxAdapter _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events_rounded,
                    color: Colors.white, size: 28),
                const SizedBox(width: 10),
                Text(
                  'Leaderboard',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Top players ranked by score',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }

  // ── Podium (top 3) ───────────────────────────────────────────────────────

  Widget _buildPodium() {
    final top3 = _entries.take(3).toList();
    // order: 2nd (left), 1st (centre, tallest), 3rd (right)
    final order = [
      top3.length > 1 ? top3[1] : null,
      top3[0],
      top3.length > 2 ? top3[2] : null,
    ];
    final heights = [100.0, 130.0, 80.0];
    final medals = ['🥈', '🥇', '🥉'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: AnimatedBuilder(
        animation: _podiumController,
        builder: (_, __) {
          final t = Curves.easeOutBack
              .transform(_podiumController.value.clamp(0.0, 1.0));
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(3, (i) {
              final entry = order[i];
              if (entry == null) return const Expanded(child: SizedBox());
              return Expanded(
                child: Transform.scale(
                  scale: t,
                  alignment: Alignment.bottomCenter,
                  child: _PodiumPillar(
                    entry: entry,
                    height: heights[i],
                    medal: medals[i],
                    isFirst: i == 1,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  // ── List rows (rank 4+) ──────────────────────────────────────────────────

  Widget _buildRow(LeaderboardEntry e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: e.isCurrentUser
            ? AppColors.primary.withAlpha(30)
            : AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: e.isCurrentUser ? AppColors.primary : AppColors.divider,
          width: e.isCurrentUser ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          // Rank badge
          SizedBox(
            width: 32,
            child: Text(
              '#${e.rank}',
              style: const TextStyle(
                color: AppColors.textHint,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Avatar
          _Avatar(name: e.name, photoUrl: e.photoUrl, size: 38),
          const SizedBox(width: 12),
          // Name + level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.isCurrentUser ? '${e.name} (You)' : e.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: e.isCurrentUser
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                _LevelBadge(level: e.level, compact: true),
              ],
            ),
          ),
          // Score chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: e.level.color.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${e.totalScore} pts',
              style: TextStyle(
                color: e.level.color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom bar with current user's rank ─────────────────────────────────

  Widget _buildMyRankBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: const Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, -4),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            const Icon(Icons.location_on_rounded,
                color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Your global rank',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(colors: AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '#$_myRank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shimmer placeholder ─────────────────────────────────────────────────

  Widget _buildShimmerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Shimmer.fromColors(
        baseColor: AppColors.bgCard,
        highlightColor: AppColors.bgSurface,
        child: Container(
          height: 62,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

// ── Podium pillar widget ──────────────────────────────────────────────────────

class _PodiumPillar extends StatelessWidget {
  final LeaderboardEntry entry;
  final double height;
  final String medal;
  final bool isFirst;

  const _PodiumPillar({
    required this.entry,
    required this.height,
    required this.medal,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(medal, style: const TextStyle(fontSize: 26)),
        const SizedBox(height: 4),
        _Avatar(
          name: entry.name,
          photoUrl: entry.photoUrl,
          size: isFirst ? 60 : 48,
          borderColor: entry.level.color,
        ),
        const SizedBox(height: 6),
        Text(
          entry.name.split(' ').first,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          '${entry.totalScore} pts',
          style: TextStyle(
            color: entry.level.color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                entry.level.color.withAlpha(200),
                entry.level.color.withAlpha(80),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
          ),
          child: Center(
            child: Text(
              '#${entry.rank}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Shared avatar widget ──────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final double size;
  final Color? borderColor;

  const _Avatar({
    required this.name,
    this.photoUrl,
    required this.size,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 2.5)
            : null,
      ),
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: AppColors.primary.withAlpha(50),
        backgroundImage: hasPhoto ? NetworkImage(photoUrl!) : null,
        child: !hasPhoto
            ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: size * 0.38,
                ),
              )
            : null,
      ),
    );
  }
}

// ── Level badge widget ────────────────────────────────────────────────────────

class _LevelBadge extends StatelessWidget {
  final UserLevel level;
  final bool compact;

  const _LevelBadge({required this.level, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(level.emoji, style: TextStyle(fontSize: compact ? 12 : 15)),
        const SizedBox(width: 4),
        Text(
          'Lv.${level.level} ${level.name}',
          style: TextStyle(
            color: level.color,
            fontWeight: FontWeight.w600,
            fontSize: compact ? 11 : 13,
          ),
        ),
      ],
    );
  }
}
