import 'package:flutter/material.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:flutter/foundation.dart';
import 'package:ts_one/presentation/theme.dart';
import '../../../data/assessments/assessment_variables.dart';

class NewAssessmentVariablesSecond extends StatefulWidget {
  const NewAssessmentVariablesSecond(
      {super.key,
      required this.dataAssessmentFlightDetails,
      required this.dataCandidate,
      required this.dataAssessmentVariables});

  final AssessmentFlightDetails dataAssessmentFlightDetails;
  final NewAssessment dataCandidate;
  final Map<AssessmentVariables, Map<String, String>> dataAssessmentVariables;

  @override
  State<NewAssessmentVariablesSecond> createState() =>
      _NewAssessmentVariablesSecondState();
}

class _NewAssessmentVariablesSecondState
    extends State<NewAssessmentVariablesSecond> {
  @override
  Widget build(BuildContext context) {
    debugPrint("flightDetails: ${widget.dataAssessmentFlightDetails}");
    debugPrint("flightDetails: ${widget.dataCandidate}");
    debugPrint("flightDetails: ${widget.dataAssessmentVariables}");

    return Scaffold(
        appBar: AppBar(
          title: const Text("New Assessment"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      ExpansionTile(
                        title: Text("Aircraft System/Procedures"),
                        backgroundColor: TsOneColor.primary,
                        collapsedBackgroundColor: TsOneColor.surface,
                        textColor: TsOneColor.onPrimary,
                        collapsedTextColor: TsOneColor.onSecondary,
                        iconColor: TsOneColor.onPrimary,
                        collapsedIconColor: TsOneColor.onSecondary,
                        collapsedShape: RoundedRectangleBorder(
                          // side: BorderSide(co)
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
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
              )
            ],
          ),
        ));
  }
}
