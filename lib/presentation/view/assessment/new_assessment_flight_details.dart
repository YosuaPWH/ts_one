import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/presentation/view_model/assessment_viewmodel.dart';

import '../../theme.dart';

class NewAssessmentFlightDetails extends StatefulWidget {
  const NewAssessmentFlightDetails({Key? key, required this.dataCandidate})
      : super(key: key);

  final NewAssessment dataCandidate;

  @override
  State<NewAssessmentFlightDetails> createState() =>
      _NewAssessmentFlightDetailsState();
}

class _NewAssessmentFlightDetailsState
    extends State<NewAssessmentFlightDetails> {
  late AssessmentViewModel viewModel;
  late Map<String, bool> assessmentFlightDetails;

  @override
  void initState() {
    viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    assessmentFlightDetails = {};

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAssessmentFlightDetails();
    });

    super.initState();
  }

  void _getAssessmentFlightDetails() async {
    assessmentFlightDetails = await viewModel.getAllAssessmentFlightDetails();
  }

  String trainingOrCheckingValue = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentViewModel>(
      builder: (_, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Training/Checking Details",
              style: tsOneTextTheme.headlineMedium,
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TsOneColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: DropdownButton(
                      style: const TextStyle(color: TsOneColor.secondary),
                      underline: Container(),
                      dropdownColor: tsOneColorScheme.secondary,
                      isExpanded: true,
                      selectedItemBuilder: (BuildContext context) {
                        return <String>["Training", "Checking"]
                            .map<Widget>((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList();
                      },
                      icon: const Icon(
                        Icons.expand_more,
                        color: TsOneColor.secondary,
                      ),
                      value: trainingOrCheckingValue != ""
                          ? trainingOrCheckingValue
                          : "Training",
                      onChanged: (value) {
                        setState(() {
                          trainingOrCheckingValue = value.toString();
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'Training',
                          child: Text(
                            'Training',
                            style: TextStyle(color: TsOneColor.primary),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Checking',
                          child: Text(
                            'Checking',
                            style: TextStyle(color: TsOneColor.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!model.isLoading)
                    Column(
                      children: assessmentFlightDetails.keys
                          .map<Widget>(
                            (item) => ListTileTheme(
                              contentPadding: const EdgeInsets.all(0),
                              child: CheckboxListTile(
                                value: assessmentFlightDetails[item],
                                onChanged: (newValue) {
                                  setState(() {
                                    assessmentFlightDetails[item] = newValue!;
                                  });
                                },
                                title: Text(
                                  item,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          )
                          .toList(),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
