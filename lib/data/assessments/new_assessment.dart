import 'package:flutter/material.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';

class NewAssessment with ChangeNotifier {
  NewAssessment({
    this.name = "",
    this.staffNo = "",
    this.otherCrewMemberStaffNo = "",
    this.aircraftType = "",
    this.airportAndRoute = "",
    this.simulationHours = "",
    AssessmentFlightDetails? assessmentFlightDetails,
  }) : _assessmentFlightDetails = assessmentFlightDetails ?? AssessmentFlightDetails();

  DateTime assessmentDate = DateTime.now();
  String name = "";
  String staffNo = "";
  String otherCrewMemberStaffNo = "";
  String aircraftType = "";
  String airportAndRoute = "";
  String simulationHours = "";
  AssessmentFlightDetails _assessmentFlightDetails;

  @override
  String toString() {
    return 'NewAssessment{name: $name, staffNumber: $staffNumber, otherCrewMember: $otherCrewMember,'
        'aircraftType: $aircraftType, airportAndRoute: $airportAndRoute, simulationHours: $simulationHours}';
  }
}
