import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

/// Handles all direct communication with Firebase Auth and the
/// `users` collection in Firestore. No Riverpod, no UI logic here —
/// this class only knows how to talk to Firebase.
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream of auth state changes — emits a User when logged in,
  /// null when logged out. The app will listen to this to decide
  /// whether to show the login screen or the home screen.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Currently signed-in Firebase user, if any.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Creates a new account with email/password, then creates the
  /// corresponding user profile document in Firestore.
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      final newUser = UserModel(
        uid: uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      // Store the profile document in Firestore, keyed by uid.
      await _firestore.collection('users').doc(uid).set(newUser.toMap());

      return newUser;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Signs in an existing user with email/password.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // Fetch the user's profile from Firestore.
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        throw Exception(
          'User profile not found in database. Please contact support.',
        );
      }

      return UserModel.fromMap(doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  /// Signs the current user out.
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  /// Converts Firebase's raw error codes into readable messages.
  String _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}