import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';
import 'auth_service_provider.dart';

/// Manages the state of the sign-up/login process itself
/// (loading, error, success) so the UI can react accordingly
/// — e.g., show a spinner, show an error message, or navigate on success.
class AuthFormController extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    // No action on initial build; state starts as null (idle).
    return null;
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final authService = ref.read(authServiceProvider);

    state = await AsyncValue.guard(() {
      return authService.signUp(name: name, email: email, password: password);
    });
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final authService = ref.read(authServiceProvider);

    state = await AsyncValue.guard(() {
      return authService.login(email: email, password: password);
    });
  }

  Future<void> logout() async {
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    state = const AsyncData(null);
  }
}

final authFormControllerProvider =
    AsyncNotifierProvider<AuthFormController, UserModel?>(() {
  return AuthFormController();
});