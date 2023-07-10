import 'package:flutter/material.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/util/util.dart';

class NewAssessment with ChangeNotifier {
  NewAssessment({
    this.idNo1 = Util.defaultIntIfNull,
    this.idNo2 = Util.defaultIntIfNull,
    this.sessionDetails1 = "Training",
    this.sessionDetails2 = "Training",
    this.aircraftType = "",
    this.airportAndRoute = "",
    this.simulationHours = "",
  });

  DateTime assessmentDate = DateTime.now();

  // Flight Crew 1
  int idNo1 = Util.defaultIntIfNull;
  DateTime licenseExpiry1 = DateTime.now();
  String sessionDetails1 = "Training";
  AssessmentFlightDetails assessmentFlightDetails1 = AssessmentFlightDetails();

  // Flight Crew 2
  int idNo2 = Util.defaultIntIfNull;
  DateTime licenseExpiry2 = DateTime.now();
  String sessionDetails2 = "Training";
  AssessmentFlightDetails assessmentFlightDetails2 = AssessmentFlightDetails();

  String aircraftType = "";
  String airportAndRoute = "";
  String simulationHours = "";

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

  @override
  String toString() {
    return "NewAssessment: idNo1: $idNo1, idNo2: $idNo2, aircraftType: $aircraftType, airportAndRoute: $airportAndRoute, simulationHours: $simulationHours"
        ", assessmentDate: $assessmentDate, licenseExpiry1: $licenseExpiry1, licenseExpiry2: $licenseExpiry2, "
        "sessionDetails1: $sessionDetails1, sessionDetails2: $sessionDetails2, "
        "assessmentFlightDetails1: $assessmentFlightDetails1, assessmentFlightDetails2: $assessmentFlightDetails2";
  }
}
