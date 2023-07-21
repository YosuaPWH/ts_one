import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/data/users/users.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_results_viewmodel.dart';
import 'package:ts_one/presentation/view_model/assessment_viewmodel.dart';
import 'package:ts_one/presentation/view_model/user_viewmodel.dart';
import 'package:ts_one/util/util.dart';

class ResultAssessmentVariables extends StatefulWidget {
  const ResultAssessmentVariables({Key? key, required this.assessmentResults, required this.isCPTS}) : super(key: key);

  final AssessmentResults assessmentResults;
  final bool isCPTS;

  @override
  State<ResultAssessmentVariables> createState() => _ResultAssessmentVariablesState();
}

class _ResultAssessmentVariablesState extends State<ResultAssessmentVariables> {
  late AssessmentResultsViewModel viewModel;
  late UserViewModel userViewModel;
  late AssessmentResults _assessmentResults;
  bool isCPTS = false;
  late List<AssessmentVariableResults> assessmentVariableResults;
  late UserModel _instructor;
  late UserModel _examinee;
  late Map<String, dynamic> assessmentCategories;

  @override
  void initState() {
    viewModel = Provider.of<AssessmentResultsViewModel>(context, listen: false);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    assessmentVariableResults = [];
    _assessmentResults = widget.assessmentResults;
    assessmentCategories = {};
    _instructor = UserModel();
    _examinee = UserModel();
    isCPTS = widget.isCPTS;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInstructor();
      getExaminee();
      getAllResultAssessmentVariablesById(_assessmentResults.id);
    });

    super.initState();
  }

  void getInstructor() async {
    _instructor = await userViewModel.getUserByIDNo(_assessmentResults.instructorStaffIDNo.toString());
  }

  void getExaminee() async {
    _examinee = await userViewModel.getUserByIDNo(_assessmentResults.examinerStaffIDNo.toString());
  }

  void getAllResultAssessmentVariablesById(String idAssessment) async {
    assessmentVariableResults = await viewModel.getAssessmentVariableResult(idAssessment);

    for (var assessmentVariable in assessmentVariableResults) {
      if (!assessmentCategories.containsKey(assessmentVariable.assessmentVariableCategory)) {
        var typeAssessment = assessmentVariable.assessmentType;
        assessmentCategories.addAll({assessmentVariable.assessmentVariableCategory: typeAssessment});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentResultsViewModel>(builder: (_, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Results"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: model.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: _dataResultAssessment(),
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, NamedRoute.resultAssessmentOverall, arguments: {
                    "assessmentResults": _assessmentResults,
                    "isCPTS": isCPTS,
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: TsOneColor.primary,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Next",
                      style: TextStyle(color: TsOneColor.secondary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _dataResultAssessment() {
    List<Widget> dataWidgetResult = [];

    dataWidgetResult.add(
      Text(
        "Assessment Details",
        style: tsOneTextTheme.headlineLarge,
      ),
    );

    dataWidgetResult.add(Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date',
                style: TextStyle(color: TsOneColor.onSecondary),
              ),
              Text(
                'Instructor ID',
                style: TextStyle(color: TsOneColor.onSecondary),
              ),
              Text(
                'Instructor Name',
                style: TextStyle(color: TsOneColor.onSecondary),
              ),
              Text(
                'Examinee ID',
                style: TextStyle(color: TsOneColor.onSecondary),
              ),
              Text(
                'Examinee Name',
                style: TextStyle(color: TsOneColor.onSecondary),
              ),
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          const Column(
            children: [
              Text(
                ':',
                style: TextStyle(color: TsOneColor.onSecondary),
              ),
              Text(
                ':',
                style: TextStyle(color: TsOneColor.onSecondary),
              ),
              Text(
                ':',
                style: TextStyle(color: TsOneColor.onSecondary),
              ),
              Text(
                ':',
                style: TextStyle(color: TsOneColor.onSecondary),
              ),
              Text(
                ':',
                style: TextStyle(color: TsOneColor.onSecondary),
              ),
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Util.convertDateTimeDisplay(_assessmentResults.date.toString()),
                  style: const TextStyle(
                    color: TsOneColor.onSecondary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _assessmentResults.instructorStaffIDNo.toString(),
                  style: const TextStyle(color: TsOneColor.onSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _instructor.name,
                  style: const TextStyle(
                    color: TsOneColor.onSecondary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _assessmentResults.examinerStaffIDNo.toString(),
                  style: const TextStyle(color: TsOneColor.onSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _examinee.name,
                  style: const TextStyle(color: TsOneColor.onSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ));

    dataWidgetResult.add(
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Divider(
          color: TsOneColor.secondaryContainer,
        ),
      ),
    );

    dataWidgetResult.add(ListTile(
      contentPadding: const EdgeInsets.only(left: 0),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          _assessmentResults.sessionDetails,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Column(
        children: _assessmentResults.trainingCheckingDetails
            .map(
              (element) => Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Text(
                      '\u2022',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      element.trim(),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    ));

    dataWidgetResult.add(
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Divider(
          color: TsOneColor.secondaryContainer,
        ),
      ),
    );

    for (var dataCategory in assessmentCategories.keys) {
      List<AssessmentVariableResults> dataAssessmentVariableResults = [];
      for (var dataVariableResult in assessmentVariableResults) {
        if (dataVariableResult.assessmentVariableCategory == dataCategory) {
          dataAssessmentVariableResults.add(dataVariableResult);
        }
      }

      if (assessmentCategories[dataCategory] == "Satisfactory") {
        dataWidgetResult.add(_dataColumnAssessmentVariables(dataCategory, "Assessment", "Markers", dataAssessmentVariableResults));
      } else {
        dataWidgetResult.add(_dataColumnAssessmentVariables(dataCategory, "PF", "PM", dataAssessmentVariableResults));
      }
    }

    return dataWidgetResult;
  }

  Column _dataColumnAssessmentVariables(
      String dataCategory, String secondColumnName, String thirdColumnName, List<AssessmentVariableResults> dataAssessmentVariableResults) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            dataCategory,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        FittedBox(
          child: DataTable(
            columns: <DataColumn>[
              const DataColumn(
                label: Text(
                  "Subject",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                ),
              ),
              DataColumn(
                label: Text(
                  secondColumnName,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                ),
              ),
              DataColumn(
                label: Text(
                  thirdColumnName,
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                ),
              ),
            ],
            rows: _dataResultAssessmentVariables(dataAssessmentVariableResults),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  List<DataRow> _dataResultAssessmentVariables(List<AssessmentVariableResults> data) {
    List<DataRow> dataRows = [];
    for (var element in data) {
      if (element.assessmentType == "Satisfactory") {
        dataRows.add(dataRowAssessment(element.assessmentVariableName, element.assessmentSatisfactory == null ? "N/A" : element.assessmentSatisfactory!,
            element.assessmentMarkers == null ? "N/A" : element.assessmentMarkers!.toString()));
      } else {
        dataRows.add(dataRowAssessment(element.assessmentVariableName, element.pilotFlyingMarkers == null ? "N/A" : element.pilotFlyingMarkers!.toString(),
            element.pilotMonitoringMarkers == null ? "N/A" : element.pilotMonitoringMarkers!.toString()));
      }
    }
    return dataRows;
  }

  DataRow dataRowAssessment(String assessmentName, String data1, String data2) {
    return DataRow(cells: <DataCell>[
      DataCell(SizedBox(
        width: 200,
        child: Text(
          assessmentName,
        ),
      )),
      DataCell(
        Align(
          alignment: Alignment.center,
          child: Text(
            data1,
          ),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.center,
          child: Text(
            data2,
          ),
        ),
      ),
    ]);
  }
}
