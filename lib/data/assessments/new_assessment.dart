import 'package:flutter/material.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/util/util.dart';

class NewAssessment with ChangeNotifier {
  NewAssessment({
    this.idNo1 = Util.defaultIntIfNull,
    this.idNo2 = Util.defaultIntIfNull,
    this.aircraftType = "",
    this.airportAndRoute = "",
    this.simulationHours = "",
    AssessmentFlightDetails? assessmentFlightDetails,
  }) : _assessmentFlightDetails =
            assessmentFlightDetails ?? AssessmentFlightDetails();

  DateTime assessmentDate = DateTime.now();

  // Flight Crew 1
  int idNo1 = Util.defaultIntIfNull;
  DateTime licenseExpiry1 = DateTime.now();

  // Flight Crew 2
  int idNo2 = Util.defaultIntIfNull;
  DateTime licenseExpiry2 = DateTime.now();

  String aircraftType = "";
  String airportAndRoute = "";
  String simulationHours = "";
  AssessmentFlightDetails _assessmentFlightDetails;

  String getIDNo1() {
    if (idNo1 == Util.defaultIntIfNull) {
      return "";
    } else {
      return idNo1.toString();
    }
  }

  String getIDNo2() {
    if (idNo2 == Util.defaultIntIfNull) {
      return "";
    } else {
      return idNo2.toString();
    }
  }
}
