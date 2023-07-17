import 'package:ts_one/data/assessments/assessment_results.dart';
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
}