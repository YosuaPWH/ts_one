import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/data/assessments/assessment_variables.dart';
import 'package:ts_one/domain/assessment_repo.dart';
import 'package:ts_one/presentation/view_model/loading_viewmodel.dart';

import '../../data/assessments/assessment_flight_details.dart';

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

  Future<Map<String, bool>> getAllAssessmentFlightDetails() async {
    isLoading = true;
    Map<String, bool> listFlightDetails = {};
    try {
      AssessmentFlightDetails assessmentFlightDetails = await repo.getAllAssessmentFlightDetails();
      for (var element in assessmentFlightDetails.flightDetails) {
        listFlightDetails.addAll({element: false});
      }
      isLoading = false;
    } catch (e) {
      log("Exception on AssessmentViewModel: $e");
      isLoading = false;
    }
    return listFlightDetails;
  }

  Future<AssessmentPeriod> getAllFlightAssessmentVariablesFromLastPeriod() async {
    isLoading = true;
    AssessmentPeriod lastAssessmentPeriodData = AssessmentPeriod();
    try {
      List<AssessmentPeriod> assessmentPeriod = await repo.getAllAssessmentPeriods();
      String lastAssessmentPeriodId = assessmentPeriod.first.id;

      lastAssessmentPeriodData = await repo.getFlightAssessmentPeriodById(lastAssessmentPeriodId);
      isLoading = false;
    } catch (e) {
      log("Exception on getAllAssessmentVariablesFromLastPeriod function on Assessment View Model: $e");
      isLoading = false;
    }

    return lastAssessmentPeriodData;
  }

  Future<AssessmentPeriod> getAllHumanFactorAssessmentVariablesFromLastPeriod() async {
    isLoading = true;
    AssessmentPeriod lastAssessmentPeriodData = AssessmentPeriod();
    try {
      List<AssessmentPeriod> assessmentPeriod = await repo.getAllAssessmentPeriods();
      String lastAssessmentPeriodId = assessmentPeriod.first.id;

      lastAssessmentPeriodData = await repo.getHumanFactorAssessmentPeriodById(lastAssessmentPeriodId);
      isLoading = false;
    } catch (e) {
      debugPrint("Exception on getAllHumanFactorAssessmentVariablesFromLastPeriod function on Assessment ViewModel: $e");
      isLoading = false;
    }

    return lastAssessmentPeriodData;
  }

  Future<AssessmentPeriod> addAssessmentPeriod(AssessmentPeriod assessmentPeriodModel) async {
    isLoading = true;
    AssessmentPeriod assessmentPeriod = AssessmentPeriod();
    try {
      assessmentPeriod = await repo.addAssessmentPeriod(assessmentPeriodModel);
      isLoading = false;
    } catch (e) {
      print("Exception on AssessmentViewModel: $e");
      isLoading = false;
    }
    return assessmentPeriod;
  }

  Future<AssessmentPeriod> updateAssessmentPeriod(AssessmentPeriod assessmentPeriodModel) async {
    isLoading = true;
    AssessmentPeriod assessmentPeriod = AssessmentPeriod();
    try {
      assessmentPeriod = await repo.updateAssessmentPeriod(assessmentPeriodModel);
      isLoading = false;
    } catch (e) {
      print("Exception on AssessmentViewModel: $e");
      isLoading = false;
    }
    return assessmentPeriod;
  }

  Future<void> deleteAssessmentPeriodById(String id) async {
    isLoading = true;
    try {
      await repo.deleteAssessmentPeriodById(id);
      isLoading = false;
    } catch (e) {
      print("Exception on AssessmentViewModel: $e");
      isLoading = false;
    }
  }
}
