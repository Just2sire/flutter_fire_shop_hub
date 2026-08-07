import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shop_hub/data/models/index.dart" show User;
import "package:shop_hub/data/repositories/user_repository_impl.dart";
import "package:shop_hub/domain/repositories/user_repository.dart";

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return const UserRepositoryImpl();
});

class UserNotifier extends AsyncNotifier<User> {
  late final UserRepository _userRepository;

  @override
  Future<User> build() async {
    _userRepository = ref.watch(userRepositoryProvider);
    return _userRepository.getUser();
  }

  Future<bool> updateUser({
    String? username,
    String? email,
    String? phone,
  }) async {
    final current = state.value;
    if (current != null) {
      final updated = current.copyWith(
        username: username,
        email: email,
        phone: phone,
      );
      state = AsyncValue.data(updated);
    }

    try {
      final success = await _userRepository.updateUser(
        username: username,
        email: email,
        phone: phone,
      );
      if (!success && current != null) {
        // Rollback on failure
        state = AsyncValue.data(current);
      }
      return success;
    } catch (e, st) {
      if (current != null) {
        state = AsyncValue.data(current);
      } else {
        state = AsyncValue.error(e, st);
      }
      return false;
    }
  }

  Future<bool> saveUser(User user) async {
    final previous = state.value;
    state = AsyncValue.data(user);
    try {
      final success = await _userRepository.saveUser(user);
      if (!success && previous != null) {
        state = AsyncValue.data(previous);
      }
      return success;
    } catch (e, st) {
      if (previous != null) {
        state = AsyncValue.data(previous);
      } else {
        state = AsyncValue.error(e, st);
      }
      return false;
    }
  }

  Future<bool> removeUser() async {
    try {
      final success = await _userRepository.removeUser();
      ref.invalidateSelf();
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, User>(
  UserNotifier.new,
);
