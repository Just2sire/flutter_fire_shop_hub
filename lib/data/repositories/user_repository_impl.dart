import "package:movify/data/models/user_model.dart";
import "package:movify/data/services/local_storage_service.dart";
import "package:movify/domain/entities/user.dart";
import "package:movify/domain/repositories/user_repository.dart";

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl();

  @override
  Future<bool> hasName() => SharedPrefsService.hasName;

  @override
  Future<User> getUser() async {
    final userModel = await SharedPrefsService.getUser;
    return userModel.toEntity();
  }

  @override
  Future<bool> saveUser(User user) {
    final userModel = UserModel.fromEntity(user);
    return SharedPrefsService.saveUser(userModel);
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
