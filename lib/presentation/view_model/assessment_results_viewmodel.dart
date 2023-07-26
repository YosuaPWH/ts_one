import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/domain/assessment_results_repo.dart';
import 'package:ts_one/presentation/view_model/loading_viewmodel.dart';

class AssessmentResultsViewModel extends LoadingViewModel{
  AssessmentResultsViewModel({required this.repo});

  final AssessmentResultsRepo repo;
  bool isAllAssessmentLoaded = false;
  List<AssessmentResults> allAssessmentResults = [];
  AssessmentResults? lastAssessment;

  Future<List<AssessmentResults>> addAssessmentResults(List<AssessmentResults> assessmentResults, NewAssessment newAssessment) async {
    isLoading = true;
    List<AssessmentResults> assessmentResultsList = [];
    try{
      assessmentResultsList = await repo.addAssessmentResults(assessmentResults, newAssessment);
      isLoading = false;
    }
    catch(e){
      print("Exception on AssessmentResultsViewModel: $e");
      isLoading = false;
    }
    return assessmentResultsList;
  }

  Future<List<AssessmentResults>> getAllAssessmentResults() async {
    isLoading = true;
    List<AssessmentResults> assessmentResultsList = [];
    try{
      assessmentResultsList = await repo.getAllAssessmentResults();
      isLoading = false;
    }
    catch(e){
      print("Exception on AssessmentResultsViewModel: $e");
      isLoading = false;
    }
    return assessmentResultsList;
  }

  Future<List<AssessmentResults>> getAssessmentResultsFilteredByDate(DateTime startDate, DateTime endDate) async {
    isLoading = true;
    List<AssessmentResults> assessmentResultsList = [];
    try{
      assessmentResultsList = await repo.getAssessmentResultsFilteredByDate(startDate, endDate);
      isLoading = false;
    }
    catch(e){
      print("Exception on AssessmentResultsViewModel: $e");
      isLoading = false;
    }
    return assessmentResultsList;
  }

  Future<List<AssessmentResults>> getAssessmentResultsByCurrentUserNotConfirm() async {
    isLoading = true;
    List<AssessmentResults> assessmentResults = [];
    try {
      assessmentResults = await repo.getAssessmentResultsByCurrentUserNotConfirm();
      isLoading = false;
    }
    catch(e){
      print("Exception on AssessmentResultsViewModel: $e");
      isLoading = false;
    }
    return assessmentResults;
  }

  Future<List<AssessmentResults>> getAssessmentResultsNotConfirmByCPTS() async {
    isLoading = true;
    List<AssessmentResults> assessmentResults = [];
    try {
      assessmentResults = await repo.getAssessmentResultsNotConfirmByCPTS();
      isLoading = false;
    }
    catch(e){
      print("Exception on AssessmentResultsViewModel: $e");
      isLoading = false;
    }
    return assessmentResults;
  }

  Future<List<AssessmentVariableResults>> getAssessmentVariableResult(String idAssessment) async {
    isLoading = true;
    List<AssessmentVariableResults> assessmentVariableResults = [];
    try {
      assessmentVariableResults = await repo.getAssessmentVariableResult(idAssessment);
      isLoading = false;
    }
    catch(e){
      print("Exception on AssessmentResultsViewModel: $e");
      isLoading = false;
    }
    return assessmentVariableResults;
  }

  Future<void> updateAssessmentResultForExaminee(AssessmentResults assessmentResults) async {
    isLoading = true;
    try {
      await repo.updateAssessmentResultForExaminee(assessmentResults);
      isLoading = false;
    }
    catch(e){
      print("Exception on AssessmentResultsViewModel: $e");
      isLoading = false;
    }
  }

  Future<List<AssessmentResults>> searchAssessmentResultsBasedOnName(String searchName, int searchLimit) async {
    isLoading = true;
    List<AssessmentResults> assessmentResultsList = [];
    try {
      assessmentResultsList = await repo.searchAssessmentResultsBasedOnName(searchName, searchLimit);
      isAllAssessmentLoaded = false;
      isLoading = false;
    } catch (e) {
      print("Exception on AssessmentResultsViewModel: $e");
      isLoading = false;
    }
    return assessmentResultsList;
  }

  Future<List<AssessmentResults>> getAllAssessmentResultsPaginated(int limit, DateTime? filterStart, DateTime? filterEnd) async {
    isLoading = true;

    try {
      if (filterStart != null && filterEnd != null) {
        allAssessmentResults = [];
        lastAssessment == null;
        isAllAssessmentLoaded = false;
      }

      if (isAllAssessmentLoaded) {
        isLoading = false;
        return allAssessmentResults;
      }

      final List<AssessmentResults> newAssessmentResults = await repo.getAllAssessmentResultsPaginated(limit, lastAssessment, filterStart, filterEnd);
      allAssessmentResults.addAll(newAssessmentResults);

      if (newAssessmentResults.isNotEmpty) {
        lastAssessment = newAssessmentResults[newAssessmentResults.length - 1];
      } else {
        lastAssessment = null;
        isAllAssessmentLoaded = true;
      }

      isLoading = false;
    } catch (e) {
      print("Exception on AssessmentResultsViewModel: $e");
      isLoading = false;
    }

    return allAssessmentResults;
  }

  Future<String> makePDFSimulator(AssessmentResults assessmentResults) async {
    isLoading = true;
    String message = "";
    try {
      message = await repo.makePDFSimulator(assessmentResults);
    } catch (e) {
      print("Exception on AssessmentResultsViewModel: $e");
      isLoading = false;
    }
    return message;
  }
}