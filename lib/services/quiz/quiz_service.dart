import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzybea_in/models/user/user_level.dart';

/// Result returned after saving a quiz — includes XP earned and new level info.
class QuizSaveResult {
  final int xpEarned;
  final int newTotalXP;
  final UserLevel newLevel;
  final bool leveledUp;
  final UserLevel? previousLevel;

  const QuizSaveResult({
    required this.xpEarned,
    required this.newTotalXP,
    required this.newLevel,
    required this.leveledUp,
    this.previousLevel,
  });
}

/// Singleton quiz service for Firestore history + XP/level operations.
class QuizService {
  QuizService._();
  static final QuizService instance = QuizService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Save quiz + award XP ──────────────────────────────────────────────────

  Future<QuizSaveResult> saveQuizResult({
    required String category,
    required int score,
    required int total,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      return QuizSaveResult(
        xpEarned: 0,
        newTotalXP: 0,
        newLevel: UserLevel.levels.first,
        leveledUp: false,
      );
    }

    final xpEarned = UserLevel.calculateXP(score: score, total: total);

    // Read current XP (default 0 if first quiz)
    final userRef = _firestore.collection('users').doc(user.uid);
    final snap = await userRef.get();
    final currentXP = (snap.data()?['totalXP'] as num?)?.toInt() ?? 0;
    final previousLevel = UserLevel.forXP(currentXP);

    final newTotalXP = currentXP + xpEarned;
    final newLevel = UserLevel.forXP(newTotalXP);

    // Batch write: history + updated XP/level on the user doc
    final batch = _firestore.batch();

    batch.set(
      userRef.collection('quizHistory').doc(),
      {
        'category': category,
        'score': score,
        'total': total,
        'xpEarned': xpEarned,
        'timestamp': Timestamp.now(),
      },
    );

    batch.update(userRef, {
      'totalXP': newTotalXP,
      'level': newLevel.level,
      'levelName': newLevel.name,
    });

    await batch.commit();

    return QuizSaveResult(
      xpEarned: xpEarned,
      newTotalXP: newTotalXP,
      newLevel: newLevel,
      leveledUp: newLevel.level > previousLevel.level,
      previousLevel: previousLevel,
    );
  }

  // ── History ───────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getQuizHistory() async {
    final user = _auth.currentUser;
    if (user == null) return [];
    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('quizHistory')
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
