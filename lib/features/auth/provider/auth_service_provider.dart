import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/auth_service.dart';

/// Exposes a single instance of AuthService to the rest of the app.
/// Any widget or provider that needs to call signUp/login/logout
/// reads this provider instead of creating AuthService directly.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});