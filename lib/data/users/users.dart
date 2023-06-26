import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  UserModel({
    this.email = "",
    this.staffNo = "",
    this.name = "",
    this.position = "",
    this.subPosition = "",
    this.licenseNo = "",
  });

  String email = "";
  String staffNo = "";
  String name = "";
  String position = "";
  String subPosition = "";
  String licenseNo = "";
  DateTime licenseLastPassed = DateTime.now();
  DateTime licenseExpiry = DateTime.now();
  List<String> privileges = [];

  // this is the collection name in firebase
  static String firebaseCollection = "users";

  // all the keys for the map stored in firebase
  static String keyEmail = "Email";
  static String keyLicenseExpiry = "License Expiry";
  static String keyLicenceLastPassed = "License Last Passed";
  static String keyLicenseNo = "License No";
  static String keyName = "Name";
  static String keyPosition = "Position";
  static String keySubPosition = "Sub Position";
  static String keyStaffNo = "Staff No";
  static String keyPrivileges = "Privileges";

  // this is used to set the default date if the date is null
  static DateTime defaultDateIfNull = DateTime(2006, 1, 1, 0, 0, 0, 0, 0);

  UserModel.fromFirebaseUser(Map<String, dynamic> map) {
    email = map[keyEmail]; // if null, return empty string
    staffNo = map[keyStaffNo];
    name = map[keyName];
    position = map[keyPosition];
    subPosition = map[keySubPosition];
    licenseNo = map[keyLicenseNo];
    licenseLastPassed = DateTime.fromMillisecondsSinceEpoch(map[keyLicenceLastPassed].seconds * 1000);
    licenseExpiry = DateTime.fromMillisecondsSinceEpoch(map[keyLicenseExpiry].seconds * 1000);
    privileges = (map[keyPrivileges] as List<dynamic>).map((item) => item.toString()).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      keyEmail: email,
      keyStaffNo: staffNo,
      keyName: name,
      keyPosition: position,
      keySubPosition: subPosition,
      keyLicenseNo: licenseNo,
      keyLicenceLastPassed: licenseLastPassed,
      keyLicenseExpiry: licenseExpiry,
      keyPrivileges: privileges,
    };
  }

  void updateFromMap(Map<String, dynamic> map) {
    email = map[keyEmail];
    staffNo = map[keyStaffNo];
    name = map[keyName];
    position = map[keyPosition];
    subPosition = map[keySubPosition];
    licenseNo = map[keyLicenseNo];
    licenseLastPassed = DateTime.fromMillisecondsSinceEpoch(map[keyLicenceLastPassed].seconds * 1000);
    licenseExpiry = DateTime.fromMillisecondsSinceEpoch(map[keyLicenseExpiry].seconds * 1000);
    privileges = map[keyPrivileges];
    notifyListeners();
  }

  void updateUser(UserModel userModel) {
    email = userModel.email;
    staffNo = userModel.staffNo;
    name = userModel.name;
    position = userModel.position;
    subPosition = userModel.subPosition;
    licenseNo = userModel.licenseNo;
    licenseLastPassed = userModel.licenseLastPassed;
    licenseExpiry = userModel.licenseExpiry;
    privileges = userModel.privileges;
    notifyListeners();
  }

  @override
  String toString() {
    return 'User(email: $email, staffNo: $staffNo, name: $name, position: $position, subPosition: $subPosition, licenseNo: $licenseNo, licenseLastPassed: $licenseLastPassed, licenseExpiry: $licenseExpiry,'
        ' privileges: $privileges)';
  }
}

class UserAuth {
  UserAuth({
    UserCredential? userCredential,
    UserModel? userModel,
  });

  UserCredential? userCredential;
  UserModel? userModel;
  String errorMessage = "";

  @override
  String toString() => 'UserAuth(userCredential: $userCredential, userModel: $userModel)';
}