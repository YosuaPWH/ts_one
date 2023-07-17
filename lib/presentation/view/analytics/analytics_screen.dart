import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_results_viewmodel.dart';
import 'package:ts_one/util/util.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late AssessmentResultsViewModel viewModel;
  late DateTime nowWithoutTime;
  late DateTime startDate;
  late DateTime endDate;
  late List<AssessmentResults> assessmentResults;
  late List<AssessmentResults> assessmentResultsFilteredByDate;

  @override
  void initState() {
    viewModel = Provider.of<AssessmentResultsViewModel>(context, listen: false);
    nowWithoutTime = Util.getCurrentDateWithoutTime();
    startDate = Util.defaultDateIfNull;
    endDate = nowWithoutTime;
    assessmentResults = [];
    assessmentResultsFilteredByDate = [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllAssessmentResultsFromRemote();
    });

    super.initState();
  }

  void getAllAssessmentResultsFromRemote() {
    viewModel.getAllAssessmentResults().then((value) {
      setState(() {
        assessmentResults = value;
      });
      filterAssessmentResultsByDate();
    });
  }

  void filterAssessmentResultsByDate() async {
    assessmentResultsFilteredByDate.clear();
    for (AssessmentResults assessmentResult in assessmentResults) {
      if (assessmentResult.date.isAfter(startDate) &&
          assessmentResult.date.isBefore(endDate) ||
          assessmentResult.date.isAtSameMomentAs(startDate) ||
          assessmentResult.date.isAtSameMomentAs(endDate)
      ) {
        assessmentResultsFilteredByDate.add(assessmentResult);
      }
    }
    setState(() {
      assessmentResultsFilteredByDate = assessmentResultsFilteredByDate;
    });
  }

  void _selectStartingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate == Util.defaultDateIfNull ? nowWithoutTime : startDate,
      firstDate: DateTime(1999),
      lastDate: nowWithoutTime,
      helpText: "Select first date",
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
      filterAssessmentResultsByDate();
    }
  }

  void _selectEndingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(1999),
      lastDate: nowWithoutTime,
      helpText: "Select last date",
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
      filterAssessmentResultsByDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentResultsViewModel>(
      builder: (_, model, child) {
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Analytics",
                        style: tsOneTextTheme.headlineLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Start Date',
                                focusColor: TsOneColor.primary,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                text: Util.convertDateTimeDisplay(startDate.toString(), "dd MMM yyyy"),
                              ),
                              onTap: () {
                                _selectStartingDate(context);
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          const Expanded(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                "- to -",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'End Date',
                                focusColor: TsOneColor.primary,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                text: Util.convertDateTimeDisplay(endDate.toString(), "dd MMM yyyy"),
                              ),
                              onTap: () {
                                _selectEndingDate(context);
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          /*
                          Expanded(
                            flex: 2,
                            child: IconButton(
                                onPressed: () {
                                  getAllAssessmentResults();
                                },
                                icon: const Icon(Icons.search)
                            ),
                          )
                           */
                        ],
                      ),
                    ),
                    model.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Text("Currently showing analytics of ${assessmentResultsFilteredByDate.length} assessment results from "
                              "${Util.convertDateTimeDisplay(startDate.toString(), "dd MMM yyyy")} to "
                              "${Util.convertDateTimeDisplay(endDate.toString(), "dd MMM yyyy")}."),
                          for (AssessmentResults assessmentResult in assessmentResultsFilteredByDate)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        assessmentResult.id,
                                        style: tsOneTextTheme.headlineMedium,
                                      ),
                                      Text(
                                        "Date: ${Util.convertDateTimeDisplay(assessmentResult.date.toString(), "dd MMM yyyy")}",
                                        style: tsOneTextTheme.bodySmall,
                                      ),
                                      Text(
                                        "Examiner Staff ID: ${assessmentResult.examinerStaffIDNo}",
                                        style: tsOneTextTheme.bodySmall,
                                      ),
                                      Text(
                                        "Assessment variable results length: ${assessmentResult.variableResults.length}",
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
