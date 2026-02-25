import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Singleton auth service wrapping FirebaseAuth + Firestore.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Sign in ────────────────────────────────────────────────────────────────

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Sign-in failed');
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Google sign-in cancelled');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set(
          {
            'uid': user.uid,
            'email': user.email,
            'name': user.displayName,
            'photoUrl': user.photoURL,
            'signInMethod': 'google',
          },
          SetOptions(merge: true),
        );
      }
      return userCred;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Google sign-in failed');
    }
  }

  // ── Sign up ────────────────────────────────────────────────────────────────

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    if (name.trim().isEmpty) throw Exception('Name cannot be empty');
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userCred.user!.updateDisplayName(name);
      await _firestore.collection('users').doc(userCred.user!.uid).set({
        'uid': userCred.user!.uid,
        'email': email,
        'name': name,
        'signInMethod': 'email',
      });
      return userCred;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Sign-up failed');
    }
  }

  // ── Firestore helpers ──────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getUserData() async {
    final user = currentUser;
    if (user == null) return null;
    final snap = await _firestore.collection('users').doc(user.uid).get();
    return snap.data();
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    final user = currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).update(data);
  }

  // ── Sign out ───────────────────────────────────────────────────────────────

  Future<void> signOut() async => _auth.signOut();
}
