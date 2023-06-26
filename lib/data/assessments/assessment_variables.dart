import 'package:flutter/cupertino.dart';

class AssessmentVariablesModel with ChangeNotifier {
  AssessmentVariablesModel({
    this.id = "",
    this.assessmentPeriodId = "",
    this.category = "",
    this.name = "",
    this.typeOfAssessment = "",
  });

  String id = "";
  String assessmentPeriodId = "";
  String category = "";
  String name = "";
  String typeOfAssessment = "";

  // collection name in firebase
  static String firebaseCollection = "assessment_variables";

  // all the keys for the map stored in firebase
  static String keyId = "id";
  static String keyAssessmentPeriodId = "assessment-period-id";
  static String keyCategory = "category";
  static String keyName = "name";
  static String keyTypeOfAssessment = "type-of-assessment";

  AssessmentVariablesModel.fromFirebase(Map<String, dynamic> map) {
    id = map[keyId];
    assessmentPeriodId = map[keyAssessmentPeriodId];
    category = map[keyCategory];
    name = map[keyName];
    typeOfAssessment = map[keyTypeOfAssessment];
  }

  Map<String, dynamic> toMap() {
    return {
      keyId: id,
      keyAssessmentPeriodId: assessmentPeriodId,
      keyCategory: category,
      keyName: name,
      keyTypeOfAssessment: typeOfAssessment,
    };
  }

  @override
  String toString() {
    return 'AssessmentVariablesModel{id: $id, assessmentPeriodId: $assessmentPeriodId, category: $category, name: $name, typeOfAssessment: $typeOfAssessment}';
  }
}