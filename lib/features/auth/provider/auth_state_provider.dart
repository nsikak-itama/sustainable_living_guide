import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service_provider.dart';

/// Streams the current Firebase auth state (logged in / logged out)
/// to the rest of the app. This is what decides whether to show
/// the login screen or the home screen on app launch, and reacts
/// automatically if the user logs out.
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});