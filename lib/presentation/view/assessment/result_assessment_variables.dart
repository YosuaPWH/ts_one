import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_results_viewmodel.dart';
import 'package:ts_one/presentation/view_model/assessment_viewmodel.dart';

class ResultAssessmentVariables extends StatefulWidget {
  const ResultAssessmentVariables({Key? key, required this.assessmentResults}) : super(key: key);

  final AssessmentResults assessmentResults;

  @override
  State<ResultAssessmentVariables> createState() => _ResultAssessmentVariablesState();
}

class _ResultAssessmentVariablesState extends State<ResultAssessmentVariables> {
  late AssessmentResultsViewModel viewModel;
  late List<AssessmentVariableResults> assessmentVariableResults;
  late String idAssessment;
  late Map<String, dynamic> assessmentCategories;

  @override
  void initState() {
    viewModel = Provider.of<AssessmentResultsViewModel>(context, listen: false);
    assessmentVariableResults = [];
    idAssessment = widget.assessmentResults.id;
    assessmentCategories = {};

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllResultAssessmentVariablesById(idAssessment);
    });

    super.initState();
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
                  Navigator.pushNamed(context, NamedRoute.resultAssessmentOverall, arguments: widget.assessmentResults);
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

    for (var dataCategory in assessmentCategories.keys) {
      List<AssessmentVariableResults> dataAssessmentVariableResults = [];
      for (var dataVariableResult in assessmentVariableResults) {
        if (dataVariableResult.assessmentVariableCategory == dataCategory) {
          dataAssessmentVariableResults.add(dataVariableResult);
        }
      }

      if (assessmentCategories[dataCategory] == "Satisfactory") {
        dataWidgetResult
            .add(_dataColumnAssessmentVariables(dataCategory, "Assessment", "Markers", dataAssessmentVariableResults));
      } else {
        dataWidgetResult.add(_dataColumnAssessmentVariables(dataCategory, "PF", "PM", dataAssessmentVariableResults));
      }
    }

    return dataWidgetResult;
  }

  Column _dataColumnAssessmentVariables(String dataCategory, String secondColumnName, String thirdColumnName,
      List<AssessmentVariableResults> dataAssessmentVariableResults) {
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
        dataRows.add(dada(
            element.assessmentVariableName, element.assessmentSatisfactory!, element.assessmentMarkers.toString()));
      } else {
        dataRows.add(dada(element.assessmentVariableName, element.pilotFlyingMarkers.toString(),
            element.pilotMonitoringMarkers.toString()));
      }
    }
    return dataRows;
  }

  DataRow dada(String assessmentName, String data1, String data2) {
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
