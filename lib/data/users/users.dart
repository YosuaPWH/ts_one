import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  UserModel({
    this.email = "",
    this.staffNo = "",
    this.name = "",
    this.position = "",
    this.licenseNo = "",
  });

  String email = "";
  String staffNo = "";
  String name = "";
  String position = "";
  String licenseNo = "";
  DateTime licenseLastPassed = DateTime(1970, 1, 1);
  DateTime licenseExpiry = DateTime(1970, 1, 1);

  static String keyEmail = "Email";
  static String keyLicenceExpiry = "License Expiry";
  static String keyLicenceLastPassed = "License Last Passed";
  static String keyLicenseNo = "License No";
  static String keyName = "Name";
  static String keyPosition = "Position";
  static String keyStaffNo = "Staff No";

  UserModel.fromFirebaseUser(Map<String, dynamic> map) {
    email = map[keyEmail];
    staffNo = map[keyStaffNo];
    name = map[keyName];
    position = map[keyPosition];
    licenseNo = map[keyLicenseNo];
    licenseLastPassed = DateTime.fromMillisecondsSinceEpoch(map[keyLicenceLastPassed].seconds * 1000);
    licenseExpiry = DateTime.fromMillisecondsSinceEpoch(map[keyLicenceExpiry].seconds * 1000);
  }

  Map<String, dynamic> toMap() {
    return {
      keyEmail: email,
      keyStaffNo: staffNo,
      keyName: name,
      keyPosition: position,
      keyLicenseNo: licenseNo,
      keyLicenceLastPassed: licenseLastPassed,
      keyLicenceExpiry: licenseExpiry,
    };
  }

  void updateFromMap(Map<String, dynamic> map) {
    email = map[keyEmail];
    staffNo = map[keyStaffNo];
    name = map[keyName];
    position = map[keyPosition];
    licenseNo = map[keyLicenseNo];
    licenseLastPassed = DateTime.fromMillisecondsSinceEpoch(map[keyLicenceLastPassed].seconds * 1000);
    licenseExpiry = DateTime.fromMillisecondsSinceEpoch(map[keyLicenceExpiry].seconds * 1000);
    notifyListeners();
  }

  void updateUser(UserModel userModel) {
    email = userModel.email;
    staffNo = userModel.staffNo;
    name = userModel.name;
    position = userModel.position;
    licenseNo = userModel.licenseNo;
    licenseLastPassed = userModel.licenseLastPassed;
    licenseExpiry = userModel.licenseExpiry;
    notifyListeners();
  }

  @override
  String toString() {
    return 'User(email: $email, staffNo: $staffNo, name: $name, position: $position, licenseNo: $licenseNo, licenseLastPassed: $licenseLastPassed, licenseExpiry: $licenseExpiry)';
  }
}

class UserAuth {
  UserAuth({
    UserCredential? userCredential,
    UserModel? userModel,
  });

  UserCredential? userCredential;
  UserModel? userModel;
}