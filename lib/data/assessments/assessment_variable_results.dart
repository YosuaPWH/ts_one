import 'package:flutter/cupertino.dart';
import 'package:ts_one/util/util.dart';

class AssessmentVariableResults with ChangeNotifier {
  AssessmentVariableResults({
    this.id = Util.defaultStringIfNull,
    this.assessmentResultsId = Util.defaultStringIfNull,
    this.assessmentVariableId = Util.defaultStringIfNull,
    this.assessmentVariableName = Util.defaultStringIfNull,
    this.assessmentSatisfactory,
    this.assessmentMarkers,
    this.pilotFlyingMarkers,
    this.pilotMonitoringMarkers,
    this.isNotApplicable = false,
  });

  static const String keyId = "id";
  static const String keyAssessmentResultsId = "assessment-results-id";
  static const String keyAssessmentVariableId = "assessment-variable-id";
  static const String keyAssessmentVariableName = "assessment-variable-name";
  static const String keyAssessmentSatisfactory = "assessment-satisfactory";
  static const String keyAssessmentMarkers = "assessment-markers";
  static const String keyPilotFlyingMarkers = "pilot-flying-markers";
  static const String keyPilotMonitoringMarkers = "pilot-monitoring-markers";
  static const String keyIsNotApplicable = "is-not-applicable";

  String id = Util.defaultStringIfNull;
  String assessmentResultsId = Util.defaultStringIfNull;
  String assessmentVariableId = Util.defaultStringIfNull;
  String assessmentVariableName = Util.defaultStringIfNull;
  String? assessmentSatisfactory;
  int? assessmentMarkers;
  int? pilotFlyingMarkers;
  int? pilotMonitoringMarkers;
  bool isNotApplicable = false;
  ValueNotifier<bool> isNotApplicableNotifier = ValueNotifier<bool>(false);

  AssessmentVariableResults.fromFirebase(Map<String, dynamic> map) {
    id = map[keyId];
    assessmentResultsId = map[keyAssessmentResultsId];
    assessmentVariableId = map[keyAssessmentVariableId];
    assessmentSatisfactory = map[keyAssessmentSatisfactory];
    assessmentMarkers = map[keyAssessmentMarkers];
    pilotFlyingMarkers = map[keyPilotFlyingMarkers];
    pilotMonitoringMarkers = map[keyPilotMonitoringMarkers];
    isNotApplicable = map[keyIsNotApplicable];
  }

  Map<String, dynamic> toFirebase() {
    return {
      keyId: id,
      keyAssessmentResultsId: assessmentResultsId,
      keyAssessmentVariableId: assessmentVariableId,
      keyAssessmentSatisfactory: assessmentSatisfactory,
      keyAssessmentMarkers: assessmentMarkers,
      keyPilotFlyingMarkers: pilotFlyingMarkers,
      keyPilotMonitoringMarkers: pilotMonitoringMarkers,
      keyIsNotApplicable: isNotApplicable,
    };
  }

  void reset() {
    assessmentSatisfactory = null;
    assessmentMarkers = null;
    pilotFlyingMarkers = null;
    pilotMonitoringMarkers = null;
  }

  void toggleIsNotApplicable() {
    isNotApplicable = !isNotApplicable;
    isNotApplicableNotifier.value = isNotApplicable;
  }

  @override
  String toString() {
    return "AssessmentVariableResults:"
      "id: $id, "
      "assessmentResultsId: $assessmentResultsId, "
      "assessmentVariableId: $assessmentVariableId, "
      "assessmentVariableName: $assessmentVariableName, "
      "assessmentSatisfactory: $assessmentSatisfactory, "
      "assessmentMarkers: $assessmentMarkers, "
      "pilotFlyingMarkers: $pilotFlyingMarkers, "
      "pilotMonitoringMarkers: $pilotMonitoringMarkers, "
      "isNotApplicable: $isNotApplicable";
  }
}