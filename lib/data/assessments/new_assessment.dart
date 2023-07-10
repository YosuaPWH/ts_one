import 'package:flutter/material.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/util/util.dart';

class NewAssessment with ChangeNotifier {
  NewAssessment({
    this.name = "",
    this.staffNo = Util.defaultIntIfNull,
    this.otherCrewMemberStaffNo = "",
    this.aircraftType = "",
    this.airportAndRoute = "",
    this.simulationHours = "",
    AssessmentFlightDetails? assessmentFlightDetails,
  }) : _assessmentFlightDetails =
            assessmentFlightDetails ?? AssessmentFlightDetails();

  DateTime assessmentDate = DateTime.now();
  String name = "";
  int staffNo = Util.defaultIntIfNull;
  String otherCrewMemberStaffNo = "";
  String aircraftType = "";
  String airportAndRoute = "";
  String simulationHours = "";
  AssessmentFlightDetails _assessmentFlightDetails;

  String getStaffNo() {
    if (staffNo == Util.defaultIntIfNull) {
      return "";
    } else {
      return staffNo.toString();
    }
  }
}
