import "../../domain/repositories/user_repository.dart";
import "../models/user.dart";
import "../services/local_storage_service.dart";

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl();

  @override
  Future<User> getUser() async {
    final user = await SharedPrefsService.getUser;
    return user;
  }

  @override
  Future<bool> saveUser(User user) {
    return SharedPrefsService.saveUser(user);
  }

  @override
  Future<bool> updateUser({String? username, String? email, String? phone}) {
    return SharedPrefsService.updateUser(
      username: username,
      email: email,
      phone: phone,
    );
  }

  @override
  Future<bool> removeUser() {
    return SharedPrefsService.removeUser();
  }
}
