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

  static String keyPrivilegeCreateAssessment = "create-assessment"; // for instructor to make a new assessment
  static String keyPrivilegeUpdateAssessment = "update-assessment"; // for instructor to update an unconfirmed assessment

  // for instructor, examinee, CPTS, and admin to confirm an assessment.
  // for instructor, examinee, and CPTS to any assessments related to them.
  static String keyPrivilegeConfirmAssessment = "confirm-assessment";

  static String keyPrivilegeViewAllAssessments = "view-all-assessments"; // for CPTS and admin to view all assessments
  static String keyPrivilegeManageFormAssessment = "manage-form-assessment"; // for CPTS and admin to manage form assessment
  static String keyPrivilegeCreateUser = "create-user"; // for admin to create a new user
  static String keyPrivilegeUpdateUser = "update-user"; // for admin to update a user
  static String keyPrivilegeDeleteUser = "delete-user"; // for admin to delete a user

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

  Map<String, dynamic> toFirebase() {
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