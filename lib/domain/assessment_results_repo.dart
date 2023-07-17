import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/util/util.dart';

abstract class AssessmentResultsRepo{
  Future<List<AssessmentResults>> addAssessmentResults(List<AssessmentResults> assessmentResults, NewAssessment newAssessment);

  Future<List<AssessmentResults>> getAssessmentResultsFilteredByDate(DateTime startDate, DateTime endDate);
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
        assessmentResult.id = "assessment-result-${assessmentResult.examinerStaffIDNo}-${Util.convertDateTimeDisplay(assessmentResult.date.toString())}";
        await _db!
            .collection(AssessmentResults.firebaseCollection)
            .doc(assessmentResult.id)
            .set(assessmentResult.toFirebase());

        for(var assessmentVariableResult in assessmentResult.variableResults) {
          assessmentVariableResult.id = "assessment-variable-result-${assessmentVariableResult.assessmentVariableId}-${assessmentResult.examinerStaffIDNo}-${Util.convertDateTimeDisplay(assessmentResult.date.toString())}";
          assessmentVariableResult.assessmentResultsId = assessmentResult.id;
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

  @override
  Future<List<AssessmentResults>> getAssessmentResultsFilteredByDate(DateTime startDate, DateTime endDate) async {
    List<AssessmentResults> assessmentResultsList = [];
    try{
      QuerySnapshot querySnapshot = await _db!
          .collection(AssessmentResults.firebaseCollection)
          .where(AssessmentResults.keyDate, isGreaterThanOrEqualTo: startDate)
          .where(AssessmentResults.keyDate, isLessThanOrEqualTo: endDate)
          .get();

      for(var doc in querySnapshot.docs){
        AssessmentResults assessmentResults = AssessmentResults.fromFirebase(doc.data() as Map<String, dynamic>);
        QuerySnapshot querySnapshot2 = await _db!
            .collection(AssessmentVariableResults.firebaseCollection)
            .where(AssessmentVariableResults.keyAssessmentResultsId, isEqualTo: assessmentResults.id)
            .get();
        for(var doc2 in querySnapshot2.docs){
          AssessmentVariableResults assessmentVariableResults = AssessmentVariableResults.fromFirebase(doc2.data() as Map<String, dynamic>);
          assessmentResults.variableResults.add(assessmentVariableResults);
        }
        assessmentResultsList.add(assessmentResults);
      }
    }
    catch(e){
      print(e.toString());
    }
    print(assessmentResultsList);
    return assessmentResultsList;
  }
}