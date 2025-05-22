import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //signin
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //save user data to firestore
      firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': userCredential.user!.displayName,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to sign in: ${e.message}');
    }
  }

  //signin with google
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In aborted');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        // Save user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            {
              'uid': user.uid,
              'email': user.email,
              'name': user.displayName,
              'photoUrl': user.photoURL,
              'signInMethod': 'google',
            },
            SetOptions(
                merge: true)); // merge: true to avoid overwriting other fields
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Google sign-in failed: ${e.message}');
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }

  //signup
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    dynamic password,
    String name,
  ) async {
    {
      if (name.trim().isEmpty) {
        throw Exception('Name cannot be empty');
      }
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await userCredential.user!.updateDisplayName(name);

        //save user data to firestore
        firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'uid': userCredential.user!.uid,
        });
        return userCredential;
      } on FirebaseAuthException catch (e) {
        throw Exception(e.message);
      }
    }
  }

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //signout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
