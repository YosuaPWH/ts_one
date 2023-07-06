import 'package:flutter/material.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/data/assessments/assessment_variables.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/shared_components/dropdown_button_form_component.dart';
import 'package:ts_one/presentation/theme.dart';

class NewAssessmentOverallPerformance extends StatefulWidget {
  const NewAssessmentOverallPerformance({
    super.key,
    required this.dataAssessmentCandidate,
    required this.dataAssessmentFlightDetails,
    required this.dataAssessmentVariables,
  });

  final NewAssessment dataAssessmentCandidate;
  final AssessmentFlightDetails dataAssessmentFlightDetails;
  final Map<AssessmentVariables, Map<String, String>> dataAssessmentVariables;

  @override
  State<NewAssessmentOverallPerformance> createState() => _NewAssessmentOverallPerformanceState();
}

class _NewAssessmentOverallPerformanceState extends State<NewAssessmentOverallPerformance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Overall Performance",
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, NamedRoute.newAssessmentDeclaration, arguments: {
              'dataAssessmentCandidate': widget.dataAssessmentCandidate,
              'dataAssessmentFlightDetails': widget.dataAssessmentFlightDetails,
              'dataAssessmentVariablesFirst': widget.dataAssessmentVariables
            });
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormComponent(
              label: "Overall Performance",
              isDisabled: false,
              onValueChanged: (newValue) {},
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Notes / Comment / Recommendations"),
              ),
            ),
            const TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Notes / Comment/ Recommendations",
                hintStyle: TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
