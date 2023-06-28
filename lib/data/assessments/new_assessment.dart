import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';

class NewAssessment with ChangeNotifier {
  NewAssessment({
    required this.name,
    required this.staffNumber,
    required this.otherCrewMember,
    required this.aircraftType,
    required this.airportAndRoute,
    required this.simulationHours,
    AssessmentFlightDetails? assessmentFlightDetails,
  }) : _assessmentFlightDetails =
            assessmentFlightDetails ?? AssessmentFlightDetails();

  String name;
  String staffNumber;
  String otherCrewMember;
  String aircraftType;
  String airportAndRoute;
  String simulationHours;
  AssessmentFlightDetails _assessmentFlightDetails;
}
