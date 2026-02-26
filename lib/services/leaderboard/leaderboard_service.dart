import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:quizzybea_in/models/user/user_level.dart';

/// A single entry in the ranked leaderboard (already aggregated per user).
class LeaderboardEntry {
  final String uid;
  final String name;
  final String? photoUrl;
  final int totalScore;
  final int xp;
  final UserLevel level;
  final int rank;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.uid,
    required this.name,
    this.photoUrl,
    required this.totalScore,
    required this.xp,
    required this.level,
    required this.rank,
    required this.isCurrentUser,
  });
}

/// Reads and aggregates the existing `leaderboard` Firestore collection.
class LeaderboardService {
  LeaderboardService._();
  static final LeaderboardService instance = LeaderboardService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<LeaderboardEntry>> getLeaderboard({int limit = 50}) async {
    final currentUid = _auth.currentUser?.uid;

    try {
      // Simple fetch — no orderBy to avoid index requirements
      final snapshot = await _firestore.collection('leaderboard').get();

      debugPrint(
          '[Leaderboard] Fetched ${snapshot.docs.length} docs from Firestore');

      if (snapshot.docs.isEmpty) {
        debugPrint('[Leaderboard] Collection is empty — check Firestore rules');
        return [];
      }

      // Aggregate: sum totalScore per userId
      final Map<String, _UserAgg> agg = {};

      for (final doc in snapshot.docs) {
        final d = doc.data();
        final uid = (d['userId'] as String?)?.trim() ?? '';
        if (uid.isEmpty) continue;

        final score = (d['totalScore'] as num?)?.toInt() ?? 0;
        final name = (d['username'] as String?) ?? 'Anonymous';
        final photo = (d['profileImage'] as String?) ?? '';

        if (agg.containsKey(uid)) {
          agg[uid]!.totalScore += score;
          if (photo.isNotEmpty) agg[uid]!.photoUrl = photo;
        } else {
          agg[uid] = _UserAgg(
            uid: uid,
            name: name,
            photoUrl: photo,
            totalScore: score,
          );
        }
      }

      debugPrint('[Leaderboard] Aggregated ${agg.length} unique users');

      // Sort descending by total score
      final sorted = agg.values.toList()
        ..sort((a, b) => b.totalScore.compareTo(a.totalScore));

      // Build LeaderboardEntry list
      final entries = <LeaderboardEntry>[];
      final count = min(limit, sorted.length);
      for (int i = 0; i < count; i++) {
        final u = sorted[i];
        final xp = u.totalScore * 10;
        entries.add(LeaderboardEntry(
          uid: u.uid,
          name: u.name,
          photoUrl: u.photoUrl.isEmpty ? null : u.photoUrl,
          totalScore: u.totalScore,
          xp: xp,
          level: UserLevel.forXP(xp),
          rank: i + 1,
          isCurrentUser: u.uid == currentUid,
        ));
      }

      return entries;
    } catch (e, st) {
      debugPrint('[Leaderboard] ERROR: $e');
      debugPrint('[Leaderboard] Stack: $st');
      rethrow;
    }
  }

  Future<int?> getCurrentUserRank() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    try {
      final all = await getLeaderboard(limit: 1000);
      for (final e in all) {
        if (e.uid == uid) return e.rank;
      }
      return all.length + 1;
    } catch (e) {
      debugPrint('[Leaderboard] Rank error: $e');
      return null;
    }
  }
}

class _UserAgg {
  final String uid;
  final String name;
  String photoUrl;
  int totalScore;

  _UserAgg({
    required this.uid,
    required this.name,
    required this.photoUrl,
    required this.totalScore,
  });
}
