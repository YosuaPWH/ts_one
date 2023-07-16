import 'package:flutter/material.dart';
import 'package:googleapis/transcoder/v1.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_viewmodel.dart';

class ResultAssessmentVariables extends StatefulWidget {
  const ResultAssessmentVariables({super.key});

  @override
  State<ResultAssessmentVariables> createState() => _ResultAssessmentVariablesState();
}

class _ResultAssessmentVariablesState extends State<ResultAssessmentVariables> {
  late AssessmentViewModel viewModel;
  late List<AssessmentVariableResults> assessmentVariableResults;

  @override
  void initState() {
    viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    assessmentVariableResults = [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllResultAssessmentVariablesById();
    });

    super.initState();
  }

  void getAllResultAssessmentVariablesById() async {
    assessmentVariableResults = await viewModel.getAssessmentVariableResultNotConfirmedByExamine();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentViewModel>(
      builder: (_, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Results"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: model.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
              children: [
                FittedBox(
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          "Subject",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Assessment",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Markers",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: _dataResultAssessmentVariables(assessmentVariableResults),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, NamedRoute.resultAssessmentOverall);
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
              ],
            ),
          ),
        );
      }
    );
  }

  List<DataRow> _dataResultAssessmentVariables(List<AssessmentVariableResults> data) {
    List<DataRow> dataRows = [];
    for (var element in data) {
      dataRows.add(
        DataRow(cells: <DataCell>[
          DataCell(Text(element.assessmentVariableName)),
          DataCell(Text(element.assessmentSatisfactory!)),
          DataCell(Text(element.assessmentMarkers.toString())),
        ]),
      );
    }
    return dataRows;
  }
}
