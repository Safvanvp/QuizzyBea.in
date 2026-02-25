import 'package:flutter/material.dart';

/// Every quiz awards XP = score × 10, plus a 50-XP perfectBonus.
/// XP accumulates in the user's Firestore document under `totalXP`.

class UserLevel {
  const UserLevel._({
    required this.level,
    required this.name,
    required this.emoji,
    required this.minXP,
    required this.maxXP, // -1 means "no cap"
    required this.color,
  });

  final int level;
  final String name;
  final String emoji;
  final int minXP;
  final int maxXP;
  final Color color;

  // ── Level table ────────────────────────────────────────────────────────────
  static const List<UserLevel> levels = [
    UserLevel._(
      level: 1, name: 'Novice', emoji: '🌱',
      minXP: 0, maxXP: 99,
      color: Color(0xFF94A3B8), // slate
    ),
    UserLevel._(
      level: 2, name: 'Explorer', emoji: '🔍',
      minXP: 100, maxXP: 299,
      color: Color(0xFF22D3EE), // cyan
    ),
    UserLevel._(
      level: 3, name: 'Scholar', emoji: '📚',
      minXP: 300, maxXP: 599,
      color: Color(0xFF4ADE80), // green
    ),
    UserLevel._(
      level: 4, name: 'Expert', emoji: '🧠',
      minXP: 600, maxXP: 999,
      color: Color(0xFFFBBF24), // amber
    ),
    UserLevel._(
      level: 5, name: 'Master', emoji: '⚡',
      minXP: 1000, maxXP: 1999,
      color: Color(0xFFF97316), // orange
    ),
    UserLevel._(
      level: 6, name: 'Legend', emoji: '👑',
      minXP: 2000, maxXP: -1,
      color: Color(0xFFA855F7), // purple
    ),
  ];

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Returns the UserLevel for a given XP total.
  static UserLevel forXP(int xp) {
    for (int i = levels.length - 1; i >= 0; i--) {
      if (xp >= levels[i].minXP) return levels[i];
    }
    return levels.first;
  }

  /// XP needed to reach the NEXT level (returns 0 if already at max).
  static int xpToNextLevel(int xp) {
    final current = forXP(xp);
    if (current.maxXP == -1) return 0;
    return current.maxXP + 1 - xp;
  }

  /// 0.0 – 1.0 progress within the current level's XP bracket.
  static double levelProgress(int xp) {
    final current = forXP(xp);
    if (current.maxXP == -1) return 1.0;
    final rangeWidth = current.maxXP - current.minXP + 1;
    final earned = xp - current.minXP;
    return (earned / rangeWidth).clamp(0.0, 1.0);
  }

  /// XP awarded for a quiz result.
  static int calculateXP({required int score, required int total}) {
    final base = score * 10;
    final perfectBonus = score == total ? 50 : 0;
    return base + perfectBonus;
  }
}
