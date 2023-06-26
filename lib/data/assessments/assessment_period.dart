import 'package:flutter/cupertino.dart';
import 'package:ts_one/data/assessments/assessment_variables.dart';

class AssessmentPeriodModel with ChangeNotifier{
  AssessmentPeriodModel({
    this.id = "",
  });

  String id = "";
  DateTime period = DateTime.now();
  List<AssessmentVariablesModel> assessmentVariables = [];

  // collection name in firebase
  static String firebaseCollection = "assessment-periods";

  // all the keys for the map stored in firebase
  static String keyId = "id";
  static String keyPeriod = "period";

  AssessmentPeriodModel.fromFirebase(Map<String, dynamic> map) {
    id = map[keyId];
    period = DateTime.fromMillisecondsSinceEpoch(map[keyPeriod].seconds * 1000);
  }

  Map<String, dynamic> toMap() {
    return {
      keyId: id,
      keyPeriod: period,
    };
  }

  void addAllAssessmentVariables(List<AssessmentVariablesModel> allAssessmentVariables) {
    assessmentVariables.addAll(allAssessmentVariables);
    notifyListeners();
  }

  @override
  String toString() {
    return 'AssessmentPeriodModel{id: $id, period: $period}';
  }
}