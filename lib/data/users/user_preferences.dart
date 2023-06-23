import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_one/data/users/users.dart';

class UserPreferences extends ChangeNotifier {
  UserPreferences({
    required this.preferences
  });

  final SharedPreferences preferences;

  static String keyIsLogin = "IS_LOGIN";
  static String keyUserID = "USER_ID";
  static String keyEmail = "EMAIL";
  static String keyName = "NAME";
  static String keyStaffNo = "STAFF_NO";
  static String keyPosition = "POSITION";
  static String keySubPosition = "SUB_POSITION";
  static String keyLicenseNo = "LICENSE_NO";
  static String keyLicenseLastPassed = "LICENSE_LAST_PASSED";
  static String keyLicenseExpiry = "LICENSE_EXPIRY";
  static String keyPrivileges = "PRIVILEGES";

  void saveUser(UserAuth userAuth) {
    preferences.setBool(UserPreferences.keyIsLogin, true);
    preferences.setString(UserPreferences.keyUserID, userAuth.userCredential!.user!.uid);
    preferences.setString(UserPreferences.keyEmail, userAuth.userCredential!.user!.email!);
    preferences.setString(UserPreferences.keyName, userAuth.userModel!.name);
    preferences.setString(UserPreferences.keyStaffNo, userAuth.userModel!.staffNo);
    preferences.setString(UserPreferences.keyPosition, userAuth.userModel!.position);
    preferences.setString(UserPreferences.keySubPosition, userAuth.userModel!.subPosition);
    preferences.setString(UserPreferences.keyLicenseNo, userAuth.userModel!.licenseNo);
    preferences.setString(UserPreferences.keyLicenseLastPassed, userAuth.userModel!.licenseLastPassed.toString());
    preferences.setString(UserPreferences.keyLicenseExpiry, userAuth.userModel!.licenseExpiry.toString());
    preferences.setStringList(UserPreferences.keyPrivileges, userAuth.userModel!.privileges);
    notifyListeners();
  }

  void clearUser() {
    preferences.setBool(UserPreferences.keyIsLogin, false);
    preferences.setString(UserPreferences.keyUserID, "");
    preferences.setString(UserPreferences.keyEmail, "");
    preferences.setString(UserPreferences.keyName, "");
    preferences.setString(UserPreferences.keyStaffNo, "");
    preferences.setString(UserPreferences.keyPosition, "");
    preferences.setString(UserPreferences.keySubPosition, "");
    preferences.setString(UserPreferences.keyLicenseNo, "");
    preferences.setString(UserPreferences.keyLicenseLastPassed, "");
    preferences.setString(UserPreferences.keyLicenseExpiry, "");
    preferences.setStringList(UserPreferences.keyPrivileges, []);
    notifyListeners();
  }

  bool isLogin() {
    return preferences.getBool(UserPreferences.keyIsLogin) ?? false;
  }

  void saveEmail(String email) {
    preferences.setString(UserPreferences.keyEmail, email);
    notifyListeners();
  }

  String getEmail() {
    return preferences.getString(UserPreferences.keyEmail) ?? "";
  }

  void saveUserID(String userID) {
    preferences.setString(UserPreferences.keyUserID, userID);
    notifyListeners();
  }

  String getUserID() {
    return preferences.getString(UserPreferences.keyUserID) ?? "";
  }

  void saveStaffNo(String staffNo) {
    preferences.setString(UserPreferences.keyStaffNo, staffNo);
    notifyListeners();
  }

  String getStaffNo() {
    return preferences.getString(UserPreferences.keyStaffNo) ?? "";
  }

  void saveName(String name) {
    preferences.setString(UserPreferences.keyName, name);
    notifyListeners();
  }

  String getName() {
    return preferences.getString(UserPreferences.keyName) ?? "";
  }

  void savePosition(String position) {
    preferences.setString(UserPreferences.keyPosition, position);
    notifyListeners();
  }

  String getPosition() {
    return preferences.getString(UserPreferences.keyPosition) ?? "";
  }

  void saveSubPosition(String subPosition) {
    preferences.setString(UserPreferences.keySubPosition, subPosition);
    notifyListeners();
  }

  String getSubPosition() {
    return preferences.getString(UserPreferences.keySubPosition) ?? "";
  }

  void saveLicenseNo(String licenseNo) {
    preferences.setString(UserPreferences.keyLicenseNo, licenseNo);
    notifyListeners();
  }

  String getLicenseNo() {
    return preferences.getString(UserPreferences.keyLicenseNo) ?? "";
  }

  void saveLicenseLastPassed(String licenseLastPassed) {
    preferences.setString(UserPreferences.keyLicenseLastPassed, licenseLastPassed);
    notifyListeners();
  }

  String getLicenseLastPassed() {
    return preferences.getString(UserPreferences.keyLicenseLastPassed) ?? "";
  }

  void saveLicenseExpiry(String licenseExpiry) {
    preferences.setString(UserPreferences.keyLicenseExpiry, licenseExpiry);
    notifyListeners();
  }

  String getLicenseExpiry() {
    return preferences.getString(UserPreferences.keyLicenseExpiry) ?? "";
  }

  void savePrivileges(List<String> privileges) {
    preferences.setStringList(UserPreferences.keyPrivileges, privileges);
    notifyListeners();
  }

  List<String> getPrivileges() {
    return preferences.getStringList(UserPreferences.keyPrivileges) ?? [];
  }
}