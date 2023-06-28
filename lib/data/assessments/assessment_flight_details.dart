import 'package:flutter/cupertino.dart';

class AssessmentFlightDetails with ChangeNotifier {
  AssessmentFlightDetails({
    List<String>? flightDetails,
  }) : flightDetails = flightDetails ?? [];

  List<String> flightDetails = [];

  // collection name in firebase
  static String firebaseCollection = "assessment-flightdetails";

  // document name in firebase
  static String firebaseDocument = "af-1-ap-1";

  // keys for data in document
  static String flightDetailsKey = "flight-details";

  // AssessmentFlightDetails.fromFirebase(Map<String, dynamic> map) {
  //   _flightDetails = map[flightDetailsKey];
  // }
}
