import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/domain/assessment_repo.dart';
import 'package:ts_one/presentation/view_model/loading_viewmodel.dart';

class AssessmentViewModel extends LoadingViewModel {
  AssessmentViewModel({required this.repo});

  final AssessmentRepo repo;

  Future<List<AssessmentPeriodModel>> getAllAssessmentPeriod() async {
    isLoading = true;
    List<AssessmentPeriodModel> assessmentPeriods = [];
    try {
      assessmentPeriods = await repo.getAllAssessmentPeriods();
      isLoading = false;
    } catch (e) {
      print("Exception on AssessmentViewModel: $e");
      isLoading = false;
    }
    return assessmentPeriods;
  }

  Future<AssessmentPeriodModel> getAssessmentPeriodById(String id) async {
    isLoading = true;
    AssessmentPeriodModel assessmentPeriod = AssessmentPeriodModel();
    try {
      assessmentPeriod = await repo.getAssessmentPeriodById(id);
      isLoading = false;
    } catch (e) {
      print("Exception on AssessmentViewModel: $e");
      isLoading = false;
    }
    return assessmentPeriod;
  }
}