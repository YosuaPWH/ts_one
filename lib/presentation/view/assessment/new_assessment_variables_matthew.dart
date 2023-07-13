import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';

import '../../../data/assessments/assessment_variables.dart';
import '../../../data/assessments/new_assessment.dart';
import '../../view_model/assessment_viewmodel.dart';

class NewAssessmentVariablesMatthew extends StatefulWidget {
  const NewAssessmentVariablesMatthew({Key? key, required this.dataCandidate}) : super(key: key);

  final NewAssessment dataCandidate;

  @override
  State<NewAssessmentVariablesMatthew> createState() => _NewAssessmentVariablesMatthewState();
}

class _NewAssessmentVariablesMatthewState extends State<NewAssessmentVariablesMatthew> {
  late AssessmentViewModel viewModel;
  late AssessmentPeriod dataAssessmentPeriod;
  late NewAssessment _newAssessment;
  late List<AssessmentVariables> assessmentVariables;
  late List<String> assessmentCategories;
  late List<String> manualAssessmentCategories;
  late List<Map<String, dynamic>> inputs1;
  late List<Map<String, dynamic>> inputs2;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    _newAssessment = widget.dataCandidate;
    _newAssessment.assessmentVariablesFlights1 = [];
    _newAssessment.assessmentVariablesFlights2 = [];
    dataAssessmentPeriod = AssessmentPeriod();
    assessmentVariables = [];
    assessmentCategories = [];
    manualAssessmentCategories = AssessmentVariables.aircraftSystemCategory;
    inputs1 = [];
    inputs2 = [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllAssessment();
    });

    super.initState();
  }

  void getAllAssessment() async {
    assessmentVariables.clear();
    assessmentCategories.clear();
    _newAssessment.assessmentVariablesFlights1.clear();
    _newAssessment.assessmentVariablesFlights2.clear();

    dataAssessmentPeriod = await viewModel.getAllFlightAssessmentVariablesFromLastPeriod();

    for (var assessmentVariable in dataAssessmentPeriod.assessmentVariables) {
      if (!assessmentCategories.contains(assessmentVariable.category)) {
        assessmentCategories.add(assessmentVariable.category);
      }
      assessmentVariables.add(assessmentVariable);

      _newAssessment.assessmentVariablesFlights1.add(AssessmentVariableResults(
        assessmentVariableId: assessmentVariable.id,
        assessmentVariableName: assessmentVariable.name,
      ));
      _newAssessment.assessmentVariablesFlights2.add(AssessmentVariableResults(
        assessmentVariableId: assessmentVariable.id,
        assessmentVariableName: assessmentVariable.name,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentViewModel>(
      builder: (_, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "New Assessment",
            ),
          ),
          body: Form(
            key: _formKey,
            child: Column(
                children: [
                  Expanded(
                    child: model.isLoading
                    ? const Center(
                      child: CircularProgressIndicator(),
                    )
                    : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: _expansionTilesForNewAssessmentVariables(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        // log(_newAssessment.assessmentVariablesFlights1.toString());
                        if(_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          log(_newAssessment.toString());
                          Navigator.pushNamed(
                            context,
                            NamedRoute.newAssessmentHumanFactorVariables,
                            arguments: _newAssessment,
                          );
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Please fill all the fields"),
                              duration: const Duration(milliseconds: 3000),
                              action: SnackBarAction(
                                label: 'Close',
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );
                        }
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
          ),
        );
      },
    );
  }

  List<Widget> _expansionTilesForNewAssessmentVariables() {
    inputs1.clear();
    inputs2.clear();
    List<Widget> expansionTiles = [];
    int indexOfVariable = 0;
    int startingIndexForInputsList = 0;

    for (var assessmentCategory in assessmentCategories) {
      startingIndexForInputsList = indexOfVariable;
      for (var assessmentVariable in assessmentVariables) {
        if (assessmentVariable.category == assessmentCategory) {
          buildInputFlightCrew1(assessmentVariable, indexOfVariable);
          buildInputFlightCrew2(assessmentVariable, indexOfVariable);
          indexOfVariable++;
        }
      }

      expansionTiles.add(
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: ExpansionTile(
            title: Text(assessmentCategory),
            backgroundColor: TsOneColor.primary,
            collapsedBackgroundColor: TsOneColor.surface,
            textColor: TsOneColor.onPrimary,
            collapsedTextColor: TsOneColor.onSecondary,
            iconColor: TsOneColor.onPrimary,
            collapsedIconColor: TsOneColor.onSecondary,
            collapsedShape: RoundedRectangleBorder(
              side: BorderSide(color: TsOneColor.primary.withOpacity(0.15)),
              borderRadius: BorderRadius.circular(5.0),
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: TsOneColor.primary.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(5.0),
            ),
            children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(5.0),
                    ),
                    color: TsOneColor.secondary
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0
                  ),
                  child: Column(
                    children: [
                      for (var i = startingIndexForInputsList; i < inputs1.length; i++)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              inputs1[i]["assessmentName"],
                              style: tsOneTextTheme.headlineMedium,
                            ),
                            const Text("Crew 1"),
                            ValueListenableBuilder<bool>(
                              valueListenable: _newAssessment.assessmentVariablesFlights1[i].isNotApplicableNotifier,
                              builder: (context, value, child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: ListTileTheme(
                                        horizontalTitleGap: 0.0,
                                        contentPadding: EdgeInsets.zero,
                                        child: inputs1[i]["checkbox"],
                                      ),
                                    ),
                                    !value
                                    ? Flexible(
                                        flex: 7,
                                        child: Row(
                                          children: [
                                            Flexible(
                                                flex: 5,
                                                child: inputs1[i]["dropdown1"]
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Flexible(
                                                flex: 3, child: inputs1[i]["dropdown2"]
                                            ),
                                          ],
                                        )
                                    )
                                    : const SizedBox.shrink()
                                  ],
                                );
                              },
                            ),
                            const Text("Crew 2"),
                            ValueListenableBuilder(
                              valueListenable: _newAssessment.assessmentVariablesFlights2[i].isNotApplicableNotifier,
                              builder: (context, value, child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: ListTileTheme(
                                        horizontalTitleGap: 0.0,
                                        contentPadding: EdgeInsets.zero,
                                        child: inputs2[i]["checkbox"],
                                      ),
                                    ),
                                    !value
                                    ? Flexible(
                                        flex: 7,
                                        child: Row(
                                          children: [
                                            Flexible(
                                                flex: 5,
                                                child: inputs2[i]["dropdown1"]
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Flexible(
                                                flex: 3, child: inputs2[i]["dropdown2"]
                                            ),
                                          ],
                                        )
                                    )
                                    : const SizedBox.shrink()
                                  ],
                                );
                              },
                            ),
                            const Divider(
                              color: TsOneColor.onSecondary,
                              thickness: 1.0,
                            )
                          ],
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      );
    }

    return expansionTiles;
  }

  void buildInputFlightCrew1(AssessmentVariables assessmentVariable, int indexOfVariable) {
    final checkbox = StatefulBuilder(
      builder: (context, setState) {
        return CheckboxListTile(
          title: const Text("N/A"),
          controlAffinity: ListTileControlAffinity.leading,
          value: _newAssessment.assessmentVariablesFlights1[indexOfVariable].isNotApplicable,
          dense: true,
          onChanged: (value) {
            setState(() {
              // _newAssessment.assessmentVariablesFlights1[indexOfVariable].isNotApplicable = value!;
              // _newAssessment.assessmentVariablesFlights1[indexOfVariable].reset();
              _newAssessment.assessmentVariablesFlights1[indexOfVariable].toggleIsNotApplicable();
            });
          },
        );
      }
    );

    Widget? dropdown1;
    Widget? dropdown2;

    if(assessmentVariable.typeOfAssessment == AssessmentVariables.keySatisfactory) {
      // assessment dropdown
      dropdown1 = DropdownButtonFormField(
        value: _newAssessment.assessmentVariablesFlights1[indexOfVariable].assessmentSatisfactory,
        padding: const EdgeInsets.all(0),
        isExpanded: true,
        isDense: true,
        validator: (value) {
          if (value == null) {
            return "Please select an option";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          setState(() {
            _newAssessment.assessmentVariablesFlights1[indexOfVariable].assessmentSatisfactory = value as String;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text(
            "Assessment",
            style: TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        items: AssessmentVariables.satisfactoryList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
      );
      // markers dropdown
      dropdown2 = DropdownButtonFormField(
        value: _newAssessment.assessmentVariablesFlights1[indexOfVariable].assessmentMarkers,
        validator: (value) {
          if (value == null) {
            return "Please select an option";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          setState(() {
            _newAssessment.assessmentVariablesFlights1[indexOfVariable].assessmentMarkers = value!;
          });
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintMaxLines: 1,
            label: Text(
              "Markers",
              style: TextStyle(
                fontSize: 12,
              ),
            )
        ),
        items: AssessmentVariables.markerList.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
      );
    }
    else {
      // pilot flying markers dropdown
      dropdown1 = DropdownButtonFormField(
        value: _newAssessment.assessmentVariablesFlights1[indexOfVariable].pilotFlyingMarkers,
        validator: (value) {
          if (value == null) {
            return "Please select an option";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          setState(() {
            _newAssessment.assessmentVariablesFlights1[indexOfVariable].pilotFlyingMarkers = value!;
          });
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintMaxLines: 1,
            label: Text(
              "Markers",
              style: TextStyle(
                fontSize: 12,
              ),
            )
        ),
        items: AssessmentVariables.markerList.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
      );
      // pilot monitoring markers dropdown
      dropdown2 = DropdownButtonFormField(
        value: _newAssessment.assessmentVariablesFlights1[indexOfVariable].pilotMonitoringMarkers,
        validator: (value) {
          if (value == null) {
            return "Please select an option";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          setState(() {
            _newAssessment.assessmentVariablesFlights1[indexOfVariable].pilotMonitoringMarkers = value!;
          });
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintMaxLines: 1,
            label: Text(
              "Markers",
              style: TextStyle(
                fontSize: 12,
              ),
            )
        ),
        items: AssessmentVariables.markerList.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
      );
    }

    inputs1.add({
      "checkbox": checkbox,
      "dropdown1": dropdown1,
      "dropdown2": dropdown2,
      "assessmentVariable": assessmentVariable,
      "assessmentName": assessmentVariable.name,
    });
  }

  void buildInputFlightCrew2(AssessmentVariables assessmentVariable, int indexOfVariable) {
    final checkbox = StatefulBuilder(
        builder: (context, setState) {
          return CheckboxListTile(
            title: const Text("N/A"),
            controlAffinity: ListTileControlAffinity.leading,
            value: _newAssessment.assessmentVariablesFlights2[indexOfVariable].isNotApplicable,
            dense: true,
            onChanged: (value) {
              setState(() {
                // _newAssessment.assessmentVariablesFlights2[indexOfVariable].isNotApplicable = value!;
                // _newAssessment.assessmentVariablesFlights2[indexOfVariable].reset();
                _newAssessment.assessmentVariablesFlights2[indexOfVariable].toggleIsNotApplicable();
              });
            },
          );
        }
    );

    Widget? dropdown1;
    Widget? dropdown2;

    if(assessmentVariable.typeOfAssessment == AssessmentVariables.keySatisfactory) {
      // assessment dropdown
      dropdown1 = DropdownButtonFormField(
        value: _newAssessment.assessmentVariablesFlights2[indexOfVariable].assessmentSatisfactory,
        padding: const EdgeInsets.all(0),
        isExpanded: false,
        isDense: true,
        validator: (value) {
          if (value == null) {
            return "Please select an option";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          setState(() {
            _newAssessment.assessmentVariablesFlights2[indexOfVariable].assessmentSatisfactory = value as String;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text(
            "Assessment",
            style: TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        items: AssessmentVariables.satisfactoryList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
      );
      // markers dropdown
      dropdown2 = DropdownButtonFormField(
        value: _newAssessment.assessmentVariablesFlights2[indexOfVariable].assessmentMarkers,
        validator: (value) {
          if (value == null) {
            return "Please select an option";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          setState(() {
            _newAssessment.assessmentVariablesFlights2[indexOfVariable].assessmentMarkers = value!;
          });
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintMaxLines: 1,
            label: Text(
              "Markers",
              style: TextStyle(
                fontSize: 12,
              ),
            )
        ),
        items: AssessmentVariables.markerList.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
      );
    }
    else {
      // pilot flying markers dropdown
      dropdown1 = DropdownButtonFormField(
        value: _newAssessment.assessmentVariablesFlights2[indexOfVariable].pilotFlyingMarkers,
        validator: (value) {
          if (value == null) {
            return "Please select an option";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          setState(() {
            _newAssessment.assessmentVariablesFlights2[indexOfVariable].pilotFlyingMarkers = value!;
          });
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintMaxLines: 1,
            label: Text(
              "Markers",
              style: TextStyle(
                fontSize: 12,
              ),
            )
        ),
        items: AssessmentVariables.markerList.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
      );
      // pilot monitoring markers dropdown
      dropdown2 = DropdownButtonFormField(
        value: _newAssessment.assessmentVariablesFlights1[indexOfVariable].pilotMonitoringMarkers,
        validator: (value) {
          if (value == null) {
            return "Please select an option";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          setState(() {
            _newAssessment.assessmentVariablesFlights2[indexOfVariable].pilotMonitoringMarkers = value!;
          });
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintMaxLines: 1,
            label: Text(
              "Markers",
              style: TextStyle(
                fontSize: 12,
              ),
            )
        ),
        items: AssessmentVariables.markerList.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
      );
    }

    inputs2.add({
      "checkbox": checkbox,
      "dropdown1": dropdown1,
      "dropdown2": dropdown2,
      "assessmentVariable": assessmentVariable,
      "assessmentName": assessmentVariable.name,
    });
  }

}
