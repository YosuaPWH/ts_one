import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/data/assessments/assessment_variables.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/shared_components/dropdown_button_form_component.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_viewmodel.dart';

class NewAssessmentOverallPerformance extends StatefulWidget {
  const NewAssessmentOverallPerformance({
    super.key,
    required this.dataCandidate,
  });

  final NewAssessment dataCandidate;

  @override
  State<NewAssessmentOverallPerformance> createState() => _NewAssessmentOverallPerformanceState();
}

class _NewAssessmentOverallPerformanceState extends State<NewAssessmentOverallPerformance> {
  late AssessmentViewModel viewModel;
  late NewAssessment _newAssessment;

  @override
  void initState() {
    viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    _newAssessment = widget.dataCandidate;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      calculateOverallPerformance();
    });

    super.initState();
  }

  void calculateOverallPerformance() {
    _newAssessment.setOverallPerformance1();
    _newAssessment.setOverallPerformance2();
    print("Overall Performance 1: ${_newAssessment.overallPerformance1}");
    print("Overall Performance 2: ${_newAssessment.overallPerformance2}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Overall Performance",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Flight Crew 1
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Flight Crew 1',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintMaxLines: 1,
                      label: Text(
                        "Overall Performance",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )),
                  value: _newAssessment.overallPerformance1.round(),
                  items: AssessmentVariables.markerList
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _newAssessment.overallPerformance1 = value as double;
                    });
                  },
                ),
              ),
              const TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Notes / Comment / Recommendations",
                  hintStyle: TextStyle(fontSize: 12),
                ),
              ),

              // flight crew 2
              const Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Flight Crew 2',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintMaxLines: 1,
                      label: Text(
                        "Overall Performance",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )),
                  value: _newAssessment.overallPerformance2.round(),
                  items: AssessmentVariables.markerList
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _newAssessment.overallPerformance2 = value as double;
                    });
                  },
                ),
              ),
              const TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Notes / Comment / Recommendations",
                  hintStyle: TextStyle(fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context,
                        NamedRoute.newAssessmentDeclaration,
                        arguments: _newAssessment
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: TsOneColor.primary),
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
        ),
      ),
    );
  }
}
