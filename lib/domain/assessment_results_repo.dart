import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';

abstract class AssessmentResultsRepo{
  Future<List<AssessmentResults>> addAssessmentResults(List<AssessmentResults> assessmentResults, NewAssessment newAssessment);
}

class AssessmentResultsRepoImpl implements AssessmentResultsRepo {
  AssessmentResultsRepoImpl({
    FirebaseFirestore? db,
  }) : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore? _db;

  @override
  Future<List<AssessmentResults>> addAssessmentResults
      (List<AssessmentResults> assessmentResults, NewAssessment newAssessment) async {
    List<AssessmentResults> assessmentResultsList = AssessmentResults.extractDataFromNewAssessment(newAssessment);
    try{
      for(var assessmentResult in assessmentResultsList){
        assessmentResult.id = "assessment-result-${assessmentResult.examinerStaffIDNo}-${assessmentResult.date}";
        await _db!
            .collection(AssessmentResults.firebaseCollection)
            .doc(assessmentResult.id)
            .set(assessmentResult.toFirebase());

        for(var assessmentVariableResult in assessmentResult.variableResults) {
          assessmentVariableResult.id = "assessment-variable-result-${assessmentVariableResult.assessmentVariableId}-${assessmentResult.examinerStaffIDNo}-${assessmentResult.date}";
          await _db!
              .collection(AssessmentVariableResults.firebaseCollection)
              .doc(assessmentVariableResult.id)
              .set(assessmentVariableResult.toFirebase());
        }
      }
    }
    catch(e){
      print(e.toString());
    }
    return assessmentResultsList;
  }
}