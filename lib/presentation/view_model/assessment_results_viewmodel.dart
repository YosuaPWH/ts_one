import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/domain/assessment_results_repo.dart';
import 'package:ts_one/presentation/view_model/loading_viewmodel.dart';

class AssessmentResultsViewModel extends LoadingViewModel{
  AssessmentResultsViewModel({required this.repo});

  final AssessmentResultsRepo repo;

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
}