import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/domain/assessment_repo.dart';
import 'package:ts_one/presentation/view_model/loading_viewmodel.dart';

class AssessmentViewModel extends LoadingViewModel {
  AssessmentViewModel({required this.repo});

  final AssessmentRepo repo;

  Future<List<AssessmentPeriod>> getAllAssessmentPeriod() async {
    isLoading = true;
    List<AssessmentPeriod> assessmentPeriods = [];
    try {
      assessmentPeriods = await repo.getAllAssessmentPeriods();
      isLoading = false;
    } catch (e) {
      print("Exception on AssessmentViewModel: $e");
      isLoading = false;
    }
    return assessmentPeriods;
  }

  Future<AssessmentPeriod> getAssessmentPeriodById(String id) async {
    isLoading = true;
    AssessmentPeriod assessmentPeriod = AssessmentPeriod();
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