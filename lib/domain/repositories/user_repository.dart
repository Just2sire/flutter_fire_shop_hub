import "../entities/user.dart";

abstract class UserRepository {
  Future<bool> hasName();
  Future<User> getUser();
  Future<bool> saveUser(User user);
  Future<bool> updateUser({String? username, String? email, String? phone});
  Future<bool> removeUser();
}
