import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/data/users/users.dart';
import 'package:ts_one/domain/user_repo.dart';
import 'package:ts_one/presentation/view_model/loading_viewmodel.dart';

class UserViewModel extends LoadingViewModel {
  UserViewModel({required this.repo,  required this.userPreferences});

  final UserRepo repo;
  final UserPreferences userPreferences;

  Future<UserAuth> login(String email, String password) async {
    isLoading = true;
    UserAuth userAuth = UserAuth();
    try {
      userAuth = await repo.login(email, password);
      userPreferences.saveUser(userAuth);
      isLoading = false;
    } catch (e) {
      print("Exception on UserViewModel: $e");
      isLoading = false;
    }
    return userAuth;
  }

  Future<UserAuth> loginWithGoogle() async {
    isLoading = true;
    UserAuth userAuth = UserAuth();
    try {
      userAuth = await repo.loginWithGoogle();
      userPreferences.saveUser(userAuth);
      isLoading = false;
    } catch (e) {
      print("Exception on UserViewModel: $e");
      isLoading = false;
    }
    return userAuth;
  }

  Future<UserModel> addUser(UserModel userModel) async {
    isLoading = true;
    UserModel newUserModel = UserModel();
    try {
      newUserModel = await repo.addUser(userModel);
      isLoading = false;
    } catch (e) {
      print(e.toString());
      isLoading = false;
    }
    return newUserModel;
  }

  Future<void> logout() async {
    try {
      await repo.logout();
    } catch (e) {
      print(e.toString());
    }
  }
}
