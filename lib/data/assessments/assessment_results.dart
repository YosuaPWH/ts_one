import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/util/util.dart';

class AssessmentResults{
  AssessmentResults({
    this.id = Util.defaultStringIfNull,
    this.overallPerformance = Util.defaultDoubleIfNull,
    this.notes = Util.defaultStringIfNull,
  });

  static const String firebaseCollection = "assessment-results";

  static const String keyId = "id";
  static const String keyTypeOfAssessment = "type-of-assessment";
  static const String keyDate = "date";

  static const String keyExaminerStaffIDNo = "examiner-staff-id-no";
  static const String keyLicenseExpiry = "license-expiry";
  static const String keySimIdent = "sim-ident";
  static const String keyExaminerSignatureUrl = "examiner-signature-url";
  static const String keyConfirmedByExaminer = "confirmed-by-examiner";

  static const String keyOtherStaffIDNo = "other-staff-id-no";

  static const String keyAircraftType = "aircraft-type";
  static const String keyAirportAndRoute = "airport-and-route";
  static const String keySimulationHours = "simulation-hours";
  static const String keySessionDetails = "session-details";
  static const String keyTrainingCheckingDetails = "training-checking-details";

  static const String keyInstructorStaffIDNo = "instructor-staff-id-no";
  static const String keyInstructorSignatureUrl = "instructor-signature-url";
  static const String keyConfirmedByInstructor = "confirmed-by-instructor";

  static const String keyPilotAdministratorStaffIDNo = "pilot-administrator-staff-id-no";
  static const String keyPilotAdministratorSignatureUrl = "pilot-administrator-signature-url";
  static const String keyConfirmedByPilotAdministrator = "confirmed-by-pilot-administrator";

  static const String keyCPTSStaffIDNo = "cpts-staff-id-no";
  static const String keyCPTSSignatureUrl = "cpts-signature-url";
  static const String keyConfirmedByCPTS = "confirmed-by-cpts";

  static const String keyOverallPerformance = "overall-performance";
  static const String keyNotes = "notes";
  static const String keyDeclaration = "declaration";

  String id = Util.defaultStringIfNull;
  String typeOfAssessment = Util.defaultStringIfNull;
  DateTime date = Util.getCurrentDateWithoutTime();

  int examinerStaffIDNo = Util.defaultIntIfNull;
  DateTime licenseExpiry = Util.defaultDateIfNull;
  String simIdent = Util.defaultStringIfNull;
  String examinerSignatureUrl = Util.defaultStringIfNull;
  bool confirmedByExaminer = false;

  int otherStaffIDNo = Util.defaultIntIfNull;

  String aircraftType = Util.defaultStringIfNull;
  String airportAndRoute = Util.defaultStringIfNull;
  String simulationHours = Util.defaultStringIfNull;
  String sessionDetails = Util.defaultStringIfNull;
  List<String> trainingCheckingDetails = [];

  int instructorStaffIDNo = Util.defaultIntIfNull;
  String instructorSignatureUrl = Util.defaultStringIfNull;
  bool confirmedByInstructor = false;

  int pilotAdministratorStaffIDNo = Util.defaultIntIfNull;
  String pilotAdministratorSignatureUrl = Util.defaultStringIfNull;
  bool confirmedByPilotAdministrator = false;

  int cptsStaffIDNo = Util.defaultIntIfNull;
  String cptsSignatureUrl = Util.defaultStringIfNull;
  bool confirmedByCPTS = false;

  double overallPerformance = Util.defaultDoubleIfNull;
  String notes = Util.defaultStringIfNull;
  String declaration = Util.defaultStringIfNull;

  /// All variables results are stored here
  List<AssessmentVariableResults> variableResults = [];

  AssessmentResults.fromFirebase(Map<String, dynamic> data){
    id = data[keyId];
    date = DateTime.fromMillisecondsSinceEpoch(data[keyDate].seconds * 1000);

    examinerStaffIDNo = data[keyExaminerStaffIDNo];
    licenseExpiry = DateTime.fromMillisecondsSinceEpoch(data[keyLicenseExpiry].seconds * 1000);
    simIdent = data[keySimIdent];
    examinerSignatureUrl = data[keyExaminerSignatureUrl];
    confirmedByExaminer = data[keyConfirmedByExaminer];

    otherStaffIDNo = data[keyOtherStaffIDNo];

    aircraftType = data[keyAircraftType];
    airportAndRoute = data[keyAirportAndRoute];
    simulationHours = data[keySimulationHours];
    sessionDetails = data[keySessionDetails];
    trainingCheckingDetails = (data[keyTrainingCheckingDetails] as List<dynamic>).map(
            (item) => item.toString()
    ).toList();

    instructorStaffIDNo = data[keyInstructorStaffIDNo];
    instructorSignatureUrl = data[keyInstructorSignatureUrl];
    confirmedByInstructor = data[keyConfirmedByInstructor];

    pilotAdministratorStaffIDNo = data[keyPilotAdministratorStaffIDNo];
    pilotAdministratorSignatureUrl = data[keyPilotAdministratorSignatureUrl];
    confirmedByPilotAdministrator = data[keyConfirmedByPilotAdministrator];

    cptsStaffIDNo = data[keyCPTSStaffIDNo];
    cptsSignatureUrl = data[keyCPTSSignatureUrl];
    confirmedByCPTS = data[keyConfirmedByCPTS];

    overallPerformance = data[keyOverallPerformance];
    notes = data[keyNotes];
  }

  Map<String, dynamic> toFirebase() {
    return {
      keyId: id,
      keyDate: date,

      keyExaminerStaffIDNo: examinerStaffIDNo,
      keyLicenseExpiry: licenseExpiry,
      keySimIdent: simIdent,
      keyExaminerSignatureUrl: examinerSignatureUrl,
      keyConfirmedByExaminer: confirmedByExaminer,

      keyOtherStaffIDNo: otherStaffIDNo,

      keyAircraftType: aircraftType,
      keyAirportAndRoute: airportAndRoute,
      keySimulationHours: simulationHours,
      keySessionDetails: sessionDetails,
      keyTrainingCheckingDetails: trainingCheckingDetails,

      keyInstructorStaffIDNo: instructorStaffIDNo,
      keyInstructorSignatureUrl: instructorSignatureUrl,
      keyConfirmedByInstructor: confirmedByInstructor,

      keyPilotAdministratorStaffIDNo: pilotAdministratorStaffIDNo,
      keyPilotAdministratorSignatureUrl: pilotAdministratorSignatureUrl,
      keyConfirmedByPilotAdministrator: confirmedByPilotAdministrator,

      keyCPTSStaffIDNo: cptsStaffIDNo,
      keyCPTSSignatureUrl: cptsSignatureUrl,
      keyConfirmedByCPTS: confirmedByCPTS,

      keyOverallPerformance: overallPerformance,
      keyNotes: notes,
    };
  }

  static List<AssessmentResults> extractDataFromNewAssessment(NewAssessment newAssessment) {
    List<AssessmentResults> results = [];

    AssessmentResults assessmentResults1 = AssessmentResults();
    assessmentResults1.typeOfAssessment = newAssessment.typeOfAssessment;
    assessmentResults1.date = newAssessment.assessmentDate;
    assessmentResults1.examinerStaffIDNo = newAssessment.idNo1;
    assessmentResults1.licenseExpiry = newAssessment.licenseExpiry1;
    assessmentResults1.simIdent = Util.defaultStringIfNull; // TODO complete this one on new_assessment and the view
    assessmentResults1.otherStaffIDNo = newAssessment.idNo2;
    assessmentResults1.aircraftType = newAssessment.aircraftType;
    assessmentResults1.airportAndRoute = newAssessment.airportAndRoute;
    assessmentResults1.simulationHours = newAssessment.simulationHours;
    assessmentResults1.sessionDetails = newAssessment.sessionDetails1;
    assessmentResults1.trainingCheckingDetails = newAssessment.assessmentFlightDetails1.flightDetails;
    assessmentResults1.instructorStaffIDNo = newAssessment.idNoInstructor;
    assessmentResults1.instructorSignatureUrl = newAssessment.instructorSignatureUrl;
    assessmentResults1.confirmedByInstructor = true;
    assessmentResults1.overallPerformance = newAssessment.overallPerformance1;
    assessmentResults1.notes = newAssessment.notes1;
    assessmentResults1.declaration = newAssessment.declaration1;
    assessmentResults1.variableResults.addAll(newAssessment.assessmentVariablesFlights1);
    assessmentResults1.variableResults.addAll(newAssessment.assessmentVariablesFlightsHumanFactor1);

    AssessmentResults assessmentResults2 = AssessmentResults();
    assessmentResults2.typeOfAssessment = newAssessment.typeOfAssessment;
    assessmentResults2.date = newAssessment.assessmentDate;
    assessmentResults2.examinerStaffIDNo = newAssessment.idNo2;
    assessmentResults2.licenseExpiry = newAssessment.licenseExpiry2;
    assessmentResults2.simIdent = Util.defaultStringIfNull; // TODO complete this one on new_assessment and the view
    assessmentResults2.otherStaffIDNo = newAssessment.idNo2;
    assessmentResults2.aircraftType = newAssessment.aircraftType;
    assessmentResults2.airportAndRoute = newAssessment.airportAndRoute;
    assessmentResults2.simulationHours = newAssessment.simulationHours;
    assessmentResults2.sessionDetails = newAssessment.sessionDetails2;
    assessmentResults2.trainingCheckingDetails = newAssessment.assessmentFlightDetails2.flightDetails;
    assessmentResults2.instructorStaffIDNo = newAssessment.idNoInstructor;
    assessmentResults2.instructorSignatureUrl = newAssessment.instructorSignatureUrl;
    assessmentResults2.confirmedByInstructor = true;
    assessmentResults2.overallPerformance = newAssessment.overallPerformance2;
    assessmentResults2.notes = newAssessment.notes2;
    assessmentResults2.declaration = newAssessment.declaration2;
    assessmentResults2.variableResults.addAll(newAssessment.assessmentVariablesFlights2);
    assessmentResults2.variableResults.addAll(newAssessment.assessmentVariablesFlightsHumanFactor2);

    results.add(assessmentResults1);
    results.add(assessmentResults2);

    return results;
  }
}
