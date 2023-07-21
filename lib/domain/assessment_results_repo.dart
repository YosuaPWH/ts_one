import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/util/util.dart';

abstract class AssessmentResultsRepo{
  Future<List<AssessmentResults>> addAssessmentResults(List<AssessmentResults> assessmentResults, NewAssessment newAssessment);

  Future<List<AssessmentResults>> getAllAssessmentResults();

  Future<List<AssessmentResults>> getAssessmentResultsFilteredByDate(DateTime startDate, DateTime endDate);

  Future<List<AssessmentResults>> getAssessmentResultsByCurrentUserNotConfirm();

  Future<List<AssessmentVariableResults>> getAssessmentVariableResult(String idAssessment);

  Future<void> updateAssessmentResultForExaminee(AssessmentResults assessmentResults);
}

class AssessmentResultsRepoImpl implements AssessmentResultsRepo {
  AssessmentResultsRepoImpl({
    FirebaseFirestore? db, UserPreferences? userPreferences
  }) : _db = db ?? FirebaseFirestore.instance, _userPreferences = userPreferences;

  final FirebaseFirestore? _db;
  final UserPreferences? _userPreferences;

  @override
  Future<List<AssessmentResults>> addAssessmentResults
      (List<AssessmentResults> assessmentResults, NewAssessment newAssessment) async {
    List<AssessmentResults> assessmentResultsList = AssessmentResults.extractDataFromNewAssessment(newAssessment);
    try{
      for(var assessmentResult in assessmentResultsList){
        assessmentResult.id = "assessment-result-${assessmentResult.examineeStaffIDNo}-${Util.convertDateTimeDisplay(assessmentResult.date.toString())}";
        await _db!
            .collection(AssessmentResults.firebaseCollection)
            .doc(assessmentResult.id)
            .set(assessmentResult.toFirebase());

        for(var assessmentVariableResult in assessmentResult.variableResults) {
          assessmentVariableResult.id = "assessment-variable-result-${assessmentVariableResult.assessmentVariableId}-${assessmentResult.examineeStaffIDNo}-${Util.convertDateTimeDisplay(assessmentResult.date.toString())}";
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
  Future<List<AssessmentResults>> getAllAssessmentResults() async {
    List<AssessmentResults> assessmentResultsList = [];
    try{
      QuerySnapshot querySnapshot = await _db!
          .collection(AssessmentResults.firebaseCollection)
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
    return assessmentResultsList;
  }

  @override
  Future<List<AssessmentResults>> getAssessmentResultsByCurrentUserNotConfirm() async {
    final userPreferences = _userPreferences;
    final userId = userPreferences!.getIDNo();
    int dummyUserId = 11720032;
    List<AssessmentResults> assessmentResults = [];

    try {
      await _db!
          .collection(AssessmentResults.firebaseCollection)
          .where(AssessmentResults.keyExamineeStaffIDNo, isEqualTo: dummyUserId)
          .where(AssessmentResults.keyConfirmedByExaminer, isEqualTo: false)
          .get()
          .then((value) {
        for (var element in value.docs) {
          assessmentResults.add(AssessmentResults.fromFirebase(element.data()));
        }
      });

    } catch (e) {
      log("Exception in AssessmentResultRepo on getAssessmentResultsByCurrentUserNotConfirm: $e");
    }
    return assessmentResults;
  }

  int assessmentVariableCollectionComparator(DocumentSnapshot a,
      DocumentSnapshot b) {
    final idA = int.parse(a.id
        .split('-')[4]); // Extract the numerical part from the ID of document A
    final idB = int.parse(b.id
        .split('-')[4]); // Extract the numerical part from the ID of document B

    return idA.compareTo(idB);
  }

  @override
  Future<List<AssessmentVariableResults>> getAssessmentVariableResult(String idAssessment) async {
    List<AssessmentVariableResults> assessmentVariableResults = [];

    try {
      final documents = await _db!
          .collection(AssessmentVariableResults.firebaseCollection)
          .where(AssessmentVariableResults.keyAssessmentResultsId, isEqualTo: idAssessment)
          .get()
          .then((value) {
        return value.docs;
      });

      documents.sort(assessmentVariableCollectionComparator);

      for (var element in documents) {
        assessmentVariableResults.add(AssessmentVariableResults.fromFirebase(
            element.data()));
      }

    } catch (e) {
      log("Exception in AssessmentResultRepo on getAssessmentVariableResult: $e");
    }

    return assessmentVariableResults;
  }

  @override
  Future<void> updateAssessmentResultForExaminee(AssessmentResults assessmentResults) async {
    try {
      await _db!
          .collection(AssessmentResults.firebaseCollection)
          .doc(assessmentResults.id)
          .update(assessmentResults.toFirebase());
      log("BERHASIL: ${assessmentResults.id}");

    } catch (e) {
      log("Exception in AssessmentResultRepo on updateAssessmentResultForExaminee: $e");
    }
  }
}