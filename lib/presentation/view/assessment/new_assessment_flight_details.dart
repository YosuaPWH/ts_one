
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/view/assessment/new_assessment_variables.dart';
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

  late Map<String, bool> assessmentFlightDetails1;
  late int assessmentFlightDetails1Count;
  late bool assessmentFlightDetails1Error;

  late bool _flightCrew2Enabled;
  late Map<String, bool> assessmentFlightDetails2;
  late int assessmentFlightDetails2Count;
  late bool assessmentFlightDetails2Error;

  late NewAssessment dataCandidate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    assessmentFlightDetails1 = {};
    assessmentFlightDetails1Count = 0;
    assessmentFlightDetails1Error = false;

    if(widget.dataCandidate.typeOfAssessment == NewAssessment.keyTypeOfAssessmentSimulator) {
      _flightCrew2Enabled = true;
    } else {
      _flightCrew2Enabled = false;
    }

    assessmentFlightDetails2 = {};
    assessmentFlightDetails2Count = 0;
    assessmentFlightDetails2Error = false;

    dataCandidate = widget.dataCandidate;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAssessmentFlightDetails();
    });

    super.initState();
  }

  void _getAssessmentFlightDetails() async {
    assessmentFlightDetails1 = await viewModel.getAllAssessmentFlightDetails();
    assessmentFlightDetails2 = await viewModel.getAllAssessmentFlightDetails();
  }

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!model.isLoading)
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // flight crew 1
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
                          DropdownButtonFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Training or Checking Details',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: NewAssessment.keySessionDetailsTraining,
                                child: Text(NewAssessment.keySessionDetailsTraining),
                              ),
                              DropdownMenuItem(
                                value: NewAssessment.keySessionDetailsCheck,
                                child: Text(NewAssessment.keySessionDetailsCheck),
                              ),
                              DropdownMenuItem(
                                value: NewAssessment.keySessionDetailsRetraining,
                                child: Text(NewAssessment.keySessionDetailsRetraining),
                              )
                            ],
                            validator: (value) {
                              if (value == null) {
                                return "Select one of the options available";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            value: dataCandidate.sessionDetails1,
                            onChanged: (value) {
                              setState(() {
                                dataCandidate.sessionDetails1 = value.toString();
                              });
                            },
                          ),
                          assessmentFlightDetails1Error
                          ? const Padding(
                            padding: EdgeInsets.only(left: 8.0, top: 16.0, bottom: 8.0),
                            child: Text(
                              "Select at least one option",
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                          : const SizedBox(),
                          Column(
                            children: assessmentFlightDetails1.keys
                                .map<Widget>(
                                  (item) => ListTileTheme(
                                contentPadding: const EdgeInsets.all(0),
                                child: CheckboxListTile(
                                  dense: true,
                                  value: assessmentFlightDetails1[item],
                                  onChanged: (newValue) {
                                    setState(() {
                                      assessmentFlightDetails1[item] = newValue!;

                                      if (!dataCandidate.assessmentFlightDetails1.flightDetails.contains(item)) {
                                        dataCandidate.assessmentFlightDetails1.flightDetails.add(item);
                                        assessmentFlightDetails1Count++;
                                      } else {
                                        dataCandidate.assessmentFlightDetails1.flightDetails.remove(item);
                                        assessmentFlightDetails1Count--;
                                      }

                                      if (assessmentFlightDetails1Count == 0) {
                                        setState(() {
                                          assessmentFlightDetails1Error = true;
                                        });
                                      } else {
                                        setState(() {
                                          assessmentFlightDetails1Error = false;
                                        });
                                      }
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
                          ),

                          // flight crew 2
                          _flightCrew2Enabled
                          ? const SizedBox()
                          : Column(
                            children: [
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
                              DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Training or Checking Details',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: NewAssessment.keySessionDetailsTraining,
                                    child: Text(NewAssessment.keySessionDetailsTraining),
                                  ),
                                  DropdownMenuItem(
                                    value: NewAssessment.keySessionDetailsCheck,
                                    child: Text(NewAssessment.keySessionDetailsCheck),
                                  ),
                                  DropdownMenuItem(
                                    value: NewAssessment.keySessionDetailsRetraining,
                                    child: Text(NewAssessment.keySessionDetailsRetraining),
                                  )
                                ],
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null) {
                                    return "Select one of the options available";
                                  }
                                  return null;
                                },
                                value: dataCandidate.sessionDetails2,
                                onChanged: (value) {
                                  setState(() {
                                    dataCandidate.sessionDetails2 = value.toString();
                                  });
                                },
                              ),
                              assessmentFlightDetails2Error
                                  ? const Padding(
                                padding: EdgeInsets.only(left: 8.0, top: 16.0, bottom: 8.0),
                                child: Text(
                                  "Select at least one option",
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                                  : const SizedBox(),
                              Column(
                                children: assessmentFlightDetails2.keys
                                    .map<Widget>(
                                      (item) => ListTileTheme(
                                    contentPadding: const EdgeInsets.all(0),
                                    child: CheckboxListTile(
                                      dense: true,
                                      value: assessmentFlightDetails2[item],
                                      onChanged: (newValue) {
                                        setState(() {
                                          assessmentFlightDetails2[item] = newValue!;

                                          if (!dataCandidate.assessmentFlightDetails2.flightDetails.contains(item)) {
                                            dataCandidate.assessmentFlightDetails2.flightDetails.add(item);
                                            assessmentFlightDetails2Count++;
                                          } else {
                                            dataCandidate.assessmentFlightDetails2.flightDetails.remove(item);
                                            assessmentFlightDetails2Count--;
                                          }

                                          if (assessmentFlightDetails2Count == 0) {
                                            setState(() {
                                              assessmentFlightDetails2Error = true;
                                            });
                                          } else {
                                            setState(() {
                                              assessmentFlightDetails2Error = false;
                                            });
                                          }
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
                              ),
                            ],
                          ),

                          ElevatedButton(
                            onPressed: () {
                              if (assessmentFlightDetails1Count == 0) {
                                assessmentFlightDetails1Error = true;
                              }
                              if (assessmentFlightDetails2Count == 0 && _flightCrew2Enabled) {
                                assessmentFlightDetails2Error = true;
                              }
                              if(_formKey.currentState!.validate() && !assessmentFlightDetails1Error && !assessmentFlightDetails2Error) {
                                Navigator.pushNamed(
                                    context,
                                    NamedRoute.newAssessmentVariables,
                                    arguments: dataCandidate
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                              backgroundColor: TsOneColor.primary,
                              foregroundColor: TsOneColor.primaryContainer,
                              surfaceTintColor: TsOneColor.primaryContainer,
                            ),
                            child: const Text(
                              "Next",
                              style: TextStyle(color: TsOneColor.onPrimary),
                            ),
                          )
                        ],
                      ),
                    )
                  else
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
